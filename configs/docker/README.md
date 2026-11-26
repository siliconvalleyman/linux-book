# Docker Compose

Два приложения возвращают короткий ответ для проверки маршрута. Nginx публикуется на `127.0.0.1:18086`. Redis и PostgreSQL доступны только через изолированную compose-сеть `data`. Для PostgreSQL сгенерируйте отдельный секрет вне репозитория и укажите путь к нему в `POSTGRES_PASSWORD_FILE_HOST`. Compose смонтирует его в контейнер. Проверьте режим и владельца файла в соответствии с настройками локального Docker.

Проверьте `docker compose config --quiet`, затем запустите `docker compose up -d --build`. Адреса `/node/` и `/python/` должны возвращать HTTP 200 через порт 18086. Проверьте PostgreSQL командой `docker compose exec postgres pg_isready -U postgres`, Redis — `docker compose exec redis redis-cli ping`. Перед повторным запуском проверьте контекст Docker. Команда `docker compose down` завершит проект, оставив именованные тома.
