# 19. Веб-сервер Nginx

## Цели и предварительные требования

Объяснять работу компонентов темы «Веб-сервер Nginx» и проверять их состояние на практике.

Понадобится Ubuntu или Debian с установленным Nginx.

## Как это работает

Опция -t проверяет синтаксис и доступность зависимых файлов. Блок server выбирается по адресу и имени, location определяет обработчик ресурса.

Распределение запросов зависит от состояния upstream и размера пула соединений. Ошибки соединения проявляются через журнал и upstream_status; рост request_time при низком upstream_response_time может включать задержку клиентского ввода или вывода. Проверьте таймауты, URI после proxy_pass и область доверия forwarded-заголовков.

## Синтаксис и практический пример

```bash
nginx -t
```

Ожидаемый результат для примера. При валидной конфигурации появляются сообщения syntax is ok и test is successful.

## Справочные примеры

> Команды ниже предназначены для учебной среды. Операции с `sudo`, разделами, сетью, системными службами и учётными записями выполняйте только в одноразовой ВМ с доступом к её консоли.

### Веб-сервер Nginx

> **Внимание.** Изменения из этого раздела выполняйте только в одноразовой ВМ со снимком.

Nginx — высокопроизводительный веб-сервер, обратный прокси-сервер и балансировщик нагрузки.

#### Установка

```bash
sudo apt update
sudo apt install nginx
sudo systemctl enable --now nginx
```

#### Основные каталоги Ubuntu

```text
/etc/nginx/
/etc/nginx/nginx.conf
/etc/nginx/sites-available/
/etc/nginx/sites-enabled/
/var/www/html/
/var/log/nginx/
```

#### Статический сайт

```nginx
server {
    listen 80;
    server_name example.com;

    root /var/www/example.com;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

#### Reverse Proxy

Пример проксирования запросов к Node.js-приложению:

```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For
                         $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Сохраните конфигурацию в `sites-available` и создайте символическую ссылку в `sites-enabled`.

#### Проверка конфигурации

```bash
sudo nginx -t
sudo systemctl reload nginx
```

#### HTTPS

При настроенном домене и доступном веб-сервере:

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d example.com
```

Проверка автоматического продления сертификата:

```bash
sudo certbot renew --dry-run
```

## Применение и диагностика

При 502 проверьте адрес upstream и журналы ошибок. Доверяйте заголовкам клиента только через настроенные доверенные прокси.

## Практика и самопроверка

1. В ВМ проверьте конфигурацию перед reload и сравните заголовки успешного ответа и 404.
2. Как trailing slash в proxy_pass меняет передачу URI?

## Итоги и документация

На практике важно объяснять работу компонентов темы «Веб-сервер Nginx» и проверять их состояние на практике. Обоснуйте вывод наблюдаемыми признаками из учебного примера.

- [Документация по теме](https://nginx.org/en/docs/)

[Предыдущая глава](18-monitoring.md) · [Оглавление](../README.md) · [Следующая глава](20-docker.md)
