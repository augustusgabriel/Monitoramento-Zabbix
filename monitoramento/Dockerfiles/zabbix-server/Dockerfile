FROM zabbix/zabbix-server-pgsql:ubuntu-7.2.5
USER root
RUN apt-get -y update

#Configuracoes relativas ao monitoramento de BD oracle e Postgres
RUN apt-get install -y unzip libaio1t64 \
unixodbc-dev odbc-postgresql
COPY ["./monitoramento_oracle/instantclient-basic-linux.x64-19.25.0.0.0dbru.zip", "./monitoramento_oracle/instantclient-odbc-linux.x64-19.25.0.0.0dbru.zip", "./cacti-mibs.tar.gz", "/tmp/"]
RUN mkdir -p /opt/oracle/instantclient-basic \
    /opt/oracle/instantclient-odbc \
    /etc/oracle \
    /usr/share/snmp/mibs/ 

RUN unzip /tmp/instantclient-basic-linux.x64-19.25.0.0.0dbru.zip -d /opt/oracle/instantclient-basic/ \
    && unzip /tmp/instantclient-odbc-linux.x64-19.25.0.0.0dbru.zip -d /opt/oracle/instantclient-odbc/ \
    && tar -xvzf  /tmp/cacti-mibs.tar.gz -C / && rm /tmp/*

RUN ln -s /opt/oracle/instantclient-basic/instantclient_19_25/libclntsh.so.19.1  /lib/x86_64-linux-gnu/libclntsh.so.19.1 \
    && ln -s /opt/oracle/instantclient-basic/instantclient_19_25/libclntshcore.so.19.1  /lib/x86_64-linux-gnu/libclntshcore.so.19.1 \
    && ln -s /opt/oracle/instantclient-basic/instantclient_19_25/libnnz19.so  /lib/x86_64-linux-gnu/libnnz19.so \
    && ln -s /lib/x86_64-linux-gnu/libaio.so.1t64 /lib/x86_64-linux-gnu/libaio.so.1

#Criação do odbcinst.ini, odbc.ini e tnsnames.ora
COPY ["./monitoramento_oracle/templates/", "/monitoramento_oracle/templates/"]
COPY --chmod=511 ["./script_secrets.sh", "/monitoramento_oracle/.script_secrets.sh"]
RUN chmod +x /monitoramento_oracle/.script_secrets.sh
#COPY ["./monitoramento_oracle/configs/", "/etc/"]
COPY --chmod=766 ["./monitoramento_pgsql/psqlodbcw.so", "/usr/lib/"]
USER zabbix