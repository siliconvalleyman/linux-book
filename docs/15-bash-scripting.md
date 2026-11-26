# 15. Программирование на Bash

## Цели и предварительные требования

Объяснять работу компонентов темы «Программирование на Bash» и проверять их состояние на практике.

Понадобится Bash, копия репозитория и глава о терминале.

## Как это работает

Опция -n проверяет синтаксис. Ненулевой статус может представлять ожидаемое отсутствие совпадений; set -e пропускает ошибки в ряде условных контекстов.

Строгий режим дополняют явными проверками. Используйте if для ожидаемых неуспехов, например сравнения или поиска. Кавычки вокруг параметров обязаны сохранять пустой аргумент. Для публикации создавайте временный файл на том же томе, проверяйте результат и применяйте операцию без перезаписи.

## Синтаксис и практический пример

```bash
bash -n scripts/system-info.sh
```

Ожидаемый результат для примера. При синтаксически корректном файле вывод пустой, статус 0.

## Справочные примеры

> Команды ниже предназначены для учебной среды. Операции с `sudo`, разделами, сетью, системными службами и учётными записями выполняйте только в одноразовой ВМ с доступом к её консоли.

### Bash Scripting

Bash позволяет автоматизировать системные задачи.

#### Первый скрипт

```bash
#!/usr/bin/env bash

echo "Hello, Linux!"
```

Запуск:

```bash
chmod +x script.sh
./script.sh
```

#### Переменные

```bash
#!/usr/bin/env bash

name="Developer"

echo "Hello, $name"
```

#### Ввод данных

```bash
#!/usr/bin/env bash

read -r -p "Enter your name: " name

echo "Hello, $name"
```

#### Условные операторы

```bash
#!/usr/bin/env bash

if [[ -f "/etc/passwd" ]]; then
    echo "File exists"
else
    echo "File not found"
fi
```

#### Сравнение чисел

```bash
#!/usr/bin/env bash

number=10

if (( number > 5 )); then
    echo "Greater than 5"
fi
```

#### Цикл for

```bash
#!/usr/bin/env bash

for number in {1..5}; do
    echo "$number"
done
```

#### Цикл while

```bash
#!/usr/bin/env bash

counter=1

while (( counter <= 5 )); do
    echo "$counter"
    ((counter += 1))
done
```

#### Функции

```bash
#!/usr/bin/env bash

greet() {
    echo "Hello, $1"
}

greet "Linux"
```

#### Массивы

```bash
#!/usr/bin/env bash

languages=("Python" "JavaScript" "Go" "Rust")

for language in "${languages[@]}"; do
    echo "$language"
done
```

#### Аргументы командной строки

```bash
#!/usr/bin/env bash

echo "Script: $0"
echo "First argument: ${1:-}"
echo "Arguments count: $#"
```

#### Обработка ошибок

```bash
#!/usr/bin/env bash

set -euo pipefail

trap 'echo "Error on line $LINENO" >&2' ERR

mkdir -p ./backup
cp ./file.txt ./backup/

echo "Backup completed"
```

#### Коды завершения

```bash
echo $?
```

- `0` — успешное выполнение.
- Ненулевой код — ошибка или другой статус команды.

#### Проверка скриптов

```bash
bash -n script.sh
bash -x script.sh
shellcheck script.sh
```

## Применение и диагностика

Для цепочек проверяйте pipefail, а для временных файлов — trap EXIT. Избегайте bash -x с секретами.

## Практика и самопроверка

1. Создайте скрипт, который возвращает 2 при неправильном числе аргументов.
2. Почему кавычки вокруг массива аргументов должны иметь форму "${args[@]}"?

## Итоги и документация

На практике важно объяснять работу компонентов темы «Программирование на Bash» и проверять их состояние на практике. Обоснуйте вывод наблюдаемыми признаками из учебного примера.

- [Документация по теме](https://www.gnu.org/software/bash/manual/)

[Предыдущая глава](14-disk-management.md) · [Оглавление](../README.md) · [Следующая глава](16-automation.md)
