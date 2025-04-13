# Monitoramento-Zabbix
Projeto com a finalidade de monitorar bancos Oracle e PostgreSQL via Zabbix

# Modificações realizadas - README Incompleto
## Zabbix-server


## Oracle
Download das seguintes bibliotecas para conexão via ODBC
>>
libaio1t64 \
libaio-dev \
unixodbc-common \
libodbcinst2 \
unixodbc-bin \
unixodbc-dev
>

## Postgres
Subir apenas o postgres

```
docker compose up postgres
docker exec -it  [id ou nome do container] psql -U zabbix -d postgres
```
## Realizar o build das images
```
docker build --no-cache -t ubuntu-zabbix-server ./Dockerfiles/zabbix-server/
```
Ou via docker compose:
```
docker compose up --build
docker compose --profile prod up --build
```
## Remoção de volume
```
docker volume rm postgres_17_data # Remove um volume
docker volume prune # Remove volumes não utilizados
docker container prune # Remove containers parados
docker image prune # Remove imagens não utilizadas (dangling images)
docker volume ls # Listar volumes
```

## Criar backup de um volume (com todas as tabelas)
```
docker exec -it [id ou nome container do postgres] pg_dump -U zabbix --create > ./zabbix_backup.sql
```
## Restaurar backup em um outro volume
```
cat zabbix_backup.sql | docker exec -i zabbix-postgres psql -U zabbix -d zabbix
```