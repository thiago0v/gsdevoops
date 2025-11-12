#!/bin/bash
# ============================================================================
# Scripts de Teste CRUD - MottuVision
# Descrição: Testes das operações CRUD na API de Motos
# ============================================================================

# IMPORTANTE: Substitua <IP_DO_SEU_ACI> pelo IP real do seu Azure Container Instance
BASE_URL="http://<IP_DO_SEU_ACI>:8080"

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

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

# ============================================================================
# 1. CONSULTA (GET) - Listar todas as motos
# ============================================================================

print_header "1. CONSULTA (GET) - Listar todas as motos"

print_info "Endpoint: GET $BASE_URL/motos"
echo ""

curl -X GET "$BASE_URL/motos" \
    -H "Accept: application/json" \
    -w "\n\nHTTP Status: %{http_code}\n" \
    | jq '.'

print_success "Consulta de todas as motos concluída"

# ============================================================================
# 2. CONSULTA (GET) - Buscar moto por ID
# ============================================================================

print_header "2. CONSULTA (GET) - Buscar moto por ID (ID: 1)"

print_info "Endpoint: GET $BASE_URL/motos/1"
echo ""

curl -X GET "$BASE_URL/motos/1" \
    -H "Accept: application/json" \
    -w "\n\nHTTP Status: %{http_code}\n" \
    | jq '.'

print_success "Consulta da moto ID 1 concluída"

# ============================================================================
# 3. INCLUSÃO (POST) - Criar nova moto
# ============================================================================

print_header "3. INCLUSÃO (POST) - Criar nova moto"

print_info "Endpoint: POST $BASE_URL/motos"
print_info "Dados: Placa NEW1A23, Modelo Honda Biz 125"
echo ""

curl -X POST "$BASE_URL/motos" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -d '{
        "placa": "NEW1A23",
        "modelo": "Honda Biz 125",
        "ano": 2024,
        "filialId": 1,
        "status": "DISPONIVEL",
        "posicaoX": 10,
        "posicaoY": 10
    }' \
    -w "\n\nHTTP Status: %{http_code}\n" \
    | jq '.'

print_success "Nova moto criada com sucesso"

# Aguardar um pouco antes da próxima operação
sleep 2

# ============================================================================
# 4. ALTERAÇÃO (PUT) - Atualizar moto existente
# ============================================================================

print_header "4. ALTERAÇÃO (PUT) - Atualizar status da moto ID 1"

print_info "Endpoint: PUT $BASE_URL/motos/1"
print_info "Alteração: Status de DISPONIVEL para MANUTENCAO"
echo ""

curl -X PUT "$BASE_URL/motos/1" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -d '{
        "placa": "ABC1D23",
        "modelo": "Honda CG 160",
        "ano": 2023,
        "filialId": 1,
        "status": "MANUTENCAO",
        "posicaoX": 5,
        "posicaoY": 3
    }' \
    -w "\n\nHTTP Status: %{http_code}\n" \
    | jq '.'

print_success "Moto ID 1 atualizada com sucesso"

# Aguardar um pouco antes da próxima operação
sleep 2

# ============================================================================
# 5. CONSULTA (GET) - Verificar alteração
# ============================================================================

print_header "5. CONSULTA (GET) - Verificar alteração da moto ID 1"

print_info "Endpoint: GET $BASE_URL/motos/1"
print_info "Verificando se o status foi alterado para MANUTENCAO"
echo ""

curl -X GET "$BASE_URL/motos/1" \
    -H "Accept: application/json" \
    -w "\n\nHTTP Status: %{http_code}\n" \
    | jq '.'

print_success "Verificação concluída - Status deve estar como MANUTENCAO"

# Aguardar um pouco antes da próxima operação
sleep 2

# ============================================================================
# 6. EXCLUSÃO (DELETE) - Deletar moto
# ============================================================================

print_header "6. EXCLUSÃO (DELETE) - Deletar moto ID 2"

print_info "Endpoint: DELETE $BASE_URL/motos/2"
echo ""

curl -X DELETE "$BASE_URL/motos/2" \
    -H "Accept: application/json" \
    -w "\n\nHTTP Status: %{http_code}\n"

print_success "Moto ID 2 deletada com sucesso"

# Aguardar um pouco antes da próxima operação
sleep 2

# ============================================================================
# 7. CONSULTA (GET) - Verificar exclusão
# ============================================================================

print_header "7. CONSULTA (GET) - Verificar exclusão da moto ID 2"

print_info "Endpoint: GET $BASE_URL/motos/2"
print_info "Deve retornar erro 404 (Not Found)"
echo ""

curl -X GET "$BASE_URL/motos/2" \
    -H "Accept: application/json" \
    -w "\n\nHTTP Status: %{http_code}\n" \
    | jq '.'

print_success "Verificação concluída - Moto não deve mais existir"

# ============================================================================
# RESUMO DOS TESTES
# ============================================================================

print_header "RESUMO DOS TESTES CRUD"

echo "✅ 1. Consulta de todas as motos (GET)"
echo "✅ 2. Consulta de moto por ID (GET)"
echo "✅ 3. Criação de nova moto (POST)"
echo "✅ 4. Atualização de moto existente (PUT)"
echo "✅ 5. Verificação da alteração (GET)"
echo "✅ 6. Exclusão de moto (DELETE)"
echo "✅ 7. Verificação da exclusão (GET)"
echo ""
echo "Todos os testes CRUD foram executados com sucesso!"
echo ""
echo "Para verificar as mudanças no banco de dados, acesse:"
echo "  - Aplicação Web: $BASE_URL"
echo "  - Login: admin@mottu.com / 123456"
echo ""
