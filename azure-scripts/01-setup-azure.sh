#!/bin/bash
# ============================================================================
# Script de Provisionamento Azure - MottuVision
# Descrição: Cria todos os recursos necessários na Azure usando Azure CLI
# Opção: ACR (Azure Container Registry) + ACI (Azure Container Instance)
# ============================================================================

set -e  # Parar execução em caso de erro

# ============================================================================
# VARIÁVEIS DE CONFIGURAÇÃO
# ============================================================================

# Configurações gerais
RESOURCE_GROUP="rg-mottuvision-prod"
LOCATION="brazilsouth"  # Região Brasil Sul
PROJECT_NAME="mottuvision"

# Azure Container Registry
ACR_NAME="acrmottuvision"  # Deve ser único globalmente
ACR_SKU="Basic"

# Azure Database for PostgreSQL
DB_SERVER_NAME="psql-mottuvision-server"  # Deve ser único globalmente
DB_NAME="mottuvision"
DB_ADMIN_USER="mottuvisionadmin"
DB_ADMIN_PASSWORD="Mottu@2024#Secure"  # ALTERAR EM PRODUÇÃO!
DB_SKU="B_Gen5_1"  # Basic, 1 vCore
DB_STORAGE_SIZE="32768"  # 32 GB

# Azure Container Instance
ACI_NAME="aci-mottuvision-app"
ACI_CPU="1"
ACI_MEMORY="1.5"
ACI_PORT="8080"

# Tags para organização
TAGS="Environment=Production Project=MottuVision ManagedBy=AzureCLI"

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
# VERIFICAÇÃO DE PRÉ-REQUISITOS
# ============================================================================

print_header "VERIFICANDO PRÉ-REQUISITOS"

# Verificar se Azure CLI está instalado
if ! command -v az &> /dev/null; then
    print_error "Azure CLI não está instalado. Instale em: https://docs.microsoft.com/cli/azure/install-azure-cli"
    exit 1
fi
print_success "Azure CLI instalado"

# Verificar se está logado
if ! az account show &> /dev/null; then
    print_error "Você não está logado no Azure CLI. Execute: az login"
    exit 1
fi
print_success "Autenticado no Azure"

# Mostrar assinatura atual
SUBSCRIPTION_NAME=$(az account show --query name -o tsv)
print_info "Assinatura atual: $SUBSCRIPTION_NAME"

# ============================================================================
# CRIAÇÃO DO RESOURCE GROUP
# ============================================================================

print_header "CRIANDO RESOURCE GROUP"

if az group exists --name $RESOURCE_GROUP | grep -q "true"; then
    print_info "Resource Group '$RESOURCE_GROUP' já existe"
else
    az group create \
        --name $RESOURCE_GROUP \
        --location $LOCATION \
        --tags $TAGS
    print_success "Resource Group '$RESOURCE_GROUP' criado"
fi

# ============================================================================
# CRIAÇÃO DO AZURE CONTAINER REGISTRY (ACR)
# ============================================================================

print_header "CRIANDO AZURE CONTAINER REGISTRY"

if az acr show --name $ACR_NAME --resource-group $RESOURCE_GROUP &> /dev/null; then
    print_info "Azure Container Registry '$ACR_NAME' já existe"
else
    az acr create \
        --resource-group $RESOURCE_GROUP \
        --name $ACR_NAME \
        --sku $ACR_SKU \
        --location $LOCATION \
        --admin-enabled true \
        --tags $TAGS
    print_success "Azure Container Registry '$ACR_NAME' criado"
fi

# Obter credenciais do ACR
ACR_LOGIN_SERVER=$(az acr show --name $ACR_NAME --resource-group $RESOURCE_GROUP --query loginServer -o tsv)
ACR_USERNAME=$(az acr credential show --name $ACR_NAME --resource-group $RESOURCE_GROUP --query username -o tsv)
ACR_PASSWORD=$(az acr credential show --name $ACR_NAME --resource-group $RESOURCE_GROUP --query passwords[0].value -o tsv)

print_info "ACR Login Server: $ACR_LOGIN_SERVER"
print_info "ACR Username: $ACR_USERNAME"

