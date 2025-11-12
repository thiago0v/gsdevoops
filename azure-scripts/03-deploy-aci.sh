#!/bin/bash
# ============================================================================
# Script de Deploy ACI - MottuVision
# Descrição: Faz deploy da aplicação no Azure Container Instance
# ============================================================================

set -e  # Parar execução em caso de erro

# ============================================================================
# VARIÁVEIS DE CONFIGURAÇÃO
# ============================================================================

RESOURCE_GROUP="rg-mottuvision-prod"
LOCATION="brazilsouth"
ACR_NAME="acrmottuvision"
IMAGE_NAME="mottuvision-app"
IMAGE_TAG="latest"

# Azure Container Instance
ACI_NAME="aci-mottuvision-app"
ACI_CPU="1"
ACI_MEMORY="1.5"
ACI_PORT="8080"

# Database (ajustar conforme criado no script 01)
DB_SERVER_NAME="psql-mottuvision-server"
DB_NAME="mottuvision"
DB_ADMIN_USER="mottuvisionadmin"
DB_ADMIN_PASSWORD="Mottu@2024#Secure"  # DEVE SER O MESMO DO SCRIPT 01

# ============================================================================
# FUNÇÕES AUXILIARES
# ============================================================================

print_header() {
    echo ""
    echo "============================================================================"
    echo "$1"
    echo "============================================================================"
}

print_success() {
    echo "✅ $1"
}

print_info() {
    echo "ℹ️  $1"
}

print_error() {
    echo "❌ $1"
}

# ============================================================================
# OBTER INFORMAÇÕES DO ACR E DATABASE
# ============================================================================

print_header "OBTENDO INFORMAÇÕES DOS RECURSOS"

# ACR
ACR_LOGIN_SERVER=$(az acr show --name $ACR_NAME --query loginServer -o tsv)
ACR_USERNAME=$(az acr credential show --name $ACR_NAME --query username -o tsv)
ACR_PASSWORD=$(az acr credential show --name $ACR_NAME --query passwords[0].value -o tsv)

print_info "ACR Login Server: $ACR_LOGIN_SERVER"

# Database
DB_HOST="${DB_SERVER_NAME}.postgres.database.azure.com"
DB_CONNECTION_STRING="jdbc:postgresql://${DB_HOST}:5432/${DB_NAME}?sslmode=require"

print_info "Database Host: $DB_HOST"

# Imagem completa
FULL_IMAGE_NAME="${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG}"
print_info "Imagem: $FULL_IMAGE_NAME"

# ============================================================================
# DELETAR ACI EXISTENTE (SE HOUVER)
# ============================================================================

print_header "VERIFICANDO ACI EXISTENTE"

if az container show --name $ACI_NAME --resource-group $RESOURCE_GROUP &> /dev/null; then
    print_info "ACI existente encontrado. Deletando..."
    az container delete \
        --name $ACI_NAME \
        --resource-group $RESOURCE_GROUP \
        --yes
    print_success "ACI existente deletado"
    sleep 10  # Aguardar para garantir que o recurso foi completamente removido
else
    print_info "Nenhum ACI existente encontrado"
fi

# ============================================================================
# CRIAR AZURE CONTAINER INSTANCE
# ============================================================================

print_header "CRIANDO AZURE CONTAINER INSTANCE"

print_info "Criando container com as seguintes especificações:"
echo "  - Nome: $ACI_NAME"
echo "  - CPU: $ACI_CPU cores"
echo "  - Memória: $ACI_MEMORY GB"
echo "  - Porta: $ACI_PORT"
echo ""

az container create \
    --resource-group $RESOURCE_GROUP \
    --name $ACI_NAME \
    --image $FULL_IMAGE_NAME \
    --cpu $ACI_CPU \
    --memory $ACI_MEMORY \
    --registry-login-server $ACR_LOGIN_SERVER \
    --registry-username $ACR_USERNAME \
    --registry-password $ACR_PASSWORD \
    --dns-name-label $ACI_NAME \
    --ports $ACI_PORT \
    --environment-variables \
        SPRING_PROFILES_ACTIVE=prod \
        SPRING_DATASOURCE_URL=$DB_CONNECTION_STRING \
        SPRING_DATASOURCE_USERNAME="${DB_ADMIN_USER}@${DB_SERVER_NAME}" \
        SPRING_DATASOURCE_PASSWORD=$DB_ADMIN_PASSWORD \
        SPRING_JPA_HIBERNATE_DDL_AUTO=update \
        SERVER_PORT=$ACI_PORT \
    --location $LOCATION

print_success "Azure Container Instance criado com sucesso"

# ============================================================================
# OBTER INFORMAÇÕES DO ACI
# ============================================================================

print_header "OBTENDO INFORMAÇÕES DO ACI"

# Aguardar o container iniciar
print_info "Aguardando o container iniciar..."
sleep 15

# Obter IP público e FQDN
ACI_IP=$(az container show --name $ACI_NAME --resource-group $RESOURCE_GROUP --query ipAddress.ip -o tsv)
ACI_FQDN=$(az container show --name $ACI_NAME --resource-group $RESOURCE_GROUP --query ipAddress.fqdn -o tsv)
ACI_STATE=$(az container show --name $ACI_NAME --resource-group $RESOURCE_GROUP --query instanceView.state -o tsv)

print_success "Container em execução"

# ============================================================================
# RESUMO DO DEPLOY
# ============================================================================

print_header "RESUMO DO DEPLOY"

echo "Azure Container Instance criado com sucesso!"
echo ""
echo "Informações de Acesso:"
echo "  - Nome: $ACI_NAME"
echo "  - Estado: $ACI_STATE"
echo "  - IP Público: $ACI_IP"
echo "  - FQDN: $ACI_FQDN"
echo "  - Porta: $ACI_PORT"
echo ""
echo "URLs de Acesso:"
echo "  - Por IP: http://$ACI_IP:$ACI_PORT"
echo "  - Por FQDN: http://$ACI_FQDN:$ACI_PORT"
echo ""
echo "Credenciais de Login:"
echo "  - Admin: admin@mottu.com / 123456"
echo "  - Operador SP: operador.sp@mottu.com / 123456"
echo ""

# ============================================================================
# VERIFICAR LOGS DO CONTAINER
# ============================================================================

print_header "LOGS DO CONTAINER (últimas 50 linhas)"

az container logs \
    --name $ACI_NAME \
    --resource-group $RESOURCE_GROUP \
    --tail 50

# ============================================================================
# COMANDOS ÚTEIS
# ============================================================================

print_header "COMANDOS ÚTEIS"

echo "Ver logs em tempo real:"
echo "  az container attach --name $ACI_NAME --resource-group $RESOURCE_GROUP"
echo ""
echo "Ver status do container:"
echo "  az container show --name $ACI_NAME --resource-group $RESOURCE_GROUP"
echo ""
echo "Reiniciar container:"
echo "  az container restart --name $ACI_NAME --resource-group $RESOURCE_GROUP"
echo ""
echo "Deletar container:"
echo "  az container delete --name $ACI_NAME --resource-group $RESOURCE_GROUP --yes"
echo ""

print_success "Deploy concluído com sucesso!"
