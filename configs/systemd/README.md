# systemd

`handbook-web.service` обслуживает статические файлы, `handbook-worker.service` проверяет готовность HTTP и запускается таймером каждую минуту. Создайте `/srv/handbook/www/index.html`, доступный на чтение, и убедитесь, что Python и curl находятся по указанным путям. Динамические UID не требуют предварительной подготовки учётных записей.

В учебной ВМ разместите файлы в `/etc/systemd/system`. Проверьте их через `systemd-analyze verify`, выполните `sudo systemctl daemon-reload`, запустите `sudo systemctl start handbook-web.service handbook-worker.timer` и проверьте `systemctl list-timers` и `journalctl -u handbook-worker.service`. Для отката остановите таймер, worker и web, удалите только скопированные файлы и повторите daemon-reload.
