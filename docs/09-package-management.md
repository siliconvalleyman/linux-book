# 09. Управление пакетами

## Цели и предварительные требования

Проверять происхождение пакета и план обновления.

Понадобится Ubuntu или Debian с настроенными репозиториями.

## Как это работает

Менеджер пакетов сверяет подписанные метаданные и разрешает зависимости. APT использует индекс репозитория, а dpkg хранит сведения об установленных пакетах. Индекс и установленные версии изменяются разными операциями.

Для Gentoo используйте `emerge -p app-editors/vim` для предварительного просмотра. В NixOS приложение можно добавить в `environment.systemPackages` и проверить конфигурацию через `nixos-rebuild build`. Linux Mint и Kali используют APT, но их репозитории и политика обновления различаются. Rocky Linux и AlmaLinux используют DNF.

В автоматизации используйте apt-get и apt-cache, поскольку apt оптимизирован для чтения человеком. Для Arch перед установкой из свежего индекса обновляйте систему полностью. При подготовке обновления проверьте запас места, возможный перезапуск служб и способ отката данных.

## Синтаксис и практический пример

```bash
apt-cache policy bash
```

Подкоманда policy показывает установленную и выбранную версии и приоритеты источников APT.

Ожидаемый результат для примера. Строки Installed и Candidate могут иметь одинаковые версии. Вывод зависит от локали и источников.

## Справочные примеры

> Команды ниже предназначены для учебной среды. Операции с `sudo`, разделами, сетью, системными службами и учётными записями выполняйте только в одноразовой ВМ с доступом к её консоли.

### Управление пакетами

> **Внимание.** Изменения из этого раздела выполняйте только в одноразовой ВМ со снимком.

#### Debian / Ubuntu — APT

```bash
sudo apt update
sudo apt upgrade
sudo apt install nginx
sudo apt remove nginx
sudo apt purge nginx
sudo apt autoremove
```

```bash
apt search nginx
apt show nginx
apt list --installed
```

Установка локального DEB-пакета:

```bash
sudo apt install ./package.deb
```

#### Fedora / RHEL — DNF

```bash
sudo dnf check-update
sudo dnf upgrade
sudo dnf install nginx
sudo dnf remove nginx
dnf search nginx
```

#### Arch Linux — Pacman

```bash
sudo pacman -Syu
sudo pacman -S nginx
sudo pacman -R nginx
pacman -Ss nginx
```

#### Alpine Linux — APK

```bash
sudo apk update
sudo apk upgrade
sudo apk add nginx
sudo apk del nginx
```

#### openSUSE — Zypper

```bash
sudo zypper refresh
sudo zypper update
sudo zypper install nginx
sudo zypper remove nginx
```

#### Snap

```bash
snap find code
sudo snap install code --classic
snap list
sudo snap refresh
```

#### Flatpak

```bash
flatpak search firefox
flatpak install flathub org.mozilla.firefox
flatpak update
flatpak list
```

## Применение и диагностика

При конфликте зависимостей сравните candidate и приоритет pinning, затем выполните симуляцию apt-get -s upgrade.

Перед добавлением репозитория проверяйте владельца ключа. На Arch не выполняйте частичные обновления через pacman -Sy пакет.

## Практика и самопроверка

1. Сравните apt-cache policy bash с dpkg-query -W bash.
2. Почему apt update не равно apt upgrade?

## Итоги и документация

На практике важно проверять происхождение пакета и план обновления. Обоснуйте вывод наблюдаемыми признаками из учебного примера.

- [Документация по теме](https://www.debian.org/doc/manuals/debian-reference/ch02.en.html)

[Предыдущая глава](08-permissions.md) · [Оглавление](../README.md) · [Следующая глава](10-process-management.md)
