# Guia Completo de Deploy no Azure - MottuVision

## ⚠️ IMPORTANTE - SEGURANÇA

**TROQUE SUA SENHA** após fazer o deploy! As credenciais foram compartilhadas e devem ser alteradas imediatamente.

Para trocar a senha:
1. Acesse https://portal.azure.com
2. Clique no seu perfil (canto superior direito)
3. Vá em "Alterar senha"

---

## Pré-requisitos

### 1. Instalar Azure CLI

**Windows:**
```powershell
# Baixar e instalar
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
```

**macOS:**
```bash
brew install azure-cli
```

**Linux:**
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### 2. Instalar Docker

- Windows/Mac: https://www.docker.com/products/docker-desktop
- Linux: `sudo apt-get install docker.io docker-compose`

---

## Passo 1: Fazer Login no Azure

Abra o terminal e execute:

```bash
az login -u rm554914@fiap.com.br -p 'Vini1611@'
```

Ou use login interativo (mais seguro):

```bash
az login
```

Verificar se está logado:

```bash
az account show
```

---

## Passo 2: Extrair o Projeto

```bash
# Extrair o ZIP
unzip mottuvision-devops-entrega-final.zip
cd mottuvision-devops
```

---

## Passo 3: Provisionar Infraestrutura Azure

Este script irá criar:
- Resource Group
- Azure Container Registry (ACR)
- Azure Database for PostgreSQL

```bash
cd azure-scripts
chmod +x *.sh
./01-setup-azure.sh
```

**Tempo estimado:** 5-10 minutos

**O que será criado:**
- Resource Group: `rg-mottuvision-prod`
- ACR: `acrmottuvision`
- PostgreSQL: `psql-mottuvision-server`

**Credenciais geradas:**
- Serão salvas em `azure-credentials.txt`
- **GUARDE ESTE ARQUIVO COM SEGURANÇA!**

---

## Passo 4: Build e Push da Imagem Docker

Este script irá:
1. Fazer build da aplicação Java
2. Criar imagem Docker
3. Fazer push para o Azure Container Registry

```bash
./02-build-and-push.sh
```

**Tempo estimado:** 3-5 minutos

**O que acontece:**
- Maven compila o código Java
- Docker cria imagem multi-stage
- Imagem é enviada para ACR

---

## Passo 5: Deploy no Azure Container Instance

Este script irá:
1. Criar Azure Container Instance
2. Configurar variáveis de ambiente
3. Conectar ao banco PostgreSQL
4. Expor a aplicação publicamente

```bash
./03-deploy-aci.sh
```

**Tempo estimado:** 2-3 minutos

**Ao final, você verá:**
```
============================================================================
RESUMO DO DEPLOY
============================================================================

Azure Container Instance criado com sucesso!

Informações de Acesso:
  - Nome: aci-mottuvision-app
  - Estado: Running
  - IP Público: 20.226.XX.XXX
  - FQDN: aci-mottuvision-app.brazilsouth.azurecontainer.io
  - Porta: 8080

URLs de Acesso:
  - Por IP: http://20.226.XX.XXX:8080
  - Por FQDN: http://aci-mottuvision-app.brazilsouth.azurecontainer.io:8080

Credenciais de Login:
  - Admin: admin@mottu.com / 123456
  - Operador SP: operador.sp@mottu.com / 123456
```

**COPIE ESTAS INFORMAÇÕES!** Você precisará delas para o vídeo.

---

## Passo 6: Testar a Aplicação

### 6.1. Acessar Interface Web

Abra o navegador e acesse a URL fornecida:
```
http://[SEU_IP]:8080
```

**Login:**
- Email: `admin@mottu.com`
- Senha: `123456`

### 6.2. Testar API REST (CRUD)

Volte ao terminal e execute:

```bash
cd ../tests

# Definir a URL da aplicação
export BASE_URL=http://[SEU_IP]:8080

# Executar testes automatizados
./crud-tests-updated.sh
```

Você verá os testes de:
- ✅ Consulta de motos (GET)
- ✅ Criação de moto (POST)
- ✅ Atualização de moto (PUT)
- ✅ Exclusão de moto (DELETE)

---

## Passo 7: Verificar Dados no Banco PostgreSQL

### Opção 1: Via Azure Portal

1. Acesse https://portal.azure.com
2. Vá em "All resources"
3. Clique em `psql-mottuvision-server`
4. Vá em "Connection strings"
5. Use um cliente PostgreSQL (DBeaver, pgAdmin, etc.)

### Opção 2: Via psql (linha de comando)

```bash
# Instalar cliente PostgreSQL
sudo apt-get install postgresql-client

# Conectar ao banco
psql "host=psql-mottuvision-server.postgres.database.azure.com port=5432 dbname=mottuvision user=mottuvisionadmin@psql-mottuvision-server password=Mottu@2024#Secure sslmode=require"

# Consultar motos
SELECT * FROM moto;

# Sair
\q
```

---

## Passo 8: Gravar o Vídeo Demonstrativo

### Roteiro Sugerido (10-15 minutos)

**1. Introdução (1 min)**
- Apresentar o problema da Mottu
- Explicar a solução MottuVision

**2. Mostrar Recursos no Azure Portal (2 min)**
- Acessar portal.azure.com
- Mostrar Resource Group criado
- Mostrar ACR com a imagem
- Mostrar PostgreSQL Database
- Mostrar Container Instance rodando

**3. Demonstrar a Aplicação Web (3 min)**
- Fazer login
- Navegar pelo dashboard
- Mostrar lista de motos
- Mostrar detalhes de uma moto
- Mostrar mapa do pátio
- Mostrar alertas

