"""Check handbook inventory, Markdown navigation, and link destinations."""

import argparse
from collections import Counter
from concurrent.futures import ThreadPoolExecutor
from os import devnull
from pathlib import Path
import re
import subprocess
from urllib.parse import unquote, urlsplit


ROOT = Path(__file__).resolve().parents[1]
LINK = re.compile(r"!?(?:\[[^\]\n]*\])\((<?[^\s>)]+>?)\)")
FENCE = re.compile(r"^ {0,3}(`{3,}|~{3,})")
HEADING = re.compile(r"^ {0,3}#{1,6}\s+(.+?)\s*#*\s*$")
LEVELS = ("beginner", "intermediate", "advanced", "expert")
CHAPTER_SECTIONS = (
    "Цели и предварительные требования",
    "Как это работает",
    "Синтаксис и практический пример",
    "Применение и диагностика",
    "Практика и самопроверка",
    "Итоги и документация",
)
REQUIRED = (
    "README.md", "CONTRIBUTING.md", "CODE_OF_CONDUCT.md", "SECURITY.md",
    "CHANGELOG.md", "ROADMAP.md", "AUTHORS.md", ".editorconfig", ".gitignore",
    ".markdownlint.json", "cheatsheets/README.md", "scripts/README.md",
    "labs/README.md", "interview/README.md", "configs/README.md",
    "assets/diagrams/README.md", "assets/images/README.md",
    "tests/scripts/smoke.sh", ".github/workflows/markdown-lint.yml",
    ".github/workflows/shellcheck.yml", ".github/workflows/link-check.yml",
)


def parse_markdown(path, errors):
    anchors = set()
    targets = []
    fence = ""
    for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        marker = FENCE.match(line)
        if marker:
            token = marker[1]
            if not fence:
                fence = token
            elif token.startswith(fence) and not line[marker.end():].strip():
                fence = ""
            continue
        if fence:
            continue
        heading = HEADING.match(line)
        if heading:
            label = re.sub(r"[^\w -]", "", heading[1].lower()).replace(" ", "-")
            candidate = label
            suffix = 1
            while candidate in anchors:
                candidate = f"{label}-{suffix}"
                suffix += 1
            anchors.add(candidate)
        for match in LINK.finditer(line):
            targets.append((number, match[1].strip("<>")))
    if fence:
        errors.append(f"{path.relative_to(ROOT)}: unclosed code fence")
    return anchors, targets


def inventory(errors):
    for name in REQUIRED:
        path = ROOT / name
        if not path.is_file() or not path.stat().st_size:
            errors.append(f"Missing required file: {name}")
    chapters = sorted((ROOT / "docs").glob("[0-9][0-9]-*.md"))
    if [c.name[:2] for c in chapters] != [f"{i:02d}" for i in range(1, 36)]:
        errors.append("Expected chapters 01 through 35 exactly once")
    for path in chapters:
        contents = path.read_text(encoding="utf-8")
        for name in CHAPTER_SECTIONS:
            if f"\n## {name}\n" not in contents:
                errors.append(f"{path.name}: missing section {name}")

    for level in LEVELS:
        entries = [p for p in (ROOT / "labs" / level).glob("*.md") if p.name != "README.md"]
        if len(entries) < 25:
            errors.append(f"{level}: expected at least 25 labs, found {len(entries)}")
        for path in entries:
            contents = path.read_text(encoding="utf-8")
            for name in ("Цель и подготовка", "Ход работы", "Полное решение", "Проверка", "Очистка"):
                if f"\n## {name}\n" not in contents:
                    errors.append(f"{path.name}: missing section {name}")

    commands = (ROOT / "cheatsheets/linux-commands.md").read_text(encoding="utf-8")
    examples = set(re.findall(r"^\| [^\n]+? \| `([^`\n]+)` \|", commands, re.M))
    questions = Counter(
        line
        for path in (ROOT / "interview").glob("*.md")
        if path.name != "README.md"
        for line in path.read_text(encoding="utf-8").splitlines()
        if line.startswith("### ") and line.endswith("?")
    )
    for question, count in questions.items():
        if count > 1:
            errors.append(f"Duplicate interview question: {question}")
    scripts = list((ROOT / "scripts").glob("*.sh"))
    for name, count, minimum in (
        ("command examples", len(examples), 300),
        ("interview questions", len(questions), 200),
        ("Bash entry points", len(scripts), 50),
    ):
        print(f"{name}: {count}")
        if count < minimum:
            errors.append(f"Expected at least {minimum} {name}, found {count}")
    print(f"Chapters: {len(chapters)}")


def check_external(url):
    common = ["curl", "--silent", "--show-error", "--location", "--max-redirs", "5",
              "--connect-timeout", "8", "--max-time", "20", "--output", devnull,
              "--write-out", "%{http_code}", "--proto", "=https", "--proto-redir", "=https"]
    result = subprocess.run([*common, "--head", "--", url], capture_output=True, text=True)
    if result.returncode != 0 or result.stdout in {"403", "405", "501"}:
        result = subprocess.run([*common, "--range", "0-0", "--", url], capture_output=True, text=True)
    if result.returncode == 0 and result.stdout.startswith("2"):
        return None
    return f"{url}: HTTP {result.stdout or 'unavailable'} (curl {result.returncode})"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--external", action="store_true", help="Check HTTPS destinations")
    args = parser.parse_args()
    errors = []
    inventory(errors)
    docs = {
        path: parse_markdown(path, errors)
        for path in ROOT.rglob("*.md")
        if not {".git", "node_modules", ".venv"}.intersection(path.relative_to(ROOT).parts)
    }
    external = set()
    local_links = 0
    for path, (_, links) in docs.items():
        for number, target in links:
            address = urlsplit(target)
            if address.scheme or address.netloc:
                if address.scheme == "https":
                    clean = address._replace(fragment="").geturl()
                    # Badge images depend on workflow registration on the default branch.
                    if not clean.endswith("/badge.svg"):
                        external.add(clean)
                continue
            local_links += 1
            dest = (path.parent / unquote(address.path)).resolve() if address.path else path
            location = f"{path.relative_to(ROOT)}:{number}"
            if not dest.is_relative_to(ROOT) or not dest.exists():
                errors.append(f"{location}: invalid path {target}")
            elif address.fragment and dest in docs and unquote(address.fragment) not in docs[dest][0]:
                errors.append(f"{location}: missing anchor {target}")

    print(f"Markdown files: {len(docs)}, local links: {local_links}")
    if args.external:
        with ThreadPoolExecutor(max_workers=8) as pool:
            errors.extend(result for result in pool.map(check_external, sorted(external)) if result)
        print(f"HTTPS destinations: {len(external)}")
    for error in errors:
        print(error)
    return int(bool(errors))


if __name__ == "__main__":
    raise SystemExit(main())
