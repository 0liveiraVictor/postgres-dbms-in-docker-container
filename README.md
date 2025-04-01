# Installation Tutorial for the DBMS Postgres in a Docker Container

## Complete guide on the installation process of the Postgres relational database management system and the pgAdmin interface in an environment using the Docker containerization tool.

<br>

[![README](https://img.shields.io/static/v1?label=readme&message=pt-BR&color=blue&style=plastic)](./README_pt-BR.md)

<div align="center">
    <img src="./img/docker_and_postgres.png" alt="docker and postgres" width="621" height="501.98">
</div>
<br>

Postgres is an object-relational Database Management System (DBMS) with origins in the POSTGRES project, created at the University of California, Berkeley, in the 1980s. With decades of continuous development, Postgres has established itself as the most advanced open-source database available today. Considered among the four most widely used DBMSs in the market, data from [DB-ENGINES](https://db-engines.com/en/ranking) demonstrate how popular Postgres has become.

In this tutorial, you will learn how to install a Postgres instance in an environment using Docker technology while understanding its related concepts, such as images, containers, volumes, networks, and a bit about DockerHub. Additionally, the installation of Postgres' graphical management tool, pgAdmin, will also be covered. If you feel comfortable, you can skip some topics and go directly to the sections on [Postgres Installation](#postgres-installation) and [pgAdmin Installation](#pgadmin-installation).

## Summary

- [Overview of the Docker Platform](#overview-of-the-docker-platform)
    - [What is a Docker Image?](#what-is-a-docker-image)
    - [What is a Docker Container?](#what-is-a-docker-container)
    - [What is a Docker Volume?](#what-is-a-docker-volume)
    - [What is a Docker Network?](#what-is-a-docker-network)
    - [The DockerHub Repository](#the-dockerhub-repository)
- [Why Install Postgres Using Docker?](#why-install-postgres-using-docker)
    - [What potential issues could arise from installing Postgres directly on a host environment?](#what-potential-issues-could-arise-from-installing-postgres-directly-on-a-host-environment)
    - [What makes using a Postgres instance in a Docker container advantageous?](#what-makes-using-a-postgres-instance-in-a-docker-container-advantageous)
- [Postgres Installation](#postgres-installation)
    - [Prerequisites (Postgres)](#prerequisites-postgres)
    - [Downloading the Official Postgres Image](#downloading-the-official-postgres-image)
    - [Creating the Postgres Instance](#creating-the-postgres-instance)
        - [General Guidelines](#general-guidelines)
        - [Environment Variables](#environment-variables)
- [pgAdmin Installation](#pgadmin-installation)
    - [Prerequisites (pgAdmin)](#prerequisites-pgadmin)
    - [Downloading the Official pgAdmin Image](#downloading-the-official-pgadmin-image)
    - [Creating the pgAdmin Instance](#creating-the-pgadmin-instance)
- [Connecting Postgres and pgAdmin on the Docker Network](#connecting-postgres-and-pgadmin-on-the-docker-network)
    - [Creating the Docker Network](#creating-the-docker-network)
    - [Adding the Docker Network to the Containers' Network Configuration](#adding-the-docker-network-to-the-containers-network-configuration)
- [Accessing Postgres via pgAdmin](#accessing-postgres-via-pgadmin)
- [Installation and Uninstallation Scripts for Postgres and pgAdmin Instances](#installation-and-uninstallation-scripts-for-postgres-and-pgadmin-instances)
    - [Installation Action](#installation-action)
    - [Uninstallation Action](#uninstallation-action)
- [Maintaining Docker Containers, Volume, Network, and Images](#maintaining-docker-containers-volume-network-and-images)
    - [Identifying Containers, Volumes, Networks, and Images](#identifying-containers-volumes-networks-and-images)
        - [Identifying Containers](#identifying-containers)
        - [Identifying Volumes](#identifying-volumes)
        - [Identifying Networks](#identifying-networks)
        - [Identifying Images](#identifying-images)
    - [Maintaining Installed Instances](#maintaining-installed-instances)
        - [Stopping the Container](#stopping-the-container)
        - [Restarting the Container](#restarting-the-container)
        - [Deleting the Container](#deleting-the-container)
        - [Deleting the Volume](#deleting-the-volume)
        - [Deleting the Network](#deleting-the-network)
        - [Deleting the Image](#deleting-the-image)
- [Author](#author)
- [License](#license)

## Overview of the Docker Platform

[Docker](https://www.docker.com/) is a software platform designed to simplify the creation, testing, distribution, and deployment of applications efficiently. It organizes software into a structure called a container, which is a standardized unit that includes all the necessary components for execution, such as libraries, system tools, code, and runtime environment. With Docker, it is possible to quickly and easily distribute and deploy software in any environment, scaling applications as needed while ensuring their proper functionality.

### What is a Docker Image?

A Docker image is a lightweight package that contains everything needed to run a software application. The image package is a set of packaged files, organized into layers, that represent the filesystem required to execute an application.

To run an application within the Docker context, an image must be used to build the instance in which the application will run; this instance is called a 'container.' Therefore, by definition, every Docker container has a base image that created it.

Docker images can be defined in a file called `Dockerfile`. An image can be built entirely from scratch or use other Docker images as a base for constructing its own. In general, the main characteristics of an image are:

- **Base Filesystem**: e.g., it can be a Linux distribution such as Ubuntu, Alpine, or CentOS;
- **Application Dependencies**: libraries, packages, and other dependencies required by the software;
- **Code**: the source code of the application to be executed;
- **Configurations**: i.e., environment variables and/or startup commands for execution instructions.

To facilitate sharing and reusing images, they can be stored in remote repositories. In particular, [DockerHub](https://hub.docker.com/) is Docker's official repository, maintained by Docker, where you can manage, upload, and download your own images, as well as access other public images. The platform is free, and you can create an account at no additional cost.   

### What is a Docker Container?

A Docker container is a lightweight, isolated software unit that bundles an application along with all its necessary dependencies (such as libraries, configuration files, and binaries) to ensure consistent execution across any environment. From a Docker image, a container for the desired application can be built.

The main characteristics of a container are:

- **Isolation**: The container’s filesystem, processes, networks, dependencies, and configurations are specific to the application. This infrastructure is isolated from the host operating system and other containers;  
- **Portability**: A container can run on any host, regardless of its underlying operating system, as long as the host is compatible with the Docker platform;  
- **Efficiency**: Unlike virtual machines, containers do not include an operating system within their internal structure. They operate by sharing the same kernel as the host operating system, making them lightweight and fast;  
- **Lifecycle**: A container can be created, started, stopped, restarted, and removed. It is considered a "running instance" of a Docker image;  
- **Immutability**: Any internal modifications made to the container (e.g., installing a specific dependency) will be lost when the container is restarted — unless they are saved in a data volume or redefined in its Docker image. For this reason, containers are considered ephemeral and immutable.  

### What is a Docker Volume?

A Docker volume is a mechanism for storing and sharing data between containers and between containers and the host. When a container is removed or restarted, it loses all its data. One way to avoid this data loss is by using Docker volumes, which ensure data persistence on the host environment.

In practice, the goal is to create copies of the data stored within the container and save them on the host running Docker. If the container becomes unavailable or is removed, the data will still be accessible, making the data independent of the container’s state.

In summary, creating volumes means establishing local data repositories for containers, managed by Docker. The main characteristics of a Docker volume are:

- **Persistence**: Data in a volume is not deleted when the container is removed;
- **Sharing**: Enables file exchange between containers;
- **Performance**: Volumes managed by Docker’s volume repository are faster and more efficient than [bind mounts](https://docs.docker.com/engine/storage/bind-mounts/) (directly mounting host filesystem folders);
- **Portability**: Since volumes are managed by Docker, they make it easier to transfer data between environments.

### What is a Docker Network?

A Docker network is a component that enables communication between containers and between containers and the host. In Docker, since each container is an independent and isolated instance, they cannot communicate unless they are configured within a common network.

Docker networks are managed by Docker itself, providing flexibility and security for applications while ensuring safe, efficient, and controlled communication.

The main characteristics of a Docker network are:

- **Isolation**: Docker networks allow containers to be isolated within their network configurations, ensuring that only containers belonging to the same network can communicate with each other;  
- **Simplified Connectivity**: Containers connected to the same network can communicate directly using the container name;  
- **Support**: Docker networks offer multiple network driver options to accommodate different requirements.

### The DockerHub Repository

DockerHub is a centralized cloud platform used as a remote repository for Docker images (similar to how GitHub is used for source code storage). It is popular and widely used for searching, storing, and distributing Docker images developed by individuals, teams, or organizations.

> For more information, visit [DockerHub](https://hub.docker.com/).

> In general, for Docker-related documentation, you can access [Docker Docs](https://docs.docker.com/build-cloud/).

## Why Install Postgres Using Docker?

To answer this question, it is important to compare two scenarios: installing Postgres directly on the host environment and installing it in a Docker container. As a preview, you will understand that, for example, using Docker offers several conveniences such as easy installation and removal of the DBMS itself.

Before answering this question, let's first analyze the issue of direct installation on the host environment and its implications:

#### What potential issues could arise from installing Postgres directly on a host environment?

- **Risk of Conflicts**: Updating or switching between Postgres versions may not be an easy task. Managing different versions of the same DBMS within the same environment can lead to conflicts, both in configurations and in installing dependencies;

- **Uninstallation**: Configuration files and dependencies for running the Postgres DBMS are installed in the host environment's filesystem. If you're not familiar with the locations of Postgres installation and configuration on the host, and if multiple versions of the DBMS exist, uninstallation will require effort and prior knowledge of the environment;

- **Portability**: Any configuration made in a host environment will not be portable if you change machines. Essentially, the entire configuration process will need to be redone in a new host environment;

In the context where the Postgres DBMS is installed via Docker, these issues no longer exist, as the DBMS is instantiated within a container – which has its own filesystem – along with its dependencies. This way, all DBMS configurations are isolated from the host environment. The figure below illustrates the architectural difference in how a virtual machine works compared to a Docker container:

<div align="center">
    <img src="./img/vms_vs_containers.png" alt="vms vs containers" width="715" height="361.94">
</div>
<br>

#### What makes using a Postgres instance in a Docker container advantageous?

- **Isolation**: Postgres running in a container is isolated from the host operating system; its configuration is defined in the container's filesystem (independent of the host environment's filesystem); there are no version conflicts or unwanted changes to the host system because the DBMS is defined in the container's filesystem (separate from the host); it is possible to run multiple Postgres instances with different versions or configurations in parallel – each defined in a separate container;

- **Configuration**: The installation of Postgres is simple and straightforward, and with a single command, you can configure the instance and install the necessary DBMS libraries without any manual intervention; conversely, the removal of the container is also straightforward, allowing you to completely remove the Postgres instance and its dependencies without leaving any residue on the system;

- **Compatibility Testing**: Due to the ability to easily run different versions of Postgres instances, this allows you to test compatibility with a specific application;

- **Portability**: Regardless of the environment in which the container resides, the same container (same structure) will run, as long as the system has Docker installed and uses a Docker image of the same version. This ensures consistency across development, testing, and production environments;

- **Reproducibility**: With the assurance of consistency between environments that use Docker, you can reproduce the same activity conditions for any Postgres user in a container; if it works in one host environment, it will work in another distinct environment; this eliminates the saying: "it works on my machine!".

## Postgres Installation

To install the Postgres instance as a Docker container, certain prerequisites must be met. This section will cover the necessary prerequisites and outline the step-by-step process to download the Docker image and create the actual Postgres instance (container). If you have difficulties with some Docker concepts, I suggest accessing the section [Overview of the Docker Platform](#overview-of-the-docker-platform).

> **NOTE: The Docker commands listed throughout this Postgres Installation section work the same way on Linux, Windows and macOS, provided that Docker Desktop is installed on Windows and macOS. On Linux, Docker runs natively, while on Windows, it is recommended to enable WSL 2 for better compatibility. Once the environment is set up, the commands can be used in the terminal (Linux/macOS) or PowerShell (Windows) without any differences.**

### Prerequisites (Postgres)

The only prerequisite for installing a Postgres instance as a Docker container in an environment is having Docker itself installed. To check if you have Docker installed on your machine, use the command:

```
docker info
```

or, more concisely,

```
docker --version
```

If Docker is not installed on your machine, check your server's operating system and follow the installation procedure. For Docker installation information, visit the [Install Docker Engine](https://docs.docker.com/engine/install/) documentation page or browse the indicative badges below:

[![Windows](https://img.shields.io/static/v1?label=OS&message=Windows&color=blue&style=plastic)](https://docs.docker.com/desktop/setup/install/windows-install/)
[![Linux](https://img.shields.io/static/v1?label=OS&message=Linux&color=green&style=plastic)](https://docs.docker.com/desktop/setup/install/linux/)
[![macOS](https://img.shields.io/static/v1?label=OS&message=macOS&color=orange&style=plastic)](https://docs.docker.com/desktop/setup/install/mac-install/)

### Downloading the Official Postgres Image

The [Official Postgres Image](https://hub.docker.com/_/postgres) is hosted on DockerHub. It is public and accessible. In this case, we will download the latest version (tag: `latest`). To download it on your server, use the command:

```
docker pull postgres
```

or, if you want to download a specific version of Postgres, use:

```
docker pull postgres:[version]
```

where `version` represents the desired Postgres version.

> Specific Postgres versions can be found at [Postgres Tags](https://hub.docker.com/_/postgres/tags).

After executing the command, you can check your Docker Postgres image in the image repository managed by Docker using:

```
docker images
```

### Creating the Postgres Instance

You can create your Postgres instance in two different ways: using a default (simplified) configuration or a customized one. In a simpler way, we can create the Postgres instance with the following command:

```
docker run --name [pg_ctn_name] -e POSTGRES_PASSWORD=[pg_secret_password] -d postgres:[version]
```

Alternatively, for a more customized approach with additional details, you can follow the command below:

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

where `pg_ctn_name` represents the name of the Docker container for the Postgres instance; `host_port` and `ctn_port` represent – respectively – the port on the host system used to access the service and the port within the container where the service will be running; `pg_secret_password` represents the Postgres superuser password; `pg_user_name` represents the Postgres superuser name; `pg_db_name` represents the name of the initial Postgres database; `pg_initdb_args` refers to the sequence of additional arguments passed to the **initdb** command used during database initialization; `pg_initdb_waldir` represents the local directory for storing Postgres transaction logs; `pg_host_auth_method` represents the authentication method for database access (via host); `data_directory_path` represents the path where Postgres data will be stored; `host_data_directory_path` represents the directory path on the host system that will be mounted in the container – referencing the data volume of the Postgres instance; and `version` represents the Postgres version used by the Docker image.

> **Note: When creating a Postgres instance, a superuser and a default database named 'postgres' are automatically created unless different values are specified via environment variables.**

> **Note: The specified environment variables will only take effect if you start the container with an empty data directory; any pre-existing database will remain untouched upon container startup.**

As an example, you can test the `docker run` command shown below:

> **Note: Consider using the latest Docker image version (tag: `latest`):**

```
docker run --name postgres-dbms \
    -p 5432:5432 \
    -e POSTGRES_PASSWORD=postgresAdmin \
    -e POSTGRES_USER=postgresAdmin \
    -e PGDATA=/var/lib/postgresql/data \
    -v pg_data_volume:/var/lib/postgresql/data \
    -d postgres:latest
```

After executing the command, you can check your Postgres instance in the container repository managed by Docker:

```
docker ps
```

For more details on running containers, you can visit the [Running Containers](https://docs.docker.com/engine/containers/run/) documentation.

If you have any questions regarding Docker execution flags, refer to the [General Guidelines](#general-guidelines) section below. In the [Environment Variables](#environment-variables) section, you will find complete descriptions of the main initialization parameters for a Postgres container. For additional information, visit the [Postgres Documentation on DockerHub](https://hub.docker.com/_/postgres).

#### General Guidelines

To complement Docker execution concepts, the table below provides information about the flags that can be used when creating a Postgres instance:

| **Flag** | **Description**                                                                                                                                                                                                                                                                              | **Example**                                 |
| -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------- |
| `--name` | In the context of `docker run`, it assigns a custom name to the container being created instead of letting Docker generate a random one.                                                                                                                                                     | `--name postgres-dbms`                      |
| `-p`     | In the context of `docker run`, it maps a container port to a port on the host (the machine running the container). This makes the container accessible externally, allowing connections through the specified host port.                                                                    | `-p 5432:5432`                              |
| `-e`     | In the context of `docker run`, it sets environment variables inside the container, configuring the behavior of the service being executed.                                                                                                                                                  | `-e PGDATA=/var/lib/postgresql/data`        |
| `-v`     | In the context of `docker run`, it mounts volumes, allowing a directory from the host system to be shared with a directory inside the container. This ensures that data generated/modified by the container is stored on the host system (even after the container is restarted or deleted). | `-v /custom/mount:/var/lib/postgresql/data` |
| `-d`     | In the context of `docker run`, it runs the container in "detached mode" (background execution). This allows the container to keep running in the background without locking the terminal, which can be useful in certain scenarios.                                                         | `-----`                                     |

#### Environment Variables

The table below provides complete information about the environment variables used by the `docker run` command when initializing a Postgres instance:

| **Variable**                | **Description**                                                                                                                                                                                                                                                                                                                                                                                    |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `POSTGRES_PASSWORD`         | This environment variable sets the superuser password for Postgres. The default superuser is defined by the `POSTGRES_USER` environment variable. This variable is required to use the Postgres image. It must not be empty or undefined.                                                                                                                                                          |
| `POSTGRES_USER`             | This optional environment variable is used in conjunction with `POSTGRES_PASSWORD` to define a user and its password, respectively. It creates the specified user with superuser privileges and a database with the same name. If not specified, the default user '**postgres**' will be used.                                                                                                     |
| `POSTGRES_DB`               | This optional environment variable can be used to set a different name for the default database created when the image is first started. If not specified, the value of `POSTGRES_USER` ('**postgres**') will be used.                                                                                                                                                                             |
| `POSTGRES_INITDB_ARGS`      | This optional environment variable can be used to pass arguments to '**postgres initdb**'. The value should be a space-separated list of arguments, as expected for '**postgres initdb**'. This is useful for adding features like data page checksums, e.g., `-e POSTGRES_INITDB_ARGS="--data-checksums"`.                                                                                        |
| `POSTGRES_INITDB_WALDIR`    | This optional environment variable can be used to specify a different location for the Postgres transaction log. By default, the transaction log is stored in a subdirectory of the main Postgres data folder (`PGDATA`). In some cases, it may be desirable to store the transaction log in a different directory, possibly on storage with different performance or reliability characteristics. |
| `POSTGRES_HOST_AUTH_METHOD` | This optional variable controls external connections to the database (via host). Some possible values for '**auth-method**' include: `trust`, `password`, `md5`, and `scram-sha-256`. If not specified, password authentication is used by default.                                                                                                                                                |
| `PGDATA`                    | This optional variable can be used to specify a different location — such as a subdirectory — where the database files will be stored. The default is: `/var/lib/postgresql/data`.                                                                                                                                                                                                                 |
