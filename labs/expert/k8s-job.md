# Одноразовое задание Kubernetes

| Уровень | Время |
| --- | --- |
| Экспертный | 25 мин |

## Цель и подготовка

Создайте Job в отдельном пространстве, дождитесь завершения и прочитайте журнал.

Понадобится Локальный кластер с доступом к busybox:stable. Выполняйте команды только в одноразовой учебной ВМ. Перед изменениями кластера или Docker подтвердите, что работаете с локальным стендом.

Откройте Bash и подготовьте рабочий каталог.

```bash
previous_directory=$PWD
lab=$(mktemp -d "${TMPDIR:-/tmp}/handbook.XXXXXXXX")
cd -- "$lab"
```

## Ход работы

1. Выполните описанное действие в подготовленном каталоге. Используйте команды из решения, если нужно сверить последовательность.
2. Job имеет Complete, журнал содержит completed. Сначала проверьте вывод, затем запустите проверку ниже.
3. При ImagePullBackOff проверьте доступ worker к реестру.

## Полное решение

```bash
kubectl config current-context
namespace="handbook-$BASHPID"
kubectl create ns "$namespace"
kubectl -n "$namespace" create job check --image=busybox:stable -- echo completed
kubectl -n "$namespace" wait --for=condition=complete job/check --timeout=90s
```

## Проверка

```bash
kubectl -n "$namespace" logs job/check | grep -Fx completed
```

Ожидается код 0. Если команда печатает результат, сопоставьте его с ожидаемым состоянием из задания.

## Очистка

Завершите созданные ресурсы и удалите файлы временного каталога. Для упражнений, меняющих состояние системы или кластера, при частичном сбое верните снимок ВМ.

```bash
kubectl delete namespace "$namespace" --wait=false
cd -- "$previous_directory" &&
    [[ ${lab:-} == "${TMPDIR:-/tmp}"/handbook.???????? && -d $lab && ! -L $lab ]] &&
    find "$lab" -xdev -depth -mindepth 1 -delete &&
    rmdir -- "$lab"
```

[Все упражнения](README.md)
