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

valores_odbc=()
valores_tns=()

# Função para validar se o arquivo de template existe
verificar_template() {
    local arquivo_template=$1
    if [ ! -f "$arquivo_template" ]; then
        echo "Error: Template file '$arquivo_template' not found!"
        exit 1
    fi
}

carregar_secrets_odbc(){
    local arquivo_secrets=$1
    local i=0
    # Iterando sobre o arquivo de secrets
    while IFS= read -r linha; do
        # Verificando se a linha não está vazia
        if [[ -n "$linha" ]]; then
            if [ $i -lt 17 ]; then  # Corrigido para comparação correta
                valores_odbc+=("$linha")  # Atribuindo o valor da linha ao array valores_odbc
            else
                valores_tns+=("$linha")  # Atribuindo o valor da linha ao array valores_tns
            fi
            let i++
        fi
    done < "$arquivo_secrets"
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
        valores=("${valores_odbc[@]}")
        echo "ODBC_INI file generated"       
    elif [ $selecionado -eq 2 ]; then
        variaveis=("${VARIAVEIS_TNSNAMES_ORA[@]}")
        valores=("${valores_tns[@]}")
        echo "TNSNAMES file generated"
    else
        cp "$arquivo_template" "$arquivo_config"
        echo "File '$arquivo_template' copied to '$arquivo_config'"
    fi

    # Faz uma cópia do arquivo template
    if [ $selecionado -ne 3 ]; then
        cp "$arquivo_template" "$arquivo_config"
        # Agora, substituindo as variáveis no arquivo de configuração
        for i in "${!variaveis[@]}"; do
            local variavel="${variaveis[$i]}"      # Nome da variável
            local valor_variavel="${valores[$i]}"  # Valor correspondente da variável
            # Substituindo no arquivo de configuração
            sed -i "s/${variavel}/${valor_variavel}/g" "$arquivo_config"
        done
    fi
}


# Função principal que orquestra todo o processo
main() {

    # Definições dos arquivos templates e dos arquivos destino
    local template_odbc="/monitoramento_oracle/templates/odbc.ini"
    local config_odbc="/etc/odbc.ini"
    
    local template_tnsnames="/monitoramento_oracle/templates/tnsnames.ora"
    local config_tnsname="/etc/tnsnames.ora"

    local template_odbcinst="/monitoramento_oracle/templates/odbcinst.ini"
    local config_odbcinst="/etc/odbcinst.ini"

    # Validação dos templates
    verificar_template "$template_odbc"
    verificar_template "$template_tnsnames"
    verificar_template "$template_odbcinst"

    # Validação das variáveis presentes nos arquivos de configuração
    #verificar_variavel_ambiente "${VARIAVEIS_ODBC_INI[@]}"
    #verificar_variavel_ambiente "${VARIAVEIS_TNSNAMES_ORA[@]}"
    
    local arquivo_secrets="/run/secrets/my_secrets" 
    carregar_secrets_odbc "$arquivo_secrets"

    # Etapas do processo
          
    gerar_arquivo_conf "$template_odbc" "$config_odbc" 1
    gerar_arquivo_conf "$template_tnsnames" "$config_tnsname" 2
    gerar_arquivo_conf "$template_odbcinst" "$config_odbcinst" 3

}

# Chama a função principal
main
