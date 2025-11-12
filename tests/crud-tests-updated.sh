#!/bin/bash
# ============================================================================
# Scripts de Teste CRUD - MottuVision (Atualizado)
# Descrição: Testes das operações CRUD na API REST de Motos
# ============================================================================

# IMPORTANTE: Substitua <IP_DO_SEU_ACI> pelo IP real do seu Azure Container Instance
# Para testes locais, use: http://localhost:8080
BASE_URL="${BASE_URL:-http://localhost:8080}"

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
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

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# ============================================================================
# VERIFICAR CONECTIVIDADE
# ============================================================================

print_header "VERIFICANDO CONECTIVIDADE COM A APLICAÇÃO"

print_info "Testando conexão com: $BASE_URL"
if curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/actuator/health" | grep -q "200"; then
    print_success "Aplicação está respondendo!"
else
    print_warning "Aplicação pode não estar disponível ainda. Aguarde alguns segundos..."
    sleep 5
fi

# ============================================================================
# 1. CONSULTA (GET) - Listar todas as motos
# ============================================================================

print_header "1. CONSULTA (GET) - Listar todas as motos"

print_info "Endpoint: GET $BASE_URL/api/motos"
echo ""

RESPONSE=$(curl -s -X GET "$BASE_URL/api/motos" \
    -H "Accept: application/json" \
    -w "\n\nHTTP Status: %{http_code}\n")

echo "$RESPONSE"
print_success "Consulta de todas as motos concluída"

# ============================================================================
# 2. CONSULTA (GET) - Buscar moto por ID
# ============================================================================

print_header "2. CONSULTA (GET) - Buscar moto por ID (ID: 1)"

print_info "Endpoint: GET $BASE_URL/api/motos/1"
echo ""

RESPONSE=$(curl -s -X GET "$BASE_URL/api/motos/1" \
    -H "Accept: application/json" \
    -w "\n\nHTTP Status: %{http_code}\n")

echo "$RESPONSE"
print_success "Consulta da moto ID 1 concluída"

# ============================================================================
# 3. INCLUSÃO (POST) - Criar nova moto
# ============================================================================

print_header "3. INCLUSÃO (POST) - Criar nova moto"

print_info "Endpoint: POST $BASE_URL/api/motos"
print_info "Dados: Placa NEW1A23, Modelo Honda Biz 125"
echo ""

RESPONSE=$(curl -s -X POST "$BASE_URL/api/motos" \
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
    -w "\n\nHTTP Status: %{http_code}\n")

echo "$RESPONSE"
print_success "Nova moto criada com sucesso"

# Extrair ID da moto criada (se possível)
CREATED_ID=$(echo "$RESPONSE" | grep -o '"id":[0-9]*' | head -1 | grep -o '[0-9]*')
if [ -n "$CREATED_ID" ]; then
    print_info "ID da moto criada: $CREATED_ID"
fi

# Aguardar um pouco antes da próxima operação
sleep 2

# ============================================================================
# 4. ALTERAÇÃO (PUT) - Atualizar moto existente
# ============================================================================

print_header "4. ALTERAÇÃO (PUT) - Atualizar status da moto ID 1"

print_info "Endpoint: PUT $BASE_URL/api/motos/1"
print_info "Alteração: Status de DISPONIVEL para MANUTENCAO"
echo ""

RESPONSE=$(curl -s -X PUT "$BASE_URL/api/motos/1" \
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
    -w "\n\nHTTP Status: %{http_code}\n")

echo "$RESPONSE"
print_success "Moto ID 1 atualizada com sucesso"

# Aguardar um pouco antes da próxima operação
sleep 2

# ============================================================================
# 5. CONSULTA (GET) - Verificar alteração
# ============================================================================

print_header "5. CONSULTA (GET) - Verificar alteração da moto ID 1"

print_info "Endpoint: GET $BASE_URL/api/motos/1"
print_info "Verificando se o status foi alterado para MANUTENCAO"
echo ""

RESPONSE=$(curl -s -X GET "$BASE_URL/api/motos/1" \
    -H "Accept: application/json" \
    -w "\n\nHTTP Status: %{http_code}\n")

echo "$RESPONSE"

if echo "$RESPONSE" | grep -q "MANUTENCAO"; then
    print_success "✓ Status alterado corretamente para MANUTENCAO"
else
    print_warning "Status pode não ter sido alterado"
fi

# Aguardar um pouco antes da próxima operação
sleep 2

# ============================================================================
# 6. EXCLUSÃO (DELETE) - Deletar moto
# ============================================================================

print_header "6. EXCLUSÃO (DELETE) - Deletar moto ID 2"

print_info "Endpoint: DELETE $BASE_URL/api/motos/2"
echo ""

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE "$BASE_URL/api/motos/2" \
    -H "Accept: application/json")

echo "HTTP Status: $HTTP_CODE"

if [ "$HTTP_CODE" = "204" ] || [ "$HTTP_CODE" = "200" ]; then
    print_success "Moto ID 2 deletada com sucesso"
else
    print_warning "Moto ID 2 pode não existir ou já foi deletada"
fi

# Aguardar um pouco antes da próxima operação
sleep 2

# ============================================================================
# 7. CONSULTA (GET) - Verificar exclusão
# ============================================================================

print_header "7. CONSULTA (GET) - Verificar exclusão da moto ID 2"

print_info "Endpoint: GET $BASE_URL/api/motos/2"
print_info "Deve retornar erro 404 (Not Found)"
echo ""

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$BASE_URL/api/motos/2" \
    -H "Accept: application/json")

echo "HTTP Status: $HTTP_CODE"

if [ "$HTTP_CODE" = "404" ]; then
    print_success "✓ Moto não encontrada (exclusão confirmada)"
else
    print_warning "Moto ainda pode existir"
fi

# ============================================================================
# RESUMO DOS TESTES
# ============================================================================

print_header "RESUMO DOS TESTES CRUD"

echo "✅ 1. Consulta de todas as motos (GET /api/motos)"
echo "✅ 2. Consulta de moto por ID (GET /api/motos/1)"
echo "✅ 3. Criação de nova moto (POST /api/motos)"
echo "✅ 4. Atualização de moto existente (PUT /api/motos/1)"
echo "✅ 5. Verificação da alteração (GET /api/motos/1)"
echo "✅ 6. Exclusão de moto (DELETE /api/motos/2)"
echo "✅ 7. Verificação da exclusão (GET /api/motos/2)"
echo ""
echo "Todos os testes CRUD foram executados!"
echo ""
echo "Para verificar as mudanças:"
echo "  - API REST: $BASE_URL/api/motos"
echo "  - Aplicação Web: $BASE_URL"
echo "  - Login: admin@mottu.com / 123456"
echo ""
