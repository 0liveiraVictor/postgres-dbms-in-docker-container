# Tutorial de Instalação do SGBD Postgres em um Container Docker

## Guia básico para instalação do sistema de gerenciamento de banco de dados relacional postgres em um ambiente desejado a partir de ferramenta de containerização docker.

<br>

[![README](https://img.shields.io/static/v1?label=readme&message=en-US&color=blue&style=plastic)](./README.md)

<div align="center">
    <img src="./img/docker_and_postgres.png" alt="docker and postgres" width="540" height="436.5">
</div>
<br>

O Postgres é um Sistema de Gerenciamento de Banco de Dados (SGBD) objeto-relacional e tem suas origens no projeto POSTGRES, criado na Universidade da Califórnia em Berkeley, na década de 80. Com décadas de desenvolvimento contínuo, o Postgres se consolidou como o banco de dados de código aberto mais avançado disponível atualmente. Considerado entre os 4 SGBDs mais utilizados do mercado, dados do [DB-ENGINES](https://db-engines.com/en/ranking) demonstram o quão popular o PostgreSQL se tornou.

Nesse tutorial, você aprenderá a realizar a instalação de uma instância Postgres em um ambiente host, utilizando a tecnologia Docker e aprendendo seus conceitos envolvidos, tais como: imagem, container, volume e um pouco sobre DockerHub. Adicionalmente, a instalação da ferramenta gráfica de gerenciamento do Postgres, o pgAdmin, também será abordada. Caso se sinta confortável, você pode pular algumas itens e acessar diretamente as seções de [Instalação do Postgres](#instalação-do-postgres) e [Instalação do pgAdmin](#instalação-do-pgadmin).

## Visão Geral da Plataforma Docker

O [Docker](https://www.docker.com/) é uma plataforma de software projetada para facilitar a criação, teste, distribuição e implantação de aplicativos de forma ágil. Ele organiza o software em uma estrutura denominada contêiner, que é a unidade padronizada que contém todos os elementos necessários para sua execução, tais como: bibliotecas, ferramentas do sistema, código e ambiente de execução. Com o Docker, é possível (de forma rápida e fácil) distribuir e implementar softwares em qualquer ambiente, escalando suas aplicações conforme a demanda e garantindo seu bom funcionamento.

### O que é uma Imagem Docker?

Uma imagem Docker é um pacote leve que contém tudo que é necessário para execução de um software. O pacote da imagem é um conjunto de arquivos empacotados, organizados em camadas, que representam o sistema de arquivos necessário para executar um aplicativo. Para que se possa executar uma aplicação, sob o contexto Docker, é necessário utilizar uma imagem para a construção da instância na qual essa aplicação será executada; a essa instância, denomina-se o termo 'container'. Então, por lógica, todo container docker possui uma imagem base que o gerou.

As imagens Docker podem ser escritas em um arquivo chamado 'Dockerfile'. A imagem pode ser construídas totalmente do zero ou utilizar outras imagens docker como base para construção de sua própria imagem. De modo geral as principais caracteristicas de uma imagem são:

- **Sistema de arquivos base**: i.e. podendo ser uma distribuição Linux, como Ubuntu, Alpine ou CentOS;
- **Código**: código fonte do aplicativo que será executado;
- **Configurações**: i.e variáveis de ambiente e/ou comandos iniciais para instruções de execução;
- **Dependências do aplicativo**: bibliotecas, pacotes e outras dependências que o software precisar;

Para facilitar o compartilhamento e a reutilização das imagens, elas podem ser armazenadas em repositórios. Em especial, o [DockerHub](https://hub.docker.com/) é o repositório oficial Docker, mantido pela Docker, no qual você pode gerenciar, subir e baixar suas próprias imagens, além de acessar outras imagens públicas. A plataforma é gratuita e você poderá criar uma conta sem nenhum custo extra.   

### O que é um Container Docker?

Um container docker é uma unidade leve e isolada de software que agrupa um aplicativo e todas as suas dependências necessárias (como bibliotecas, arquivos de configuração e binários) para que ele possa ser executado de forma consistente em qualquer ambiente. A partir de uma imagem docker, é possível construir o container da aplicação desejada.

As principais características de um container são:

- **Isolamento**: o sistema de arquivos, processos, redes, dependências e configurações do container são específicas para a aplicação. Essa infraestrutura é isolada do sistema operacional host e de outros containers;  
- **Portabilidade**: um container pode ser executado em qualquer máquina host, independentemente de seu sistema operacional subjacente. Isso é possível desde que a máquina host possua compatibilidade com o docker e a instalação do mesmo;
- **Eficiência**: o container, diferentemente das máquinas virtuais, não apresentam sistema operacional em sua estrutura interna. Sua operação se dá devido ao compartilhamento do mesmo kernel com o sistema operacional host, o que o torna mais leve e rápido;
- **Ciclo de vida**: um container pode ser criado, iniciado, parado, reiniciado e removido. Ele é considerado uma "instância em execução" da imagem docker;
- **Imutabilidade**:  qualquer alteração feita internamente ao container (ex. executar um comando de instalação de dependência específica) será perdida quando o container for reinicializado, a menos que seja salva em um volume ou redefinido sua imagem docker. Por esse motivo, containers são tidos como efêmeros e imutáveis;  

### O que é um Volume Docker?

Um volume docker é um mecanismo para armazenar e compartilhar dados entre contêineres e entre contêineres e o host. Em uma situação em que o container é removido ou reinicializado, ele perde todas as suas informações. Uma forma de contornar o problema da perda dessas informações é fazendo uso de volumes no docker, que preserva os dados a partir da persistência no ambiente host.

Na prática, o nosso objetivo é criar cópias dos dados que estão no container para a máquina host que contém o docker. Se houver, por parte do container, indisponibilidade de seu acesso ou sua inexistência, ainda será possível acessar esses dados, criando uma independência dos dados para com o estado do container que o manteria esses dados.

Em resumo, criar volumes é criar repositórios de dados dos containers, a partir do gerenciamento do docker.

As principais características de um volume docker são:

- **Persistência**: os dados em um volume não são excluídos quando o contêiner é removido;
- **Compartilhamento**: facilita a troca de arquivos entre contêineres;
- **Desempenho**: volumes são mais rápidos e eficientes do que bind mounts (montagens diretas de pastas do sistema de arquivos do host);
- **Portabilidade**: volumes são gerenciados pelo docker, tornando mais fácil transportar dados entre ambientes;

### O Repositório DockerHub

O DockerHub é uma plataforma em nuvem centralizada utilizada como repositório remoto para imagens docker (semelhente ao que o GitHub é para o armazenamento de códigos fontes). Popular e amplamente utilizado para buscar, armazenar e distribuir imagens docker desenvolvidas por indivíduos, equipes ou organizações.

> Para mais informações, vide site oficial [DockerHub](https://hub.docker.com/).

### Porque Instalar o Postgres Usando o Docker?

Para que possamos responder a essa pergunta, é necessário traçarmos um paralelo dos usos do Postgres instalado diretamente em um ambiente de servidor host e compararmos a um ambiente de container docker. Você entenderá que o uso do docker trás imensas facilidades para o gerenciamento de ações e o processo de instalação de um SGBD como o Postgres, bem como, o de desinstalação, fazem parte dessas facilidades. 

#### Quais eventuais problemas poderiam surgir devido ao uso do Postgres instalado diretamente em um ambiente host?

- **Risco de conflitos**: atualizar ou alternar entre versões do Postgres pode não ser uma tarefa fácil. O gerenciamento de versões de um mesmo SGBD em um mesmo ambiente de servidor host pode causar conflitos, desde configurações a instalação de dependências;

- **Desinstalação**: arquivos de configuração e dependências necessárias para execução do SGBD do Postgres são instalada no sistema de arquivos do ambiente host. Caso você não conheça os locais de instalação e configuração do Postgres no ambiente e, caso exista mais de uma versão do SGBD, a desinstalação exigirá trabalho e um conhecimento prévio desse ambiente;

- **Portabilidade**: toda configuração realizada em um ambiente host não será portável, caso você mude de máquina. Basicamente, todo o processo de configuração deverá ser refeito em um novo ambiente host;

Na contexto em que o SGBD do Postgres é instalado via docker, essas problemáticas deixam de existir, pois o SGBD é instânciado dentro de um container - que possui seu próprio sistema de arquivos - juntamente com suas dependências. Dessa forma, toda a configuração do SGBD fica isolada do ambiente host. A figura abaixo mostra a diferença arquitetural no funcionamento de uma máquina virtual em comparação com um container docker:

<div align="center">
    <img src="./img/vms_vs_containers.png" alt="docker and postgres" width="500" height="253.1">
</div>
<br>

#### O que torna o uso de uma instância Postgres em um container docker vantajoso?

- **Isolamento**: o Postgres rodando em um container é isolado do sistema operacional do host; sua configuração é definida no sistema de arquivos do container (independente do sistema de arquivos do ambiente host); não há conflitos de versões ou alterações indesejadas no sistema host, pois o SGBD fica definido no sistema de arquivos do container (separado do host); é possível rodar várias instâncias do Postgres com diferentes versões ou configurações em paralelo - cada uma definida em um container separadamente;

- **Configuração**: o ato de instalação do Postgres é simples e direto e, com um único comando, é possível configurar a instância e instalar as bibliotecas necessárias do SGBD sem qualquer intervenção manual; em paralelo, o ato de remoção do container também se apresenta de forma simples, permitindo excluir totalmente a instância Postgres e suas dependências sem deixar resíduos no sistema;      

- **Teste de Compatibilidade**: devido a capacidade de se rodar facilmente diferentes versões de instâncias Postgres, isso lhe permite testar a compatibilidade com uma aplicação em específico;

- **Portabilidade**: independente de qual ambiente o container esteja, o mesmo container (mesma estrutura) será executado, desde que o sistema contenha o docker instalado. Isso garante a consistência entre ambientes de desenvolvimento, teste e produção;

- **Reprodutibilidade**: com a garantia da consistência entre os ambientes que fazem uso docker, é possível reproduzir as mesmas condições de atividades para qualquer usuário do Postgres em um container; se funciona em um ambiente, funcionará em um outro ambiente distinto; isso elimina o ditado: "na minha máquina funciona!";

## Instalação do Postgres

Para realizarmos a instalação da instância Postgres em um container docker é necessário atender alguns pré-requisitos. Nessa seção será abordado os pré-requisitos e elencado o passo a passo para baixar a imagem docker, criar a instância, desligar e religar o container. Caso você apresente dificuldades em alguns conceito a respeito do docker, você pode estar acessar a seção sobre a [Visão Geral da Plataforma Docker](#visão-geral-da-plataforma-docker).

### Pré-requisitos

O único pré-requisito necessário para termos a instância Postgres em um container docker rodando em um ambiente é termos o docker instalado. Para verificar se você possui o docker instalado em sua máquina, use o comando:

```
    docker info
```

ou, mais resumidamente, 

```
    docker --version
```

> OBS:. comandos executáveis em Windows (via PowerShell), Linux e MacOS.

Caso não possua o docker instalado em sua máquina, verifique o sistema operacional do seu servidor e realize o procedimento de instalação. Para informações de instalação do docker, acesse a página de documentação [Install Docker Engine](https://docs.docker.com/engine/install/) ou os badges abaixo.

[![Windows](https://img.shields.io/static/v1?label=OS&message=Windows&color=blue&style=plastic)](https://docs.docker.com/desktop/setup/install/windows-install/)
[![Linux](https://img.shields.io/static/v1?label=OS&message=Linux&color=green&style=plastic)](https://docs.docker.com/desktop/setup/install/linux/)
[![macOS](https://img.shields.io/static/v1?label=OS&message=macOS&color=orange&style=plastic)](https://docs.docker.com/desktop/setup/install/mac-install/)

### Baixando a imagem oficial do Postgres

A [Imagem Oficial do Postgres](https://hub.docker.com/_/postgres) está hospedada no DockerHub. Ela é pública e acessível. Nesse caso, iremos baixar a versão mais recente (tag: latest). Para baixa-la em seu servidor, use o comando:

```
    docker pull postgres
```

ou, caso queira baixar alguma versão específica do Postgres, 

```
    docker pull postgres:[version]
```

em que ***version*** representa a versão Postgres desejada.

Após execução do comando, você pode estar verificando sua imagem Postgres no repositório de imagens gerenciado pelo docker:

```
    docker images
```

> OBS:. comandos executáveis em Windows (via PowerShell), Linux e MacOS.

### Criação da instância Postgres

Você pode criar sua instância Postgres de duas maneiras diferentes, a partir de uma configuração padrão ou personalizada. De modo mais simples, podemos criar a instância do Postgres, via configuração padrão, com o seguinte comando:

```
    docker run --name [pg_ctn_name] -e POSTGRES_PASSWORD=[pg_secret_password] -d postgres:[version]
```

> OBS:. comando executável em Windows (via PowerShell), Linux e MacOS.

em que ***pg_ctn_name*** representará o nome do container docker relativo a instância Postgres; ***pg_secret_password*** representará a senha do superusuário Postgres; e ***version*** representa a versão Postgres utilizada da imagem docker.

> OBS:. na ação de criação da instância Postgres são criados um superusuário e um banco de dados padrão denominado 'postgres'.

De modo mais personalizado, embora com maiores detalhes, você pode seguir a forma explicitada no comando:

```
    docker run --name [pg_ctn_name] \
        -p [host_port]:[ctn_port] \
        -e POSTGRES_PASSWORD=[pg_secret_password] \
        -e POSTGRES_USER=[pg_user_name] \
        -e POSTGRES_DB=[pg_db_name] \        
        -e POSTGRES_INITDB_ARGS=[pg_initdb_args] \
        -e POSTGRES_INITDB_WALDIR=[pg_initdb_waldir] \
        -e POSTGRES_HOST_AUTH_METHOD=[pg_host_auth_method] \
        -e PGDATA=[data_directory_path] \
        -v [host_data_directory_path]:[data_directory_path] \
        -d postgres:[version]
```

> OBS:. comando executável em Windows (via PowerShell), Linux e MacOS.

em que ***pg_ctn_name*** representará o nome do container docker relativo a instância Postgres; ***host_port*** e ***ctn_port*** representarão - respectivamente - a porta, no sistema host, usada para acessar o serviço e a porta, no container, em que o serviço está sendo executado; ***pg_secret_password*** representará a senha do superusuário Postgres; ***pg_user_name*** representará o nome do superusuário Postgres; ***pg_db_name*** representará o nome do banco de dados inicial do Postgres; ***pg_initdb_args*** representa a sequência de argumentos adicionais, a serem passados para o comando **initdb**, que serão utilizados durante a inicialização do banco de dados; ***pg_initdb_waldir*** representará o diretório local de armazenamento de logs de transações do Postgres; ***pg_host_auth_method*** representará o método de autenticação de acesso ao banco de dados (via host); ***data_directory_path*** representa o caminho onde os dados do Postgres serão armazenados; ***host_data_directory_path*** representará o caminho do diretório, no sistema host, que será montado no container - em referencia ao volume de dados da instância Postgres; e ***version*** representa a versão Postgres utilizada da imagem docker.

> OBS:. as variáveis de ambiente ​​especificadas só terão efeito se você iniciar o container com um diretório de dados vazio; qualquer banco de dados pré-existente permanecerá intocado na inicialização do contêiner.

Em caso de dúvidas, com relação a execução docker, consulte a seção de [Orientações Gerais](#orientações-gerais). Na seção [Variáveis de Ambiente](#variáveis-de-ambiente) você encontra descrições completas sobre os principais parâmetros de inicialização para o container Postgres. Para mais informações, acesse a [Documentação Postgres no DockerHub](https://hub.docker.com/_/postgres).

#### Orientações Gerais

A fim de complementar os conceitos de execução docker, a tabela abaixo trás um indicativo para as flags que podem ser utilizadas na criação da instância Postgres, são elas:

| **Flag**     | **Descrição**                                                                                                                                                                                                                                                                                                         | **Exemplo**                                 |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------- |
| **`--name`** | No contexto `docker run` serve para atribuir um nome personalizado ao container que está sendo criado, em vez do docker gerar um ID aleatoriamente.                                                                                                                                                                   | `--name postgres-dbms`                      |
| **`-p`**     | No contexto `docker run` serve para mapear uma porta do container para uma porta no host (máquina que contém o container). Ele faz o container ficar acessível de fora, permitindo que você se conecte a ele pela porta especificada no host.                                                                         | `-p 5432:5432`                              |
| **`-e`**     | No contexto `docker run` serve para definir as variáveis de ambiente dentro do container, configurando o comportamento do serviço que será executado.                                                                                                                                                                 | `-e PGDATA=/var/lib/postgresql/data/pgdata` |
| **`-v`**     | No contexto `docker run` serve para montar volumes, permitindo que um diretório do seu sistema host seja compartilhado com um diretório dentro do contêiner, a fim de garantir que os dados gerados/modificados pelo container sejam armazenados no sistema host (mesmo após o container ser reiniciado ou excluído). | `-v /custom/mount:/var/lib/postgresql/data` |
| **`-d`**     | No contexto `docker run` serve para executar o container em modo "desligado" (detached mode) ou segundo plano. Isso permite que o container continue rodando em background sem travar o terminal. Em determinados contextos isso pode ser bastante útil.                                                              | `-----`                                     |

Para fim de exemplo, você pode estar testando o comando `docker run` explicitado abaixo (OBS:. considere utilizar a versão de imagem docker mais recente - **latest**):

```
    docker run --name postgres-dbms \
        -p 5432:5432 \
        -e POSTGRES_PASSWORD=postgresAdmin \   
        -e PGDATA=/var/lib/postgresql/data/pgdata \
        -v /custom/mount:/var/lib/postgresql/data \
        -d postgres:latest
```

> OBS:. comando executável em Windows (via PowerShell), Linux e MacOS.

Após execução do comando, você pode estar verificando sua instância Postgres no repositório de containers gerenciado pelo docker:

```
    docker ps
```

> OBS:. comando executável em Windows (via PowerShell), Linux e MacOS.

Para mais detalhes, acesse a documentação em [Running Containers](https://docs.docker.com/engine/containers/run/).

#### Variáveis de Ambiente

| **Variável**                    | **Descrição**                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`POSTGRES_PASSWORD`**         | Esta variável de ambiente define a senha do superusuário para o PostgreSQL. O superusuário padrão é definido pela variável de ambiente **POSTGRES_USER**. Essa variável de ambiente é necessária para que você use a imagem do PostgreSQL. Ela não deve estar vazia ou indefinida.                                                                                                                                                  |
| **`POSTGRES_USER`**             | Esta variável de ambiente opcional é usada em conjunto com **POSTGRES_PASSWORD** para definir um usuário e sua senha, respectivamente. Ela criará o usuário especificado com poder de superusuário e um banco de dados com o mesmo nome. Caso não seja especificada, então o usuário padrão '**postgres**' será utilizado.                                                                                                          |
| **`POSTGRES_DB`**               | Esta variável de ambiente opcional pode ser usada para definir um nome diferente para o banco de dados padrão que é criado quando a imagem é iniciada pela primeira vez. Se não for especificada, o valor de **POSTGRES_USER** ('**postgres**', por padrão) será usado.                                                                                                                                                             |
| **`POSTGRES_INITDB_ARGS`**      | Esta variável de ambiente opcional pode ser usada para enviar argumentos para '**postgres initdb**'. O valor é uma sequência de argumentos separada por espaços, como seria de se esperar para '**postgres initdb**'. Isso é útil para adicionar funcionalidades como somas de verificação de páginas de dados: `-e POSTGRES_INITDB_ARGS="--data-checksums"`.                                                                       |
| **`POSTGRES_INITDB_WALDIR`**    | Esta variável de ambiente opcional pode ser usada para definir outro local para o log de transações do Postgres. Por padrão, o log de transações é armazenado em um subdiretório da pasta de dados principal do Postgres (**PGDATA**). Às vezes, pode ser desejável armazenar o log de transações em um diretório diferente, que pode ser apoiado por armazenamento com características diferentes de desempenho ou confiabilidade. |
| **`POSTGRES_HOST_AUTH_METHOD`** | Esta variável opcional pode ser usada para controlar as conexões externas ao banco (via host). Alguns valores possíveis para '**auth-method**' incluem: `trust`, `password`, `md5` e `scram-sha-256`. Se não for especificada, a autenticação de senha ⁠ é usada.                                                                                                                                                                   |
| **`PGDATA`**                    | Esta variável opcional pode ser usada para definir outro local - como um subdiretório - onde serão armazenados os arquivos do banco de dados. O padrão é `/var/lib/postgresql/data`.                                                                                                                                                                                                                                                |

Para mais detalhes, acesse a [Documentação Postgres no DockerHub](https://hub.docker.com/_/postgres).

### Ligar ou religar minha instância Postgres

## Instalação do pgAdmin

### Requisito de Uso

### Baixando a imagem oficial do pgAdmin

### Criação da instância pgAdmin e orientações gerais

### Ligar ou desligar minha instância pgAdmin

## Desinstalação 
