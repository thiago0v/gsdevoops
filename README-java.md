# MottuVision - Painel de Gestão de Pátios (Java Advanced)

Este projeto implementa um painel web para monitorar motos em pátios de filiais da Mottu,
usando Java + Spring Boot, como parte da disciplina **Java Advanced**.

## ✨ Visão geral da solução

A aplicação permite que um operador de filial:
- Faça login com e-mail corporativo;
- Visualize um **dashboard** com indicadores da filial (total de motos, motos em alerta, status geral);
- Liste todas as motos do pátio, com status e última atualização;
- Veja o **detalhe de uma moto**;
- Consulte um **mapa simplificado do pátio**, representado por uma grade (X/Y);
- Acompanhe os **últimos alertas gerados automaticamente** (ex: moto sem sinal).

## 🧠 Arquitetura e tecnologias

- Java 17
- Spring Boot 3 (Web, Thymeleaf, Security, Data JPA, Scheduling)
- H2 Database (ambiente local)
- Bootstrap 5 (UI)
- Padrão em camadas: `controller -> service -> repository -> entity`

### Principais conceitos de Java Advanced utilizados

- Inversão de controle e injeção de dependência (Spring)
- Separação de responsabilidades por camadas
- Entidades JPA mapeadas a um modelo relacional compatível com o desafio da Mottu
- Regras de negócio em serviços (`MotoService`, `AlertaService`)
- Agendamento de tarefas (`@Scheduled`) para geração automática de alertas
- Segurança com Spring Security (login de usuário, roles)
- Teste de contexto básico com Spring Boot Test

## ▶️ Como rodar localmente

Pré-requisitos:
- Java 17+
- Maven 3+

Passos:

```bash
mvn clean install
mvn spring-boot:run
```

Acesse em: `http://localhost:8080`

Login de exemplo:

- `admin@mottu.com` / `123456`
- `operador.sp@mottu.com` / `123456`
- `operador.rj@mottu.com` / `123456`

## 🌐 Deploy

Para a entrega da disciplina, recomenda-se realizar o deploy em algum serviço como:

- Render
- Railway
- Azure Web App
- Heroku (se disponível)

O comando de inicialização é o padrão do Spring Boot:

```bash
mvn spring-boot:run
```

ou gerar um JAR:

```bash
mvn package
java -jar target/mottuvision-0.0.1-SNAPSHOT.jar
```

## 🧩 Integração com outras disciplinas

- **Banco de Dados / PL-SQL**: As entidades `Filial`, `Moto`, `Alerta` correspondem às tabelas modeladas no desafio
  maior do semestre e podem ser espelhadas em scripts SQL para Oracle, Postgres, etc.
- **IoT**: Este backend pode expor endpoints REST para receber eventos de dispositivos IoT (GPS, ignição, etc.),
  atualizando a posição e o status das motos.
- **Visão Computacional**: Um módulo Python com YOLOv8 pode enviar detecções para este backend (ex: placa e posição),
  que seriam refletidas no dashboard e no mapa do pátio.
- **.NET / Outros serviços**: Serviços externos podem consumir os dados de motos e alertas expostos pelo backend Java.

## 📽️ Sugestão de fluxo da apresentação

1. Contexto do problema da Mottu e visão do MottuVision;
2. Demonstração do sistema: login, dashboard, motos, mapa, alertas;
3. Explicação técnica rápida: arquitetura, camadas, serviços, segurança;
4. Integração com as demais disciplinas (SQL, IoT, visão computacional);
5. Encerramento com próximos passos (ex: ligar com câmeras reais, IoT real, etc.).

---

Este projeto é um ponto de partida funcional e pode ser estendido com:
- APIs REST públicas para integração com outros módulos;
- Telas adicionais (simulador de eventos, CRUD completo);
- Migração para um banco em nuvem (PostgreSQL gerenciado);
- Monitoramento e observabilidade (logs, métricas, etc.).
