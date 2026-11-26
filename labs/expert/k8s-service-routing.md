# Сопоставление Service и Pod

| Уровень | Время |
| --- | --- |
| Экспертный | 25 мин |

## Цель и подготовка

Создайте Deployment и Service, затем проверьте привязанный EndpointSlice.

Понадобится Локальный кластер с образом nginx:alpine. Выполняйте команды только в одноразовой учебной ВМ. Перед изменениями кластера или Docker подтвердите, что работаете с локальным стендом.

Откройте Bash и подготовьте рабочий каталог.

```bash
previous_directory=$PWD
lab=$(mktemp -d "${TMPDIR:-/tmp}/handbook.XXXXXXXX")
cd -- "$lab"
```

## Ход работы

1. Выполните описанное действие в подготовленном каталоге. Используйте команды из решения, если нужно сверить последовательность.
2. Service соответствует метке Deployment и получает готовую конечную точку. Сначала проверьте вывод, затем запустите проверку ниже.
3. Если Pod уже готов, подождите синхронизации контроллера EndpointSlice.

## Полное решение

```bash
kubectl config current-context
namespace="handbook-$BASHPID"
kubectl create ns "$namespace"
kubectl -n "$namespace" create deployment web --image=nginx:alpine
kubectl -n "$namespace" expose deployment web --port=80
kubectl -n "$namespace" rollout status deployment/web --timeout=90s
```

## Проверка

```bash
kubectl -n "$namespace" get endpointslice -l kubernetes.io/service-name=web -o jsonpath='{.items[*].endpoints[*].conditions.ready}' | grep -w true
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
