# Проверки

Из корня репозитория выполните команды. Для Bash-проверок используйте Linux с GNU coreutils, GNU tar и Bash.

```bash
python3 tests/validate_docs.py
python3 tests/validate_docs.py --external
bash -n scripts/lib/common.bash
bash tests/scripts/smoke.sh
shellcheck -x scripts/*.sh scripts/lib/common.bash tests/scripts/*.sh
npx --yes markdownlint-cli2@0.18.1 '**/*.md' '.github/**/*.md'
```

Тесты запускают справку всех скриптов, проверяют неверные аргументы, создание и восстановление архива во временном каталоге, контроль хеша и предварительный просмотр базы. Сетевые адреса и рабочие службы нужны для отдельных лабораторий, а не для базового набора тестов.
