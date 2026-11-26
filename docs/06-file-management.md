# 06. Файлы, поиск и архивы

## Цели и предварительные требования

Безопасно искать файлы, работать со ссылками и проверять архив.

Понадобится Bash и временный каталог.

## Как это работает

Имя файла — запись в каталоге. Жёсткие ссылки разделяют inode, символическая ссылка хранит путь. Архивация объединяет объекты, сжатие преобразует байтовый поток; раздельная проверка этих этапов упрощает восстановление.

Сохраняйте атрибуты при переносе служебного дерева: cp -a сохраняет основные метаданные, а для архива проверьте поддержку ACL и xattrs на обоих концах. Перенос между файловыми системами обычно сводится к копированию с удалением источника после успеха, поэтому он не обладает атомарностью rename в пределах одной ФС.

## Синтаксис и практический пример

```bash
find . -maxdepth 1 -type f -name '*.txt' -print
```

Параметр -maxdepth ограничивает глубину, -type выбирает обычные файлы, кавычки передают шаблон самой find.

Ожидаемый результат для примера. Для файла notes.txt рядом с вами появится ./notes.txt. При отсутствии совпадений вывод пуст.

## Справочные примеры

> Команды ниже предназначены для учебной среды. Операции с `sudo`, разделами, сетью, системными службами и учётными записями выполняйте только в одноразовой ВМ с доступом к её консоли.

### Работа с файлами и каталогами

> **Внимание.** Изменения из этого раздела выполняйте только в одноразовой ВМ со снимком.

#### Навигация

```bash
pwd
ls
ls -l
ls -a
ls -lh
ls -lah
```

```bash
cd /etc
cd ..
cd ~
cd -
cd /
```

#### Создание файлов

```bash
touch file.txt
touch file1.txt file2.txt
```

#### Создание каталогов

```bash
mkdir projects
mkdir -p projects/backend/src
```

#### Копирование

```bash
cp file.txt backup.txt
cp -r projects projects-backup
cp -i file.txt /tmp/
```

#### Перемещение и переименование

```bash
mv file.txt new-file.txt
mv new-file.txt /tmp/
```

#### Удаление

```bash
rm file.txt
rm -i file.txt
rmdir empty-directory
rm -r projects-backup
```

> Внимание: команда `rm` обычно удаляет файлы без перемещения в корзину. Всегда проверяйте путь перед рекурсивным удалением.

#### Просмотр содержимого

```bash
cat file.txt
less file.txt
more file.txt
head file.txt
tail file.txt
```

Просмотр последних 20 строк:

```bash
tail -n 20 file.txt
```

Наблюдение за изменениями файла:

```bash
tail -f application.log
```

#### Информация о файлах

```bash
file file.txt
stat file.txt
wc -l file.txt
wc -w file.txt
```

#### Символические и жёсткие ссылки

```bash
ln file.txt hardlink.txt
ln -s file.txt symlink.txt
```

- Hard link — дополнительное имя того же inode.
- Symbolic link — ссылка на путь другого файла.

### Поиск файлов и текста

#### find

Поиск по имени:

```bash
find /home -name "*.txt"
```

Поиск без учёта регистра:

```bash
find /home -iname "*.pdf"
```

Поиск каталогов:

```bash
find /home -type d -name "projects"
```

Поиск файлов размером более 100 МБ:

```bash
find /home -type f -size +100M
```

Поиск недавно изменённых файлов:

```bash
find /home -type f -mtime -7
```

#### grep

```bash
grep "error" application.log
grep -i "error" application.log
grep -n "error" application.log
grep -r "localhost" ./src
grep -v "debug" application.log
```

Использование регулярных выражений:

```bash
grep -E "error|warning" application.log
```

#### locate

```bash
locate nginx.conf
```

Обновление базы поиска:

```bash
sudo updatedb
```

Для использования `locate` может потребоваться установка пакета `plocate`.

#### Дополнительные инструменты

```bash
which python3
whereis bash
command -v git
```

### Архивирование и сжатие

#### TAR

Создание архива:

```bash
tar -cvf archive.tar project/
```

Распаковка:

```bash
tar -xvf archive.tar
```

#### TAR.GZ

```bash
tar -czvf archive.tar.gz project/
tar -xzvf archive.tar.gz
```

#### TAR.XZ

```bash
tar -cJvf archive.tar.xz project/
tar -xJvf archive.tar.xz
```

#### ZIP

```bash
zip -r archive.zip project/
unzip archive.zip
```

#### GZIP

```bash
gzip file.txt
gunzip file.txt.gz
```

#### Просмотр содержимого архива

```bash
tar -tf archive.tar.gz
unzip -l archive.zip
```

Перед распаковкой неизвестных архивов рекомендуется проверять их содержимое.

## Применение и диагностика

Если имя с переводом строки ломает конвейер, используйте find -print0 и потребителя, поддерживающего NUL.

Удаление и распаковку проверяйте в одноразовом каталоге. Не извлекайте недоверенный архив в домашний каталог с привилегиями root.

## Практика и самопроверка

1. Создайте файл и две ссылки на него во временном каталоге. Сравните номера inode через ls -li.
2. Что произойдёт с каждым типом ссылки после смены имени исходного файла?

## Итоги и документация

На практике важно безопасно искать файлы, работать со ссылками и проверять архив. Обоснуйте вывод наблюдаемыми признаками из учебного примера.

- [Документация по теме](https://www.gnu.org/software/coreutils/manual/)

[Предыдущая глава](05-terminal.md) · [Оглавление](../README.md) · [Следующая глава](07-users-and-groups.md)
