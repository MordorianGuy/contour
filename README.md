# Тестовое задание для СКБ Контур

Код решения расположен в файле `solution.sql`.  
Для быстрого развёртывания MSSQL контейнера в Linux/WSL и инициализации базы запустите скрипт `install.sh`.  
Подключиться и проверить решение можно из IDE по стандартному порту или в терминале следующей командой:  
```bash
docker exec -i mssql_server /opt/mssql-tools18/bin/sqlcmd -S localhost -C -U sa -P Password#01 -Y 20 -e < solution.sql
```
