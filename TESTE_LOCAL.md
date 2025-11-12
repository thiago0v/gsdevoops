# Guia de Teste Local - MottuVision

Este guia mostra como testar a aplicação localmente antes de fazer o deploy no Azure.

## Pré-requisitos

- Docker instalado e em execução
- Docker Compose instalado

## Passo 1: Iniciar a Aplicação com Docker Compose

O Docker Compose irá iniciar dois containers:
1. **PostgreSQL**: Banco de dados
2. **MottuVision App**: Aplicação Java Spring Boot

```bash
# Navegar até o diretório do projeto
cd mottuvision-devops

# Iniciar os containers
docker-compose -f docker/docker-compose.yml up -d

# Aguardar a aplicação iniciar (pode levar 1-2 minutos)
docker-compose -f docker/docker-compose.yml logs -f app
```

Aguarde até ver a mensagem: `Started MottuvisionApplication`

## Passo 2: Verificar se a Aplicação Está Rodando

```bash
# Verificar health check
curl http://localhost:8080/actuator/health

# Deve retornar: {"status":"UP"}
```

## Passo 3: Testar a Interface Web

Abra o navegador e acesse: http://localhost:8080

**Credenciais de Login:**
- Email: `admin@mottu.com`
- Senha: `123456`

Você verá o dashboard com as motos cadastradas.

## Passo 4: Testar a API REST (CRUD)

### Opção 1: Usar o Script Automatizado

```bash
# Executar todos os testes CRUD
cd tests
./crud-tests-updated.sh
```

### Opção 2: Testar Manualmente com curl

#### 1. Listar todas as motos (GET)
```bash
curl http://localhost:8080/api/motos | jq
```

#### 2. Buscar moto por ID (GET)
```bash
curl http://localhost:8080/api/motos/1 | jq
```

#### 3. Criar nova moto (POST)
```bash
curl -X POST http://localhost:8080/api/motos \
  -H "Content-Type: application/json" \
  -d '{
    "placa": "TEST123",
    "modelo": "Honda CG 160",
    "ano": 2024,
    "filialId": 1,
    "status": "DISPONIVEL",
    "posicaoX": 15,
    "posicaoY": 20
  }' | jq
```

#### 4. Atualizar moto (PUT)
```bash
curl -X PUT http://localhost:8080/api/motos/1 \
  -H "Content-Type: application/json" \
  -d '{
    "placa": "ABC1D23",
    "modelo": "Honda CG 160",
    "ano": 2023,
    "filialId": 1,
    "status": "MANUTENCAO",
    "posicaoX": 5,
    "posicaoY": 3
  }' | jq
```

#### 5. Deletar moto (DELETE)
```bash
curl -X DELETE http://localhost:8080/api/motos/2
```

## Passo 5: Verificar os Dados no Banco

### Conectar ao PostgreSQL

```bash
# Entrar no container do PostgreSQL
docker exec -it mottuvision-postgres psql -U mottu_user -d mottuvision

# Consultar motos
SELECT * FROM moto;

# Sair
\q
```

## Passo 6: Ver Logs da Aplicação

```bash
# Ver logs em tempo real
docker-compose -f docker/docker-compose.yml logs -f app

# Ver últimas 100 linhas
docker-compose -f docker/docker-compose.yml logs --tail 100 app
```

## Passo 7: Parar a Aplicação

```bash
# Parar e remover os containers
docker-compose -f docker/docker-compose.yml down

# Parar e remover containers + volumes (apaga dados do banco)
docker-compose -f docker/docker-compose.yml down -v
```

## Troubleshooting

### Aplicação não inicia

```bash
# Verificar logs de erro
docker-compose -f docker/docker-compose.yml logs app

# Verificar se o PostgreSQL está rodando
docker-compose -f docker/docker-compose.yml ps
```

### Porta 8080 já está em uso

```bash
# Parar o processo que está usando a porta
sudo lsof -ti:8080 | xargs kill -9

# Ou alterar a porta no docker-compose.yml
# Mudar "8080:8080" para "8081:8080"
```

### Erro de conexão com o banco

```bash
# Verificar se o PostgreSQL está saudável
docker-compose -f docker/docker-compose.yml ps

# Reiniciar os containers
docker-compose -f docker/docker-compose.yml restart
```

## Endpoints Disponíveis

### API REST
- `GET /api/motos` - Lista todas as motos
- `GET /api/motos/{id}` - Busca moto por ID
- `POST /api/motos` - Cria nova moto
- `PUT /api/motos/{id}` - Atualiza moto
- `DELETE /api/motos/{id}` - Deleta moto

### Interface Web
- `/` - Redireciona para login
- `/login` - Página de login
- `/dashboard` - Dashboard principal
- `/motos` - Lista de motos
- `/motos/{id}` - Detalhes da moto
- `/mapa` - Mapa do pátio
- `/alertas` - Lista de alertas

### Monitoramento
- `/actuator/health` - Health check
- `/actuator/info` - Informações da aplicação

---

**Pronto!** Agora você pode testar a aplicação localmente antes de fazer o deploy no Azure.
