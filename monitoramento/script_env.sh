#!/bin/bash

# Caminho para o arquivo .env
ENV_FILE="./.env"

# Verifica se o arquivo .env já existe
if [ -f "$ENV_FILE" ]; then
    echo "Arquivo .env já existe. Removendo..."
    rm "$ENV_FILE"
    touch "$ENV_FILE"
else
    echo "Criando o arquivo .env..."
    touch "$ENV_FILE"
fi

# Definindo variáveis de ambiente dentro do arquivo .env
cat << EOF >> "$ENV_FILE"
# Postgres"
DB_SERVER_HOST=$DB_SERVER_HOST
POSTGRES_USER=$POSTGRES_USER
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
POSTGRES_DB=$POSTGRES_DB

# Zabbix
ZBX_STARTPINGERS=10
ZBX_STARTDISCOVERERS=10
ZBX_STARTESCALATORS=5
#ZBX_JAVAGATEWAY_ENABLE=true
#ZBX_STARTJAVAPOLLERS=5
ZBX_ENABLE_SNMP_TRAPS=true
ZBX_CACHESIZE=528M
ZBX_VALUECACHESIZE=528M
ZBX_STARTREPORTWRITERS=1
ZBX_NODEADDRESS=$ZBX_NODEADDRESS
ZBX_ENABLEGLOBALSCRIPTS=1
# Valor padrão ZBX_DEBUGLEVEL=3
ZBX_DEBUGLEVEL=3

# Paths Oracle" >> "$ENV_FILE"
ORACLE_HOME=$ORACLE_HOME
LD_LIBRARY_PATH=$LD_LIBRARY_PATH
TNS_ADMIN=$TNS_ADMIN

PGADMIN_DEFAULT_EMAIL=${PGADMIN_DEFAULT_EMAIL}
PGADMIN_DEFAULT_PASSWORD=${PGADMIN_DEFAULT_PASSWORD}
EOF
