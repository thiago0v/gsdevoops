# Checklist de Entrega - Sprint 3 DevOps

## ✅ Requisitos Obrigatórios

### 1. Descrição da Solução
- [x] Arquivo README.md com descrição completa da aplicação
- [x] Explicação das funcionalidades principais
- [x] Tecnologias utilizadas documentadas

### 2. Benefícios para o Negócio
- [x] Seção específica no README.md explicando os benefícios
- [x] Problemas que a solução resolve
- [x] Melhorias que ela traz para o negócio

### 3. Banco de Dados em Nuvem
- [x] Azure Database for PostgreSQL configurado
- [x] Script DDL completo (database/script_bd.sql)
- [x] Não utiliza H2 em produção
- [x] Banco de dados gerenciado (PaaS)

### 4. CRUD Completo
- [x] Operações de Inclusão implementadas
- [x] Operações de Alteração implementadas
- [x] Operações de Exclusão implementadas
- [x] Operações de Consulta implementadas
- [x] CRUD sobre a tabela MOTO

### 5. Dados Reais
- [x] Pelo menos 2 registros inseridos no banco
- [x] Scripts de inicialização com dados de exemplo
- [x] Dados reais e relevantes para o contexto

### 6. Código-fonte no GitHub
- [x] Repositório criado
- [x] Código-fonte completo
- [x] README.md atualizado
- [x] .gitignore configurado

### 7. Arquivo PDF com Informações
- [x] Template criado (docs/ENTREGA_SPRINT3_DEVOPS.md)
- [ ] Preencher nome completo e RM
- [ ] Adicionar link do repositório GitHub
- [ ] Adicionar link do vídeo YouTube
- [ ] Converter para PDF

## ✅ Requisitos Específicos (ACR + ACI)

### 8.1. Imagens Oficiais
- [x] Dockerfile usa imagem oficial: maven:3.9.6-eclipse-temurin-17
- [x] Dockerfile usa imagem oficial: eclipse-temurin:17-jre-alpine
- [x] Imagens de fontes confiáveis (Eclipse Foundation)

### 8.2. Container Não-Root
- [x] Container executa com usuário não-privilegiado (appuser)
- [x] UID 1001 configurado
- [x] Não roda como root ou admin

### 8.3. Dockerfile ou Docker Compose
- [x] Dockerfile criado (docker/Dockerfile)
- [x] Docker Compose criado (docker/docker-compose.yml)
- [x] Ambos funcionais

### 8.4. Scripts de Build e Execução
- [x] Script 01-setup-azure.sh (provisionamento)
- [x] Script 02-build-and-push.sh (build e push)
- [x] Script 03-deploy-aci.sh (deploy ACI)
- [x] Script docker-commands.sh (referência)
- [x] Todos os comandos documentados

## ✅ Critérios de Avaliação

### 1. Desenho da Arquitetura (até 10 pontos)
- [x] Diagrama de arquitetura criado
- [x] Fluxos documentados
- [x] Recursos identificados
- [x] Explicação do funcionamento

### 2. DDL das Tabelas (até 10 pontos)
- [x] Arquivo script_bd.sql separado
- [x] DDL completo com CREATE TABLE
- [x] Chaves primárias definidas
- [x] Chaves estrangeiras definidas
- [x] Comentários nas tabelas e colunas
- [x] Estrutura bem organizada

### 3. Repositório GitHub (até 10 pontos)
- [x] Repositório separado para DevOps
- [x] README.md explicativo
- [x] Passo a passo para deploy
- [x] Scripts de teste incluídos
- [x] Exemplos de POST/PUT em JSON

### 4. Vídeo Demonstrativo (até 70 pontos)
- [ ] Gravar vídeo em 720p mínimo
- [ ] Áudio claro e explicação por voz
- [ ] Mostrar deploy seguindo README.md
- [ ] Demonstrar criação do App e BD na nuvem
- [ ] Demonstrar testes do App e BD
- [ ] Demonstrar CRUD completo:
  - [ ] Inserção de registro → exibir no banco
  - [ ] Atualização do registro → exibir no banco
  - [ ] Exclusão do registro → exibir no banco
  - [ ] Consulta de registros
- [ ] Evidenciar integração total App + BD

## 📋 Checklist de Entrega Final

- [ ] Código-fonte commitado no GitHub
- [ ] README.md completo e revisado
- [ ] Script DDL testado
- [ ] Scripts Azure CLI testados
- [ ] Dockerfile testado localmente
- [ ] Docker Compose testado localmente
- [ ] Deploy realizado no Azure
- [ ] CRUD testado na aplicação em produção
- [ ] Vídeo gravado e publicado no YouTube
- [ ] PDF preenchido com nome, RM e links
- [ ] Tudo funcionando 100%

## 🎯 Próximos Passos

1. Criar repositório no GitHub
2. Fazer commit de todo o código
3. Testar os scripts Azure CLI
4. Fazer deploy no Azure
5. Testar a aplicação em produção
6. Gravar o vídeo demonstrativo
7. Preencher o PDF com as informações
8. Fazer upload do vídeo no YouTube
9. Submeter a entrega

---

**Boa sorte! 🚀**
