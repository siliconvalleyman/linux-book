# Учебное зеркало на двух файлах

| Уровень | Время |
| --- | --- |
| Продвинутый | 30 мин |

## Цель и подготовка

Создайте зеркало только из двух только что выделенных loop-устройств.

Понадобится Одноразовая ВМ, sudo, mdadm, util-linux, свободный /dev/md127. Выполняйте команды только в одноразовой учебной ВМ. Перед изменениями кластера или Docker подтвердите, что работаете с локальным стендом.

Откройте Bash и подготовьте рабочий каталог.

```bash
previous_directory=$PWD
lab=$(mktemp -d "${TMPDIR:-/tmp}/handbook.XXXXXXXX")
cd -- "$lab"
```

## Ход работы

1. Выполните описанное действие в подготовленном каталоге. Используйте команды из решения, если нужно сверить последовательность.
2. В отчёте Raid Level raid1. Сначала проверьте вывод, затем запустите проверку ниже.
3. При конфликте имени выберите свободный массив в чистом снимке.

## Полное решение

```bash
truncate -s 64M a.img b.img
a=$(sudo losetup --find --show "$lab/a.img")
b=$(sudo losetup --find --show "$lab/b.img")
if [[ ! -e /dev/md127 ]] && sudo mdadm --create /dev/md127 --run --level=1 --raid-devices=2 "$a" "$b"; then
    array=/dev/md127
fi
```

## Проверка

```bash
LC_ALL=C sudo mdadm --detail "${array:?No lab array was created}" | grep -E 'Raid Level[[:space:]]*:[[:space:]]*raid1'
```

Ожидается код 0. Если команда печатает результат, сопоставьте его с ожидаемым состоянием из задания.

## Очистка

Завершите созданные ресурсы и удалите файлы временного каталога. Для упражнений, меняющих состояние системы или кластера, при частичном сбое верните снимок ВМ.

```bash
if [[ -n ${array:-} ]]; then
    sudo mdadm --stop "$array"
fi; sudo losetup -d "$a" "$b"
cd -- "$previous_directory" &&
    [[ ${lab:-} == "${TMPDIR:-/tmp}"/handbook.???????? && -d $lab && ! -L $lab ]] &&
    find "$lab" -xdev -depth -mindepth 1 -delete &&
    rmdir -- "$lab"
```

[Все упражнения](README.md)
