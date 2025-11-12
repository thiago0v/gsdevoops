#!/bin/bash
# ============================================================================
# Script de Build e Push - MottuVision
# Descrição: Faz build da imagem Docker e push para Azure Container Registry
# ============================================================================

set -e  # Parar execução em caso de erro

# ============================================================================
# VARIÁVEIS DE CONFIGURAÇÃO
# ============================================================================

ACR_NAME="acrmottuvision"
IMAGE_NAME="mottuvision-app"
IMAGE_TAG="latest"
DOCKERFILE_PATH="./docker/Dockerfile"

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

# Verificar se Docker está instalado
if ! command -v docker &> /dev/null; then
    print_error "Docker não está instalado. Instale em: https://docs.docker.com/get-docker/"
    exit 1
fi
print_success "Docker instalado"

# Verificar se Azure CLI está instalado
if ! command -v az &> /dev/null; then
    print_error "Azure CLI não está instalado"
    exit 1
fi
print_success "Azure CLI instalado"

# Verificar se Dockerfile existe
if [ ! -f "$DOCKERFILE_PATH" ]; then
    print_error "Dockerfile não encontrado em: $DOCKERFILE_PATH"
    exit 1
fi
print_success "Dockerfile encontrado"

# ============================================================================
# OBTER CREDENCIAIS DO ACR
# ============================================================================

print_header "OBTENDO CREDENCIAIS DO ACR"

ACR_LOGIN_SERVER=$(az acr show --name $ACR_NAME --query loginServer -o tsv)
print_info "ACR Login Server: $ACR_LOGIN_SERVER"

# ============================================================================
# LOGIN NO AZURE CONTAINER REGISTRY
# ============================================================================

print_header "FAZENDO LOGIN NO ACR"

az acr login --name $ACR_NAME
print_success "Login realizado com sucesso"

# ============================================================================
# BUILD DA IMAGEM DOCKER
# ============================================================================

print_header "FAZENDO BUILD DA IMAGEM DOCKER"

FULL_IMAGE_NAME="${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG}"

print_info "Imagem: $FULL_IMAGE_NAME"
print_info "Iniciando build..."

docker build \
    -t $FULL_IMAGE_NAME \
    -f $DOCKERFILE_PATH \
    .

print_success "Build concluído com sucesso"

# ============================================================================
# PUSH DA IMAGEM PARA O ACR
# ============================================================================

print_header "FAZENDO PUSH DA IMAGEM PARA O ACR"

print_info "Enviando imagem para: $ACR_LOGIN_SERVER"

docker push $FULL_IMAGE_NAME

print_success "Push concluído com sucesso"

# ============================================================================
# VERIFICAR IMAGEM NO ACR
# ============================================================================

print_header "VERIFICANDO IMAGEM NO ACR"

az acr repository show \
    --name $ACR_NAME \
    --repository $IMAGE_NAME

print_success "Imagem verificada no ACR"

# ============================================================================
# RESUMO
# ============================================================================

print_header "RESUMO"

echo "Imagem Docker criada e enviada com sucesso!"
echo ""
echo "Detalhes:"
echo "  - Registry: $ACR_LOGIN_SERVER"
echo "  - Imagem: $IMAGE_NAME"
echo "  - Tag: $IMAGE_TAG"
echo "  - Full Name: $FULL_IMAGE_NAME"
echo ""
echo "Próximo passo:"
echo "  Execute o script 03-deploy-aci.sh para fazer deploy no Azure Container Instance"
echo ""

print_success "Build e Push concluídos com sucesso!"
