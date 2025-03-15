#!/bin/bash

##########################################################################
#                            AUTHORSHIP                                  #
#------------------------------------------------------------------------#
# Author:           Victor Oliveira                                      #
# Email:            victor.soliveira@ufpe.br                             #
# Start Date:       15/03/2025                                           #
# Update Dates:                                                          #
# Description:      Script for Complete Installation of the Postgres     #
#                   DBMS and the pgAdmin Graphical Interface Tool in     #
#                   Docker Containers.                                   #
##########################################################################

# variables can be edited
PG_CTN_NAME_DEFAULT="postgres-dbms"
PGADMIN_CTN_NAME_DEFAULT="pgadmin"
NETWORK_NAME_DEFAULT="postgres-dbms_pgadmin_bridge"


echo "==========================================================================================================="
echo "  P   o   s   t   g   r   e   s     a   n   d     p   g   A   d   m   i   n     I   n   s   t   a   l   l  " 
echo "==========================================================================================================="

# check if docker is installed
if ! command -v docker &> /dev/null
then
    echo
    echo "Docker is not installed in the environment."
    echo "NOTE: Please install Docker before proceeding with this procedure!"
    echo
    echo "==========================================================================================================="    
    exit 1
fi

echo
# read -p "Enter a name for the Postgres container (default: postgres-dbms): " PG_CTN_NAME
# read -p "Enter a name for the pgAdmin container (default: pgadmin): " PGADMIN_CTN_NAME
read -p "Enter the Docker network name (default: postgres-dbms_pgadmin_bridge): " NETWORK_NAME



if [ -z "$NETWORK_NAME" ]; then
    NETWORK_NAME=$NETWORK_NAME_DEFAULT
fi

if docker network ls --filter name=$NETWORK_NAME -q; then
    docker network rm $NETWORK_NAME
fi

echo "creating docker network..."
docker network create $NETWORK_NAME

# # Fazer pull das imagens latest do PostgreSQL e pgAdmin
# echo "Fazendo pull da imagem do PostgreSQL..."
# docker pull postgres:latest

# echo "Fazendo pull da imagem do pgAdmin..."
# docker pull dpage/pgadmin4:latest

# # Executar o container do PostgreSQL
# echo "Executando container do PostgreSQL..."
# docker run -d --name postgres --network minha_rede_docker -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres:latest

# # Executar o container do pgAdmin
# echo "Executando container do pgAdmin..."
# docker run -d --name pgadmin --network minha_rede_docker -e PGADMIN_DEFAULT_EMAIL=admin@admin.com -e PGADMIN_DEFAULT_PASSWORD=admin -p 80:80 dpage/pgadmin4:latest

# echo "Containers do PostgreSQL e pgAdmin em execução."


