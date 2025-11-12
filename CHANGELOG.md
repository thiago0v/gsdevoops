# Changelog - MottuVision DevOps

## Implementações do Passo 3 (API REST CRUD)

### ✅ Novos Arquivos Criados

#### 1. Controller REST
- **`src/main/java/br/com/mottu/mottuvision/controller/MotoRestController.java`**
  - Controller REST completo para operações CRUD
  - Endpoints: GET, POST, PUT, DELETE
  - Mapeamento: `/api/motos`

#### 2. DTO (Data Transfer Object)
- **`src/main/java/br/com/mottu/mottuvision/dto/MotoDTO.java`**
  - Classe para transferência de dados via API
  - Serialização JSON configurada
  - Campos: id, placa, modelo, ano, filialId, filialNome, status, posicaoX, posicaoY, ultimaAtualizacao

#### 3. Scripts de Teste
- **`tests/crud-tests-updated.sh`**
  - Script bash para testar todos os endpoints CRUD
  - Suporta testes locais e em produção
  - Validação automática de respostas

#### 4. Documentação
- **`TESTE_LOCAL.md`**
  - Guia completo para testes locais
  - Instruções passo a passo
  - Troubleshooting

- **`CHANGELOG.md`** (este arquivo)
  - Registro de todas as mudanças

### ✅ Arquivos Modificados

#### 1. SecurityConfig.java
- Adicionado acesso público aos endpoints `/api/**`
- Desabilitado CSRF para API REST
- Mantida segurança para interface web

#### 2. pom.xml
- Adicionada dependência: `postgresql` (driver JDBC)
- Adicionada dependência: `spring-boot-starter-actuator` (health check)

### 📋 Endpoints da API REST

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/motos` | Lista todas as motos |
| GET | `/api/motos/{id}` | Busca moto por ID |
| POST | `/api/motos` | Cria nova moto |
| PUT | `/api/motos/{id}` | Atualiza moto existente |
| DELETE | `/api/motos/{id}` | Deleta moto |

### 🔧 Funcionalidades Implementadas

#### CRUD Completo
- ✅ **Create (POST)**: Criação de novas motos com validação de filial
- ✅ **Read (GET)**: Consulta de todas as motos ou por ID específico
- ✅ **Update (PUT)**: Atualização de dados da moto incluindo status
- ✅ **Delete (DELETE)**: Remoção de motos do sistema

#### Validações
- ✅ Validação de filial existente antes de criar/atualizar
- ✅ Retorno 404 quando moto não é encontrada
- ✅ Retorno 201 Created ao criar nova moto
- ✅ Retorno 204 No Content ao deletar moto

#### Conversão de Dados
- ✅ Conversão automática de Entity para DTO
- ✅ Serialização JSON com formato de data ISO 8601
- ✅ Inclusão de nome da filial no response

### 🧪 Como Testar

#### Teste Local (Docker Compose)
```bash
# 1. Iniciar aplicação
docker-compose -f docker/docker-compose.yml up -d

# 2. Aguardar inicialização (1-2 minutos)
docker-compose -f docker/docker-compose.yml logs -f app

# 3. Executar testes
cd tests
./crud-tests-updated.sh
```

#### Teste em Produção (Azure)
```bash
# Definir URL do Azure
export BASE_URL=http://<IP_DO_SEU_ACI>:8080

# Executar testes
cd tests
./crud-tests-updated.sh
```

### 📊 Exemplo de Request/Response

#### POST - Criar Moto
**Request:**
```json
{
  "placa": "NEW1A23",
  "modelo": "Honda Biz 125",
  "ano": 2024,
  "filialId": 1,
  "status": "DISPONIVEL",
  "posicaoX": 10,
  "posicaoY": 10
}
```

**Response (201 Created):**
```json
{
  "id": 3,
  "placa": "NEW1A23",
  "modelo": "Honda Biz 125",
  "ano": 2024,
  "filialId": 1,
  "filialNome": "Mottu São Paulo - Centro",
  "status": "DISPONIVEL",
  "posicaoX": 10,
  "posicaoY": 10,
  "ultimaAtualizacao": "2024-11-12T11:45:30"
}
```

### 🔐 Segurança

- API REST configurada como **pública** para demonstração
- Em produção, recomenda-se adicionar autenticação JWT ou API Key
- CSRF desabilitado apenas para `/api/**`
- Interface web continua protegida com login

### 🚀 Próximos Passos

1. ✅ Código implementado e testado
2. ⏳ Fazer commit no GitHub
3. ⏳ Executar deploy no Azure
4. ⏳ Testar CRUD em produção
5. ⏳ Gravar vídeo demonstrativo

---

**Versão:** 1.1.0  
**Data:** 12/11/2024  
**Autor:** Manus AI
