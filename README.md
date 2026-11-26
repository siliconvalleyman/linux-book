# Linux Handbook — практический справочник по Linux

[![Markdown](https://github.com/siliconvalleyman/linux-book/actions/workflows/markdown-lint.yml/badge.svg)](https://github.com/siliconvalleyman/linux-book/actions/workflows/markdown-lint.yml)
[![Bash](https://github.com/siliconvalleyman/linux-book/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/siliconvalleyman/linux-book/actions/workflows/shellcheck.yml)
[![Ссылки](https://github.com/siliconvalleyman/linux-book/actions/workflows/link-check.yml/badge.svg)](https://github.com/siliconvalleyman/linux-book/actions/workflows/link-check.yml)

Русскоязычное руководство для разработчиков, системных администраторов, DevOps-инженеров и специалистов по защите инфраструктуры. Практика строится вокруг воспроизводимых задач с проверяемым результатом, от первой команды Bash до диагностики ядра и реагирования на инциденты.

## Содержание

- [Маршруты обучения](#маршруты-обучения)
- [Главы](#главы)
- [Практика и справочники](#практика-и-справочники)
- [Среда и дистрибутивы](#среда-и-дистрибутивы)
- [Структура проекта](#структура-проекта)
- [Вклад и безопасность](#вклад-и-безопасность)
- [Лицензирование](#лицензирование)
- [Источники](#источники)

## Маршруты обучения

| Уровень | Что изучить | Проверка навыка |
| --- | --- | --- |
| Начальный | Главы 1–9, терминал, файлы, пакеты и права | Соберите проект из отдельных файлов, задайте режимы и восстановите содержимое из архива |
| Средний | Главы 10–18, процессы, systemd, SSH, сети и сценарии Bash | Диагностируйте локальную службу, настройте расписание и проверьте восстановление |
| Продвинутый | Главы 19–31, серверы, контейнеры, хранилища и автоматизация | Запустите локальный прокси, воспроизведите конфигурацию и проверьте план доставки |
| Экспертный | Главы 23, 28 и 32–35, ядро, производительность и реагирование | Измерьте давление на ресурсы и составьте проверяемую хронологию учебного инцидента |

Перечень навыков, сроки и дополнительные задания приведены в [плане обучения](docs/study-plan.md).

## Главы

1. [Введение в Linux](docs/01-introduction.md)
2. [Установка Linux](docs/02-installation.md)
3. [Архитектура и загрузка Linux](docs/03-linux-architecture.md)
4. [Файловая система](docs/04-filesystem.md)
5. [Терминал и оболочка](docs/05-terminal.md)
6. [Файлы, поиск и архивы](docs/06-file-management.md)
7. [Пользователи и группы](docs/07-users-and-groups.md)
8. [Права доступа](docs/08-permissions.md)
9. [Управление пакетами](docs/09-package-management.md)
10. [Управление процессами](docs/10-process-management.md)
11. [Службы systemd](docs/11-systemd.md)
12. [Сетевая диагностика](docs/12-networking.md)
13. [Удалённый доступ по SSH](docs/13-ssh.md)
14. [Диски и монтирование](docs/14-disk-management.md)
15. [Программирование на Bash](docs/15-bash-scripting.md)
16. [Автоматизация по расписанию](docs/16-automation.md)
17. [Защита Linux](docs/17-security.md)
18. [Мониторинг и журналы](docs/18-monitoring.md)
19. [Веб-сервер Nginx](docs/19-nginx.md)
20. [Контейнеры Docker](docs/20-docker.md)
21. [Git и совместная работа](docs/21-git.md)
22. [Резервное копирование и восстановление](docs/22-backup.md)
23. [Ядро Linux](docs/23-linux-kernel.md)
24. [Методика диагностики](docs/24-troubleshooting.md)
25. [SELinux и AppArmor](docs/25-selinux-and-apparmor.md)
26. [LVM и RAID](docs/26-lvm-and-raid.md)
27. [Виртуализация и KVM](docs/27-virtualization.md)
28. [Оркестрация Kubernetes](docs/28-kubernetes.md)
29. [Конфигурация с Ansible](docs/29-ansible.md)
30. [Инфраструктура с Terraform](docs/30-terraform.md)
31. [Непрерывная интеграция и доставка](docs/31-cicd.md)
32. [Анализ производительности](docs/32-performance-tuning.md)
33. [Пространства имён и cgroups](docs/33-namespaces-and-cgroups.md)
34. [Наблюдаемость с eBPF](docs/34-ebpf.md)
35. [Реагирование на инциденты](docs/35-incident-response.md)

## Практика и справочники

- [310 команд и примеров](cheatsheets/linux-commands.md) и [тематические шпаргалки](cheatsheets/README.md).
- [53 Bash-скрипта](scripts/README.md) для повседневной диагностики, аудита и резервирования.
- [100 практических лабораторий](labs/README.md) с проверками и решениями.
- [201 вопрос для собеседований](interview/README.md) с разбором теории и практических ситуаций.
- [Конфигурации Nginx, systemd, OpenSSH и Docker](configs/README.md).
- [Схемы архитектуры](assets/diagrams/README.md).

## Среда и дистрибутивы

Основной стенд — одноразовая виртуальная машина Ubuntu Server или Debian со снимком и доступом к консоли. WSL подходит для Bash и Git. Главы о загрузке, монтировании и системной изоляции требуют полноценной Linux-ВМ.

| Дистрибутивы | Пакеты и особенности |
| --- | --- |
| Ubuntu, Debian, Linux Mint, Kali Linux | APT и dpkg. Для лабораторий используются Ubuntu и Debian |
| Fedora, RHEL, Rocky Linux, AlmaLinux | DNF и RPM. SELinux проверяйте по фактическому режиму |
| Arch Linux | pacman, обновление всего набора пакетов |
| Alpine Linux | apk, musl, BusyBox, обычно OpenRC |
| openSUSE | Zypper и RPM |
| NixOS | Декларативная конфигурация Nix и nixos-rebuild |
| Gentoo | Portage и emerge. Службы зависят от профиля и выбранной системы init |

## Структура проекта

| Путь | Что здесь |
| --- | --- |
| [docs](docs/) | Главы и маршрут обучения |
| [cheatsheets](cheatsheets/) | Быстрый поиск команды и параметров |
| [scripts](scripts/) | Bash-утилиты и инструкции |
| [labs](labs/) | Упражнения четырёх уровней |
| [interview](interview/) | Вопросы и ситуационные задачи |
| [configs](configs/) | Образцы сервисов и контейнеров |
| [resources](resources/) | Книги, курсы и первоисточники |
| [tests](tests/README.md) | Автоматические проверки |

## Вклад и безопасность

Правила подготовки изменений и работы с учебными стендами описаны в [правилах вклада](CONTRIBUTING.md) и [политике безопасности](SECURITY.md). Потенциально опасные административные команды выполняйте только в одноразовой ВМ. В [дорожной карте](ROADMAP.md) отражён статус работ.

## Лицензирование

В исходном руководстве предложена лицензия MIT. Для её применения нужны согласие и данные правообладателя. Сведения о вкладе приведены в [разделе об авторах](AUTHORS.md).

## Источники

- [Официальная документация Linux и инструментов](resources/useful-links.md).
- [Книги](resources/books.md), [курсы](resources/courses.md) и [сертификации](resources/certifications.md).
