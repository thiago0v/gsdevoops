# Entrega Sprint 3 - DevOps Tools & Cloud Computing

---

## Grupo

- **Nome Completo:** [Seu Nome Completo]
- **RM:** [Seu RM]

---

## Links

- **Repositório no GitHub:** [URL do seu repositório no GitHub]
- **Vídeo no YouTube:** [URL do seu vídeo no YouTube]

---

## 1. Descrição da Solução

A aplicação **MottuVision** é um painel de gestão web desenvolvido em Java com Spring Boot. Ele permite que operadores de filiais da Mottu monitorem em tempo real a frota de motos em seus pátios. A solução oferece as seguintes funcionalidades:

- **Dashboard Centralizado**: Visualização rápida de indicadores chave, como total de motos, status e alertas.
- **Listagem e Detalhes de Motos**: Consulta de todas as motos da filial, com acesso a informações detalhadas de cada uma.
- **Mapa do Pátio**: Representação visual da disposição das motos no pátio.
- **Gestão de Alertas**: Acompanhamento de alertas gerados automaticamente (ex: moto sem sinal).
- **Segurança**: Sistema de login com perfis de acesso (Operador e Administrador).

## 2. Benefícios para o Negócio

A solução MottuVision resolve problemas críticos de gestão de frotas, trazendo os seguintes benefícios:

- **Otimização da Operação**: A visualização em tempo real da localização e status das motos permite uma alocação mais rápida e eficiente dos veículos, reduzindo o tempo ocioso.
- **Redução de Perdas**: O sistema de alertas automáticos (ex: bateria baixa, moto parada há muito tempo) ajuda a prevenir roubos, perdas e a necessidade de manutenções corretivas caras.
- **Tomada de Decisão Baseada em Dados**: Os dashboards e relatórios fornecem dados valiosos para a gestão, permitindo identificar gargalos, otimizar a capacidade do pátio e melhorar a eficiência geral da frota.
- **Escalabilidade**: A arquitetura em nuvem permite que a solução cresça junto com a Mottu, suportando a adição de novas filiais e um número crescente de motos sem a necessidade de grandes investimentos em infraestrutura física.

## 3. Arquitetura da Solução

A arquitetura foi desenhada para ser simples, robusta e escalável, utilizando serviços PaaS (Platform as a Service) e contêineres na nuvem Azure.

![Arquitetura da Solução](./arquitetura-mottuvision.png)
*Figura 1: Diagrama da arquitetura da solução no Azure.*

### Fluxo de Funcionamento:

1.  **Desenvolvimento Local**: O desenvolvedor escreve o código Java (Spring Boot) e o `Dockerfile`.
2.  **Build e Push da Imagem**: A imagem Docker da aplicação é construída e enviada para o **Azure Container Registry (ACR)**, um registro de contêineres privado e seguro.
3.  **Provisionamento da Infraestrutura**: Utilizando a **Azure CLI**, são criados todos os recursos necessários:
    *   Um **Resource Group** para organizar os recursos.
    *   Um servidor **Azure Database for PostgreSQL** para armazenar os dados da aplicação de forma persistente e gerenciada.
    *   O **Azure Container Registry (ACR)** para armazenar a imagem Docker.
4.  **Deploy da Aplicação**: A aplicação é implantada no **Azure Container Instance (ACI)**. O ACI baixa a imagem do ACR e executa o contêiner.
5.  **Conectividade**: O ACI se conecta ao banco de dados PostgreSQL utilizando as credenciais e a connection string configuradas. O acesso de serviços Azure ao banco de dados é liberado no firewall.
6.  **Acesso do Usuário**: O usuário final acessa a aplicação através do endereço IP público ou FQDN fornecido pelo ACI.

## 4. Requisitos Específicos (ACR + ACI)

- **Imagens Oficiais**: O `Dockerfile` utiliza imagens oficiais do `maven:3.9.6-eclipse-temurin-17` para o build e `eclipse-temurin:17-jre-alpine` para a execução, garantindo segurança e confiabilidade.
- **Container não-root**: O container da aplicação é executado com um usuário não-privilegiado (`appuser`, UID 1001), uma prática de segurança essencial para minimizar a superfície de ataque.
- **Scripts de Build e Execução**: Todos os scripts necessários estão no diretório `azure-scripts/` e o `Dockerfile` está em `docker/Dockerfile`.
