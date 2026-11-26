# Скрипты Bash

Запускайте из корня репозитория через `bash scripts/имя.sh`. Для скриптов нужны Bash 4+, Linux и утилиты из таблицы. Код 2 означает неверный ввод, 127 — отсутствующую зависимость. После запуска внешнего инструмента возможны его собственные коды завершения. `disk-monitor.sh` и `inode-monitor.sh` возвращают 1 при достижении порога. Пароли PostgreSQL передавайте через штатные механизмы клиента, например закрытый файл `.pgpass`.

`system-update.sh` по умолчанию моделирует обновление с текущими индексами. `--apply` требует root, обновляет индексы и запускает APT с интерактивным подтверждением. Архивы создаются через временный файл и публикуются только при успешном завершении. Для предварительного просмотра поставьте `--dry-run` перед позиционными аргументами. Для аудита правил и SSH повышайте права только при необходимости.

| Скрипт | Назначение | Аргументы | Зависимости |
| --- | --- | --- | --- |
| [system-info.sh](system-info.sh) | Сводка системы | — | uname head |
| [cpu-topology.sh](cpu-topology.sh) | Топология CPU | — | lscpu |
| [cpu-monitor.sh](cpu-monitor.sh) | Три измерения загрузки CPU | — | mpstat |
| [memory-monitor.sh](memory-monitor.sh) | Сводка памяти и swap | — | free awk |
| [memory-pressure.sh](memory-pressure.sh) | Давление памяти PSI | — | cat |
| [disk-monitor.sh](disk-monitor.sh) | Контроль заполнения в процентах | `PATH LIMIT` | df awk |
| [inode-monitor.sh](inode-monitor.sh) | Контроль расхода inode | `PATH LIMIT` | df awk |
| [disk-layout.sh](disk-layout.sh) | Связь дисков и точек монтирования | — | lsblk |
| [mount-info.sh](mount-info.sh) | Файловая система пути | `PATH` | findmnt |
| [top-directories.sh](top-directories.sh) | Размер каталогов на одном томе | `PATH` | du sort |
| [swap-report.sh](swap-report.sh) | Использование swap | — | swapon |
| [network-check.sh](network-check.sh) | Проверка HTTP с ограничением времени | `URL` | curl |
| [dns-check.sh](dns-check.sh) | Ответы системного NSS | `HOST` | getent |
| [dns-record.sh](dns-record.sh) | Запрос выбранного типа DNS | `HOST TYPE` | dig |
| [route-check.sh](route-check.sh) | Вычисление маршрута до IPv4 | `IPV4` | ip |
| [network-interfaces.sh](network-interfaces.sh) | Статистика интерфейсов и адресов | — | ip |
| [listening-ports.sh](listening-ports.sh) | Локальные слушатели TCP и UDP | — | ss |
| [socket-summary.sh](socket-summary.sh) | Сводка состояния сокетов | — | ss |
| [service-health.sh](service-health.sh) | Проверка активности конкретной службы | `SERVICE` | systemctl |
| [failed-services.sh](failed-services.sh) | Аварийные системные службы | — | systemctl |
| [timer-report.sh](timer-report.sh) | Активные и неактивные таймеры | — | systemctl |
| [boot-timing.sh](boot-timing.sh) | Цепочка активации при загрузке | — | systemd-analyze |
| [server-health.sh](server-health.sh) | Снимок нагрузки памяти и места | — | uptime free df |
| [log-analyzer.sh](log-analyzer.sh) | Подсчёт строк уровней журнала | `FILE` | awk |
| [journal-errors.sh](journal-errors.sh) | Последние ошибки службы текущей загрузки | `SERVICE` | journalctl |
| [journal-size.sh](journal-size.sh) | Место занятое systemd journal | — | journalctl |
| [logrotate-check.sh](logrotate-check.sh) | Симуляция ротации по конфигурации | `FILE` | logrotate |
| [system-update.sh](system-update.sh) | Симуляция или подтверждённое обновление APT | — | apt-get |
| [package-owner.sh](package-owner.sh) | Поиск пакета Debian по пути | `PATH` | dpkg-query |
| [package-holds.sh](package-holds.sh) | Удерживаемые пакеты Debian | — | apt-mark |
| [backup.sh](backup.sh) | Создание gzip-архива без перезаписи | `SOURCE ARCHIVE` | tar realpath mktemp ln rm |
| [backup-verify.sh](backup-verify.sh) | Проверка чтения архива GNU tar | `ARCHIVE` | tar gzip |
| [database-backup.sh](database-backup.sh) | Логический дамп PostgreSQL в новый файл | `DATABASE ARCHIVE` | pg_dump mktemp ln rm |
| [database-verify.sh](database-verify.sh) | Чтение оглавления PostgreSQL dump | `ARCHIVE` | pg_restore |
| [file-integrity.sh](file-integrity.sh) | Сверка файла с SHA-256 | `FILE HASH` | sha256sum |
| [archive-size.sh](archive-size.sh) | Размер сжатого архива | `FILE` | stat |
| [sync-preview.sh](sync-preview.sh) | План локальной синхронизации rsync | `SOURCE DESTINATION` | rsync |
| [cert-expiry.sh](cert-expiry.sh) | Проверка срока действия локального сертификата | `FILE` | openssl |
| [ssh-audit.sh](ssh-audit.sh) | Эффективная серверная конфигурация SSH | — | sshd awk |
| [ssh-client-review.sh](ssh-client-review.sh) | Выбранные настройки профиля OpenSSH | `HOST` | ssh awk |
| [firewall-audit.sh](firewall-audit.sh) | Текущий набор правил nftables | — | nft |
| [security-audit.sh](security-audit.sh) | Неизменяющая сводка режимов безопасности | — | id ss |
| [world-writable.sh](world-writable.sh) | Обычные файлы с записью для остальных | `DIRECTORY` | find realpath |
| [docker-monitor.sh](docker-monitor.sh) | Один снимок потребления контейнеров | — | docker |
| [docker-exits.sh](docker-exits.sh) | Остановленные контейнеры и причины выхода | — | docker |
| [docker-disk.sh](docker-disk.sh) | Место занятое объектами Docker | — | docker |
| [nginx-monitor.sh](nginx-monitor.sh) | Проверка конфигурации и состояния Nginx | — | nginx systemctl |
| [postgres-ready.sh](postgres-ready.sh) | Готовность локального экземпляра PostgreSQL | — | pg_isready |
| [cpu-processes.sh](cpu-processes.sh) | Процессы с наибольшей долей CPU | — | ps awk |
| [memory-processes.sh](memory-processes.sh) | Процессы с наибольшим RSS | — | ps awk |
| [fd-usage.sh](fd-usage.sh) | Число дескрипторов процесса | `PID` | find wc |
| [cgroup-summary.sh](cgroup-summary.sh) | Членство текущего процесса и доступные контроллеры | — | cat |
| [kernel-warnings.sh](kernel-warnings.sh) | Последние предупреждения ядра | — | journalctl |
