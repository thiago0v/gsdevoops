#!/bin/bash
# ============================================================================
# Script de Deploy Completo - MottuVision
# Descrição: Executa todo o processo de deploy automaticamente
# ============================================================================

set -e  # Parar em caso de erro

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_header() {
    echo -e "\n${BLUE}============================================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}============================================================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# ============================================================================
# VERIFICAR PRÉ-REQUISITOS
# ============================================================================

print_header "VERIFICANDO PRÉ-REQUISITOS"

# Verificar Azure CLI
if ! command -v az &> /dev/null; then
    print_error "Azure CLI não está instalado!"
    echo "Instale em: https://docs.microsoft.com/cli/azure/install-azure-cli"
    exit 1
fi
print_success "Azure CLI instalado"

# Verificar Docker
if ! command -v docker &> /dev/null; then
    print_error "Docker não está instalado!"
    echo "Instale em: https://www.docker.com/get-started"
    exit 1
fi
print_success "Docker instalado"

# Verificar login no Azure
if ! az account show &> /dev/null; then
    print_warning "Você não está logado no Azure"
    print_info "Fazendo login..."
    
    echo ""
    echo "Escolha o método de login:"
    echo "1) Login com usuário e senha"
    echo "2) Login interativo (navegador)"
    read -p "Opção [1-2]: " login_option
    
    if [ "$login_option" = "1" ]; then
        read -p "Email: " azure_email
        read -sp "Senha: " azure_password
        echo ""
        az login -u "$azure_email" -p "$azure_password"
    else
        az login
    fi
fi

SUBSCRIPTION_NAME=$(az account show --query name -o tsv)
print_success "Logado no Azure - Assinatura: $SUBSCRIPTION_NAME"

# ============================================================================
# ETAPA 1: PROVISIONAR INFRAESTRUTURA
# ============================================================================

print_header "ETAPA 1/3: PROVISIONANDO INFRAESTRUTURA AZURE"
print_info "Criando Resource Group, ACR e PostgreSQL..."
echo ""

./01-setup-azure.sh

if [ $? -eq 0 ]; then
    print_success "Infraestrutura provisionada com sucesso!"
else
    print_error "Erro ao provisionar infraestrutura"
    exit 1
fi

# Aguardar um pouco para garantir que os recursos estão prontos
sleep 5

# ============================================================================
# ETAPA 2: BUILD E PUSH DA IMAGEM
# ============================================================================

print_header "ETAPA 2/3: FAZENDO BUILD E PUSH DA IMAGEM DOCKER"
print_info "Compilando aplicação e enviando para ACR..."
echo ""

./02-build-and-push.sh

if [ $? -eq 0 ]; then
    print_success "Imagem Docker criada e enviada com sucesso!"
else
    print_error "Erro ao fazer build/push da imagem"
    exit 1
fi

# Aguardar um pouco
sleep 3

# ============================================================================
# ETAPA 3: DEPLOY NO ACI
# ============================================================================

print_header "ETAPA 3/3: FAZENDO DEPLOY NO AZURE CONTAINER INSTANCE"
print_info "Criando container e iniciando aplicação..."
echo ""

./03-deploy-aci.sh

if [ $? -eq 0 ]; then
    print_success "Deploy concluído com sucesso!"
else
    print_error "Erro ao fazer deploy no ACI"
    exit 1
fi

# ============================================================================
# RESUMO FINAL
# ============================================================================

print_header "🎉 DEPLOY COMPLETO - SUCESSO!"

# Obter informações do ACI
ACI_IP=$(az container show --name aci-mottuvision-app --resource-group rg-mottuvision-prod --query ipAddress.ip -o tsv 2>/dev/null)
ACI_FQDN=$(az container show --name aci-mottuvision-app --resource-group rg-mottuvision-prod --query ipAddress.fqdn -o tsv 2>/dev/null)

echo ""
echo "Sua aplicação está rodando! 🚀"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📱 ACESSO À APLICAÇÃO WEB:"
echo "   http://$ACI_IP:8080"
echo "   http://$ACI_FQDN:8080"
echo ""
echo "🔐 CREDENCIAIS DE LOGIN:"
echo "   Email: admin@mottu.com"
echo "   Senha: 123456"
echo ""
echo "🔧 API REST (CRUD):"
echo "   GET    http://$ACI_IP:8080/api/motos"
echo "   POST   http://$ACI_IP:8080/api/motos"
echo "   PUT    http://$ACI_IP:8080/api/motos/{id}"
echo "   DELETE http://$ACI_IP:8080/api/motos/{id}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Salvar informações em arquivo
cat > deployment-info.txt << EOF
=============================================================================
INFORMAÇÕES DO DEPLOY - MottuVision
Data: $(date)
=============================================================================

ACESSO À APLICAÇÃO:
- IP: http://$ACI_IP:8080
- FQDN: http://$ACI_FQDN:8080

CREDENCIAIS:
- Email: admin@mottu.com
- Senha: 123456

API REST:
- Base URL: http://$ACI_IP:8080/api

RECURSOS AZURE:
- Resource Group: rg-mottuvision-prod
- Container Registry: acrmottuvision
- Container Instance: aci-mottuvision-app
- PostgreSQL: psql-mottuvision-server

PRÓXIMOS PASSOS:
1. Acessar a aplicação web no navegador
2. Testar o CRUD com: cd ../tests && BASE_URL=http://$ACI_IP:8080 ./crud-tests-updated.sh
3. Gravar vídeo demonstrativo
4. Fazer upload no YouTube
5. Criar repositório no GitHub
6. Atualizar PDF com os links

COMANDOS ÚTEIS:
- Ver logs: az container logs --name aci-mottuvision-app --resource-group rg-mottuvision-prod
- Reiniciar: az container restart --name aci-mottuvision-app --resource-group rg-mottuvision-prod
- Deletar tudo: az group delete --name rg-mottuvision-prod --yes

=============================================================================
EOF

print_success "Informações salvas em: deployment-info.txt"
echo ""

print_info "Próximos passos:"
echo "1. Abra o navegador e acesse: http://$ACI_IP:8080"
echo "2. Faça login com: admin@mottu.com / 123456"
echo "3. Teste o CRUD executando: cd ../tests && BASE_URL=http://$ACI_IP:8080 ./crud-tests-updated.sh"
echo ""

read -p "Deseja testar a aplicação agora? [s/N] " test_now

if [[ $test_now =~ ^[Ss]$ ]]; then
    print_info "Aguardando aplicação inicializar completamente (30 segundos)..."
    sleep 30
    
    print_info "Testando conectividade..."
    if curl -s -o /dev/null -w "%{http_code}" "http://$ACI_IP:8080/actuator/health" | grep -q "200"; then
        print_success "Aplicação está respondendo!"
        
        print_info "Executando testes CRUD..."
        cd ../tests
        export BASE_URL="http://$ACI_IP:8080"
        ./crud-tests-updated.sh
    else
        print_warning "Aplicação ainda está inicializando. Aguarde mais alguns minutos e teste manualmente."
    fi
fi

echo ""
print_success "Deploy completo! Boa sorte na apresentação! 🎉"
echo ""
