#!/bin/bash

# Configurações padrão
KEYSTORE="pentest.jks"
ALIAS="pentest"
KEYPASS="desec123"
KEYVALIDITY=10000
KEYNAME="Pentest Mobile"
KEYTOOL_CMD=$(command -v keytool)
APKSIGNER_CMD=$(command -v apksigner)

# Função de uso
show_help() {
    echo ""
    echo "Uso: $0 -f arquivo.apk [-o saida.apk]"
    echo ""
    echo "Parâmetros obrigatórios:"
    echo "  -f    Caminho para o APK que será assinado"
    echo ""
    echo "Parâmetros opcionais:"
    echo "  -o    Nome do APK de saída assinado (padrão: nome_original_signed.apk)"
    echo ""
    exit 1
}

# Verifica se ferramentas estão disponíveis
if [[ -z "$KEYTOOL_CMD" || -z "$APKSIGNER_CMD" ]]; then
    echo "Erro: keytool e apksigner precisam estar configurados no PATH."
    exit 1
fi

# Lê argumentos
while [[ $# -gt 0 ]]; do
    case "$1" in
        -f)
            INPUT_APK="$2"
            shift 2
            ;;
        -o)
            OUTPUT_APK="$2"
            shift 2
            ;;
        *)
            show_help
            ;;
    esac
done

# Verifica se o APK de entrada foi informado
if [[ -z "$INPUT_APK" ]]; then
    show_help
fi

# Define nome do APK assinado se não informado
if [[ -z "$OUTPUT_APK" ]]; then
    BASE_NAME=$(basename "$INPUT_APK" .apk)
    OUTPUT_APK="${BASE_NAME}_signed.apk"
fi

# Gera keystore se não existir
if [[ ! -f "$KEYSTORE" ]]; then
    echo "[*] Gerando keystore padrão: $KEYSTORE"
    "$KEYTOOL_CMD" -genkey -v \
        -keystore "$KEYSTORE" \
        -alias "$ALIAS" \
        -keyalg RSA \
        -keysize 2048 \
        -validity "$KEYVALIDITY" \
        -storepass "$KEYPASS" \
        -keypass "$KEYPASS" \
        -dname "CN=$KEYNAME, OU=Security, O=Desec, L=São Paulo, ST=SP, C=BR"
else
    echo "[*] Keystore já existe: $KEYSTORE"
fi

# Assina o APK
echo "[*] Assinando APK: $INPUT_APK -> $OUTPUT_APK"
"$APKSIGNER_CMD" sign \
    --ks "$KEYSTORE" \
    --ks-key-alias "$ALIAS" \
    --ks-pass pass:"$KEYPASS" \
    --key-pass pass:"$KEYPASS" \
    --out "$OUTPUT_APK" \
    "$INPUT_APK"

# Verificação
if [[ $? -eq 0 ]]; then
    echo "[✓] APK assinado com sucesso: $OUTPUT_APK"
else
    echo "[x] Erro ao assinar o APK."
    exit 1
fi
