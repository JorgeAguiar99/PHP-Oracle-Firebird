# Projeto Docker PHP 8.2 com Conexão PDO a Oracle e Firebird

Este é um **projeto simples** com um **Docker** configurado para rodar o **PHP 8.2**, preparado para utilização do **Composer** e conexões com bancos de dados **Oracle** (versão 12) e **Firebird** via **PDO**. 

Este repositório serve como base para projetos PHP que requerem integração com esses bancos de dados.

Foi originalmente criado para hospedar uma aplicação php com Laravel 11.

---

## Requisitos

Antes de começar, é necessário garantir que você tenha os seguintes pré-requisitos:

- **Docker** instalado na sua máquina. 
  - [Instruções de instalação do Docker](https://docs.docker.com/get-docker/)

- **Pacotes InstantClient do Oracle (RPM)**.
  - **Importante**: As bibliotecas Oracle Instant Client e arquivo de instalação do composer não estão incluídos neste repositório devido a questões de licenciamento. Você deve inserir as bibliotecas de instalação do Instant Client (basic, sqlplus e devel) na pasta `.docker`, bem como o arquivo de instalação do composer com o nome **composer-setup.php**.
  - Os pacotes podem ser obtidos em: [Oracle Instant Client Downloads](https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html)
- **Composer**
  - O instalador do composer pode ser obtido em: [Composer](https://getcomposer.org/installer)

---

## Como Usar

### 1. Clone o repositório

Clone o repositório para o seu ambiente local:

```bash
git clone https://github.com/seu-usuario/nome-do-repositorio.git
cd nome-do-repositorio
```

### 2. Configure o ambiente

- **Bibliotecas Oracle e Composer**: Certifique-se de que o arquivo de instalação do composer e as bibliotecas do Oracle Instant Client e as bibliotecas do Firebird estão localizadas corretamente no seu sistema para que o Docker possa acessá-las.
- **Versão do Instant Client**: Este projeto foi configurado para a versão 12.2 do Instant Client. Se você estiver usando uma versão diferente, altere os caminhos das pastas no `Dockerfile`.

### 3. Construa a Imagem Docker

Com tudo configurado, basta construir a imagem Docker com o comando:

```bash
docker-compose up -d
```

Isso vai construir e iniciar o container com o PHP 8.2 e composer, pronto para se conectar ao Oracle e Firebird via PDO.

---

## Estrutura de Arquivos

- **Dockerfile**: Contém todas as instruções para construir a imagem Docker, incluindo a instalação das dependências para conexão com o Oracle e Firebird.
- **docker-compose.yml**: Arquivo de configuração do Docker Compose para orquestrar os containers, configurar o timezone para América/São Paulo e definir o nome do container.
- **entrypoint.sh**: Script de entrada do container que executa `composer install`, `composer update`, define o **DocumentRoot** do Apache para `/var/www/html/public` e remove arquivos temporários gerados durante a instalação.
- **public/**: Diretório onde o **DocumentRoot** está configurado para apontar, geralmente utilizado para armazenar o arquivo `index.php` ou outros recursos públicos da aplicação.

---

## Conexões com Banco de Dados

### Conexão com Oracle

Este projeto utiliza a biblioteca **OCI8** para se conectar ao banco de dados Oracle via **PDO**. O **Instant Client Oracle** precisa estar instalado e acessível.

### Conexão com Firebird

A biblioteca **Firebird PDO** também está configurada no `Dockerfile`, permitindo que você se conecte ao banco de dados Firebird via **PDO**.

---

## Exemplo de Conexão com PDO

Aqui estão exemplos de como você pode se conectar aos bancos de dados **Oracle** e **Firebird** usando PDO:

```php
// Conexão com Oracle
try {
    $pdo = new PDO("oci:dbname=//localhost:1521/sua_base_oracle", "usuario", "senha");
    echo "Conexão com Oracle realizada com sucesso!";
} catch (PDOException $e) {
    echo "Erro na conexão com Oracle: " . $e->getMessage();
}

// Conexão com Firebird
try {
    $pdo = new PDO("firebird:dbname=localhost:/caminho/para/seu_banco.fdb", "usuario", "senha");
    echo "Conexão com Firebird realizada com sucesso!";
} catch (PDOException $e) {
    echo "Erro na conexão com Firebird: " . $e->getMessage();
}
```

---

## Contribuições

Este projeto está aberto para **aprendizado** e **contribuições**. Sinta-se à vontade para fazer um fork e enviar pull requests com melhorias, correções ou novas funcionalidades.

---

## Licença

Este projeto está sob a **Licença MIT**. Para mais detalhes, consulte o arquivo `LICENSE`.

