#!/bin/bash
# ============================================================================
# Comandos Docker - Referência
# Descrição: Comandos utilizados para build, push e execução local
# ============================================================================

# ============================================================================
# COMANDOS PARA BUILD LOCAL
# ============================================================================

# Build da imagem Docker localmente
docker build -t mottuvision-app:latest -f docker/Dockerfile .

# Build com tag específica
docker build -t mottuvision-app:v1.0.0 -f docker/Dockerfile .

# ============================================================================
# COMANDOS PARA EXECUÇÃO LOCAL
# ============================================================================

# Executar container localmente (sem banco de dados)
docker run -d \
    --name mottuvision-app \
    -p 8080:8080 \
    -e SPRING_PROFILES_ACTIVE=dev \
    mottuvision-app:latest

# Executar com docker-compose (com banco de dados PostgreSQL)
docker-compose -f docker/docker-compose.yml up -d

# Parar containers do docker-compose
docker-compose -f docker/docker-compose.yml down

# Ver logs do container
docker logs mottuvision-app

# Ver logs em tempo real
docker logs -f mottuvision-app

# Acessar shell do container
docker exec -it mottuvision-app /bin/sh

# ============================================================================
# COMANDOS PARA PUSH NO AZURE CONTAINER REGISTRY
# ============================================================================

# Login no ACR
az acr login --name acrmottuvision

# Tag da imagem para o ACR
docker tag mottuvision-app:latest acrmottuvision.azurecr.io/mottuvision-app:latest

# Push da imagem para o ACR
docker push acrmottuvision.azurecr.io/mottuvision-app:latest

# Listar imagens no ACR
az acr repository list --name acrmottuvision --output table

# Listar tags de uma imagem no ACR
az acr repository show-tags --name acrmottuvision --repository mottuvision-app --output table

# ============================================================================
# COMANDOS PARA LIMPEZA
# ============================================================================

# Parar container
docker stop mottuvision-app

# Remover container
docker rm mottuvision-app

# Remover imagem
docker rmi mottuvision-app:latest

# Remover todas as imagens não utilizadas
docker image prune -a

# Remover todos os containers parados
docker container prune

# ============================================================================
# COMANDOS PARA INSPEÇÃO
# ============================================================================

# Ver informações do container
docker inspect mottuvision-app

# Ver processos rodando no container
docker top mottuvision-app

# Ver estatísticas de uso de recursos
docker stats mottuvision-app

# Ver histórico da imagem
docker history mottuvision-app:latest

# ============================================================================
# COMANDOS PARA TROUBLESHOOTING
# ============================================================================

# Verificar se o container está rodando
docker ps | grep mottuvision

# Ver todos os containers (incluindo parados)
docker ps -a

# Ver logs com timestamp
docker logs --timestamps mottuvision-app

# Ver últimas 100 linhas de log
docker logs --tail 100 mottuvision-app

# Executar comando dentro do container
docker exec mottuvision-app ps aux

# Verificar conectividade de rede
docker exec mottuvision-app ping -c 3 google.com

# ============================================================================
# NOTAS IMPORTANTES
# ============================================================================

# 1. O container NÃO roda como root (usuário: appuser, UID: 1001)
# 2. A porta padrão da aplicação é 8080
# 3. O health check está configurado no Dockerfile
# 4. Imagens oficiais: eclipse-temurin (OpenJDK) e maven (build)
