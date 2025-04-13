#!/bin/bash
VARIAVEIS_ODBC_INI=("ORACLE_DRIVER" 
                    "BD_ORACLE_SERVER_NAME" 
                    "BD_ORACLE_USER" 
                    "BD_ORACLE_PASSWORD" 
                    "BD_ORACLE_HOST" 
                    "PG_BD_USER" 
                    "PG_BD_PASSWD"
                    "PG_BD_SERVERNAME"
                    "PG_BD_DB"
                )
VARIAVEIS_TNSNAMES_ORA=("BD_ORACLE_SERVER_NAME"
                        "BD_ORACLE_HOST"
                        )

# Função para validar se o arquivo de template existe
verificar_template() {
    local arquivo_template=$1
    if [ ! -f "$arquivo_template" ]; then
        echo "Error: Template file '$arquivo_template' not found!"
        exit 1
    fi
}

# Função para validar se uma variável de ambiente existe
verificar_variavel_ambiente() {
    local variaveis=("$@")
    for variavel in "${variaveis[@]}"; do
        if [ -z "${!variavel}" ]; then
            echo "Error: Env var '$variavel' not set!"
            exit 1
        fi
    done
}

# Função para substituir as variáveis no arquivo template
gerar_arquivo_conf() {
    local arquivo_template=$1
    local arquivo_config=$2
    local selecionado=$3

    # Cria o dir de destino se não existir
    mkdir -p "$(dirname "$arquivo_config")"
    
    if [ $selecionado -eq 1 ]; then
        variaveis=("${VARIAVEIS_ODBC_INI[@]}") 
        echo "ODBC_INI file generated!"       
    elif [ $selecionado -eq 2 ]; then
        variaveis=("${VARIAVEIS_TNSNAMES_ORA[@]}")
        echo "TNS_NAMES file generated!"
    else
        cp "$arquivo_template" "$arquivo_config"
        echo "File '$arquivo_template' copied to '$arquivo_config'"
        . ./script_env.sh
        echo ".env file generated!"
    fi

    # Faz uma cópia do arquivo template
    if [ $selecionado -ne 3 ]; then
        cp "$arquivo_template" "$arquivo_config"
        for i in "${!variaveis[@]}"; do
            local variavel=$(eval "echo \${variaveis[$i]}")
            local valor_variavel=$(eval "echo \$${variavel}")
            #echo "Variavel: ${variavel} ,Valor: ${valor_variavel}"
            sed -i "s/${variavel}/${valor_variavel}/g" "$arquivo_config"
        done
    fi
}


# Função principal que orquestra todo o processo
main() {

    # Definições dos arquivos templates e dos arquivos destino
    local template_odbc="./Dockerfiles/zabbix-server/monitoramento_oracle/templates/odbc.ini"
    local config_odbc="./Dockerfiles/zabbix-server/monitoramento_oracle/configs/odbc.ini"
    
    local template_tnsnames="./Dockerfiles/zabbix-server/monitoramento_oracle/templates/tnsnames.ora"
    local config_tnsname="./Dockerfiles/zabbix-server/monitoramento_oracle/configs/tnsnames.ora"

    local template_odbcinst="./Dockerfiles/zabbix-server/monitoramento_oracle/templates/odbcinst.ini"
    local config_odbcinst="./Dockerfiles/zabbix-server/monitoramento_oracle/configs/odbcinst.ini"

    # Validação dos templates
    verificar_template "$template_odbc"
    verificar_template "$template_tnsnames"
    verificar_template "$template_odbcinst"

    # Validação das variáveis presentes nos arquivos de configuração
    verificar_variavel_ambiente "${VARIAVEIS_ODBC_INI[@]}"
    verificar_variavel_ambiente "${VARIAVEIS_TNSNAMES_ORA[@]}"
    

    # Etapas do processo
          
    gerar_arquivo_conf "$template_odbc" "$config_odbc" 1
    gerar_arquivo_conf "$template_tnsnames" "$config_tnsname" 2
    gerar_arquivo_conf "$template_odbcinst" "$config_odbcinst" 3

}

# Chama a função principal
main

