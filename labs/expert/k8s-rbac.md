# Сравнение разрешений учётной записи

| Уровень | Время |
| --- | --- |
| Экспертный | 20 мин |

## Цель и подготовка

Назначьте ServiceAccount чтение Pod в выделенном namespace и сравните с удалением.

Понадобится Локальный кластер, права RBAC и impersonation. Выполняйте команды только в одноразовой учебной ВМ. Перед изменениями кластера или Docker подтвердите, что работаете с локальным стендом.

Откройте Bash и подготовьте рабочий каталог.

```bash
previous_directory=$PWD
lab=$(mktemp -d "${TMPDIR:-/tmp}/handbook.XXXXXXXX")
cd -- "$lab"
```

## Ход работы

1. Выполните описанное действие в подготовленном каталоге. Используйте команды из решения, если нужно сверить последовательность.
2. get разрешён, delete запрещён. Сначала проверьте вывод, затем запустите проверку ниже.
3. При Forbidden нужна учебная роль для impersonation.

## Полное решение

```bash
kubectl config current-context
namespace="handbook-$BASHPID"
kubectl create ns "$namespace"
kubectl -n "$namespace" create sa reader
kubectl -n "$namespace" create role pod-reader --verb=get,list --resource=pods
kubectl -n "$namespace" create rolebinding reader --role=pod-reader --serviceaccount="$namespace:reader"
```

## Проверка

```bash
kubectl -n "$namespace" auth can-i get pods --as="system:serviceaccount:$namespace:reader" && ! kubectl -n "$namespace" auth can-i delete pods --as="system:serviceaccount:$namespace:reader"
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