**4. Demonstrar CRUD via API REST (5 min)**

**INSERT - Criar nova moto:**
```bash
curl -X POST http://[SEU_IP]:8080/api/motos \
  -H "Content-Type: application/json" \
  -d '{
    "placa": "DEMO123",
    "modelo": "Honda CG 160",
    "ano": 2024,
    "filialId": 1,
    "status": "DISPONIVEL",
    "posicaoX": 15,
    "posicaoY": 20
  }'
```
→ Mostrar no banco de dados que o registro foi criado

**UPDATE - Atualizar status:**
```bash
curl -X PUT http://[SEU_IP]:8080/api/motos/1 \
  -H "Content-Type: application/json" \
  -d '{
    "placa": "ABC1D23",
    "modelo": "Honda CG 160",
    "ano": 2023,
    "filialId": 1,
    "status": "MANUTENCAO",
    "posicaoX": 5,
    "posicaoY": 3
  }'
```
→ Mostrar no banco que o status mudou para MANUTENCAO

**SELECT - Consultar:**
```bash
curl http://[SEU_IP]:8080/api/motos/1
```
→ Mostrar o JSON retornado

**DELETE - Deletar:**
```bash
curl -X DELETE http://[SEU_IP]:8080/api/motos/2
```
→ Mostrar no banco que o registro foi removido

**5. Conclusão (1 min)**
- Resumir benefícios
- Mencionar escalabilidade
- Próximos passos

---

## Passo 9: Fazer Upload do Vídeo no YouTube

1. Acesse https://studio.youtube.com
2. Clique em "Criar" → "Enviar vídeo"
3. Selecione o arquivo do vídeo
4. Preencha:
   - **Título:** "MottuVision - Projeto DevOps & Cloud Computing - Sprint 3"
   - **Descrição:** Incluir nomes e RMs dos integrantes
   - **Visibilidade:** Não listado (ou Público)
5. Copie o link do vídeo

---

## Passo 10: Atualizar PDF com os Links

### 10.1. Criar Repositório no GitHub

```bash
cd /caminho/para/mottuvision-devops

# Inicializar Git
git init
git add .
git commit -m "Initial commit - MottuVision DevOps Sprint 3"

# Criar repositório no GitHub (via interface web)
# Depois executar:
git remote add origin https://github.com/[SEU_USUARIO]/mottuvision-devops.git
git branch -M main
git push -u origin main
```

### 10.2. Atualizar o Documento

Edite o arquivo `docs/ENTREGA_SPRINT3_DEVOPS_FINAL.md`:

Substitua:
- `[SEU_USUARIO]` → seu usuário do GitHub
- `[VIDEO_ID]` → ID do vídeo do YouTube

### 10.3. Regenerar o PDF

```bash
# Se tiver o manus-md-to-pdf instalado
manus-md-to-pdf docs/ENTREGA_SPRINT3_DEVOPS_FINAL.md docs/ENTREGA_SPRINT3_DEVOPS_FINAL.pdf

# Ou use um conversor online:
# https://www.markdowntopdf.com/
```

---

## Comandos Úteis

### Ver logs da aplicação
```bash
az container logs --name aci-mottuvision-app --resource-group rg-mottuvision-prod
```

### Ver status do container
```bash
az container show --name aci-mottuvision-app --resource-group rg-mottuvision-prod
```

### Reiniciar container
```bash
az container restart --name aci-mottuvision-app --resource-group rg-mottuvision-prod
```

### Deletar tudo (após a apresentação)
```bash
az group delete --name rg-mottuvision-prod --yes --no-wait
```

---

## Troubleshooting

### Erro: "Resource already exists"
```bash
# Deletar o resource group existente
az group delete --name rg-mottuvision-prod --yes
# Aguardar alguns minutos e tentar novamente
```

### Erro: "ACR name not available"
```bash
# Editar o script 01-setup-azure.sh
# Mudar ACR_NAME="acrmottuvision" para ACR_NAME="acrmottuvision554914"
```

### Container não inicia
```bash
# Ver logs de erro
az container logs --name aci-mottuvision-app --resource-group rg-mottuvision-prod

# Verificar se o PostgreSQL está acessível
az postgres server show --name psql-mottuvision-server --resource-group rg-mottuvision-prod
```

### Aplicação retorna erro 500
```bash
# Verificar variáveis de ambiente
az container show --name aci-mottuvision-app --resource-group rg-mottuvision-prod --query containers[0].environmentVariables
```

---

## Custos Estimados

| Recurso | Custo Mensal (USD) |
|---------|-------------------|
| Azure Container Registry (Basic) | ~$5 |
| Azure Container Instance (1 vCore, 1.5GB) | ~$35 |
| PostgreSQL (Basic, B_Gen5_1) | ~$25 |
| **TOTAL** | **~$65/mês** |

**IMPORTANTE:** Após a apresentação, delete os recursos para não gerar custos:
```bash
az group delete --name rg-mottuvision-prod --yes
```

---

## ✅ Checklist Final

- [ ] Azure CLI instalado
- [ ] Docker instalado
- [ ] Login no Azure realizado
- [ ] Script 01 executado (infraestrutura criada)
- [ ] Script 02 executado (imagem no ACR)
- [ ] Script 03 executado (app rodando no ACI)
- [ ] Aplicação web acessível
- [ ] Testes CRUD funcionando
- [ ] Vídeo gravado
- [ ] Vídeo no YouTube
- [ ] Repositório no GitHub
- [ ] PDF atualizado com links
- [ ] Tudo testado e funcionando

---

**Boa sorte na apresentação! 🚀**

**LEMBRE-SE:** Troque sua senha após o deploy!