# ============================================================================
# CRIAÇÃO DO AZURE DATABASE FOR POSTGRESQL
# ============================================================================

print_header "CRIANDO AZURE DATABASE FOR POSTGRESQL"

if az postgres server show --name $DB_SERVER_NAME --resource-group $RESOURCE_GROUP &> /dev/null; then
    print_info "PostgreSQL Server '$DB_SERVER_NAME' já existe"
else
    az postgres server create \
        --resource-group $RESOURCE_GROUP \
        --name $DB_SERVER_NAME \
        --location $LOCATION \
        --admin-user $DB_ADMIN_USER \
        --admin-password $DB_ADMIN_PASSWORD \
        --sku-name $DB_SKU \
        --storage-size $DB_STORAGE_SIZE \
        --version 16 \
        --ssl-enforcement Disabled \
        --tags $TAGS
    print_success "PostgreSQL Server '$DB_SERVER_NAME' criado"
fi

# Configurar firewall para permitir acesso do Azure
print_info "Configurando regra de firewall..."
az postgres server firewall-rule create \
    --resource-group $RESOURCE_GROUP \
    --server-name $DB_SERVER_NAME \
    --name AllowAzureServices \
    --start-ip-address 0.0.0.0 \
    --end-ip-address 0.0.0.0

# Criar banco de dados
print_info "Criando banco de dados '$DB_NAME'..."
az postgres db create \
    --resource-group $RESOURCE_GROUP \
    --server-name $DB_SERVER_NAME \
    --name $DB_NAME

# Obter connection string
DB_HOST="${DB_SERVER_NAME}.postgres.database.azure.com"
DB_CONNECTION_STRING="jdbc:postgresql://${DB_HOST}:5432/${DB_NAME}?sslmode=require"

print_success "PostgreSQL Database criado"
print_info "Connection String: $DB_CONNECTION_STRING"

# ============================================================================
# RESUMO DAS CREDENCIAIS
# ============================================================================

print_header "RESUMO DAS CREDENCIAIS CRIADAS"

echo "Azure Container Registry:"
echo "  - Login Server: $ACR_LOGIN_SERVER"
echo "  - Username: $ACR_USERNAME"
echo "  - Password: $ACR_PASSWORD"
echo ""
echo "PostgreSQL Database:"
echo "  - Host: $DB_HOST"
echo "  - Database: $DB_NAME"
echo "  - Username: ${DB_ADMIN_USER}@${DB_SERVER_NAME}"
echo "  - Password: $DB_ADMIN_PASSWORD"
echo "  - Connection String: $DB_CONNECTION_STRING"
echo ""

# Salvar credenciais em arquivo
CREDENTIALS_FILE="azure-credentials.txt"
cat > $CREDENTIALS_FILE << EOF
# ============================================================================
# Credenciais Azure - MottuVision
# ATENÇÃO: Mantenha este arquivo seguro e não compartilhe publicamente!
# ============================================================================

# Azure Container Registry
ACR_LOGIN_SERVER=$ACR_LOGIN_SERVER
ACR_USERNAME=$ACR_USERNAME
ACR_PASSWORD=$ACR_PASSWORD

# PostgreSQL Database
DB_HOST=$DB_HOST
DB_NAME=$DB_NAME
DB_USERNAME=${DB_ADMIN_USER}@${DB_SERVER_NAME}
DB_PASSWORD=$DB_ADMIN_PASSWORD
DB_CONNECTION_STRING=$DB_CONNECTION_STRING

# Resource Group
RESOURCE_GROUP=$RESOURCE_GROUP
LOCATION=$LOCATION
EOF

print_success "Credenciais salvas em: $CREDENTIALS_FILE"

# ============================================================================
# PRÓXIMOS PASSOS
# ============================================================================

print_header "PRÓXIMOS PASSOS"

echo "1. Execute o script 02-build-and-push.sh para fazer build e push da imagem Docker"
echo "2. Execute o script 03-deploy-aci.sh para fazer deploy no Azure Container Instance"
echo "3. Acesse a aplicação através do IP público do ACI"
echo ""

print_success "Provisionamento concluído com sucesso!"
