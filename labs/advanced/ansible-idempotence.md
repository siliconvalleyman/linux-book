# Повторный запуск модуля Ansible

| Уровень | Время |
| --- | --- |
| Продвинутый | 20 мин |

## Цель и подготовка

Создайте учебный каталог встроенным модулем file и повторите запуск.

Понадобится ansible-core, Python 3. Выполняйте команды только в одноразовой учебной ВМ. Перед изменениями кластера или Docker подтвердите, что работаете с локальным стендом.

Откройте Bash и подготовьте рабочий каталог.

```bash
previous_directory=$PWD
lab=$(mktemp -d "${TMPDIR:-/tmp}/handbook.XXXXXXXX")
cd -- "$lab"
```

## Ход работы

1. Выполните описанное действие в подготовленном каталоге. Используйте команды из решения, если нужно сверить последовательность.
2. Второй вызов показывает SUCCESS и changed false. Сначала проверьте вывод, затем запустите проверку ниже.
3. Проверьте, что вывод CLI в обычном, а не минимальном формате.

## Полное решение

```bash
ansible localhost -i localhost, -c local -m ansible.builtin.file -a "path=$lab/artifact state=directory mode=0700"
ansible localhost -i localhost, -c local -m ansible.builtin.file -a "path=$lab/artifact state=directory mode=0700" > replay
```

## Проверка

```bash
test -d artifact && grep -E '"changed": false' replay
```

Ожидается код 0. Если команда печатает результат, сопоставьте его с ожидаемым состоянием из задания.

## Очистка

Завершите созданные ресурсы и удалите файлы временного каталога. Для упражнений, меняющих состояние системы или кластера, при частичном сбое верните снимок ВМ.

```bash
cd -- "$previous_directory" &&
    [[ ${lab:-} == "${TMPDIR:-/tmp}"/handbook.???????? && -d $lab && ! -L $lab ]] &&
    find "$lab" -xdev -depth -mindepth 1 -delete &&
    rmdir -- "$lab"
```

[Все упражнения](README.md)
