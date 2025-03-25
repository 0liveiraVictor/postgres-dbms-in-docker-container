#!/bin/bash

##########################################################################
#                            AUTHORSHIP                                  #
#------------------------------------------------------------------------#
# Author:           Victor Oliveira                                      #
# Email:            victor.soliveira@ufpe.br                             #
# Start Date:       15/03/2025                                           #
# Update Dates:     25/03/2025 | ----------                              #
# Description:      Script for the complete installation of the          # 
#                   Postgres DBMS and the pgAdmin Graphical              #
#                   Interface Tool                                       #
##########################################################################



# NOTE:. DEFAULT VARIABLES CAN BE EDITED
# general variables
PG_CTN_NAME_DEFAULT="postgres-dbms"
PGADMIN_CTN_NAME_DEFAULT="pgadmin"
PG_IMG_NAME_DEFAULT="postgres:latest"
PGADMIN_IMG_NAME_DEFAULT="dpage/pgadmin4:latest"
PG_VOL_NAME_DEFAULT="pg_data_volume"
NETWORK_NAME_DEFAULT="postgres-dbms_pgadmin_bridge"
# postgres docker instance configurations
PG_HOST_PORT_DEFAULT="5432"
PG_CTN_PORT_DEFAULT="5432"
PG_USER_DEFAULT="postgresAdmin"
PG_USER_PASSWORD_DEFAULT="postgresAdmin"
PG_CTN_DATA_PATH_DEFAULT="/var/lib/postgresql/data"
PG_CTN_DATA_VOL_PATH_DEFAULT="/var/lib/postgresql/data"
# pgadmin docker instance configurations
PGADMIN_HOST_PORT_DEFAULT="80"
PGADMIN_CTN_PORT_DEFAULT="80"
PGADMIN_USER_EMAIL_DEFAULT="your_user_email@domain.com"
PGADMIN_USER_PASSWORD_DEFAULT="pgAdmin"



echo "==========================================================================================================="
echo "  P   o   s   t   g   r   e   s     a   n   d     p   g   A   d   m   i   n     I   n   s   t   a   l   l  " 
echo "==========================================================================================================="

# check if docker is installed
if ! command -v docker &> /dev/null
then
    echo -e "\nDocker is not installed in the environment.\nNOTE: Please install Docker before proceeding with this procedure!\n\nAccess the Docker Engine documentation at: https://docs.docker.com/engine/install/"
    echo "==================================================================================================================="    
    exit 1
fi
echo

# reading user input data
read -p "Enter the name for the Postgres container to be installed (default: "$PG_CTN_NAME_DEFAULT"): " PG_CTN_NAME
read -p "Enter the name for the superuser of the Postgres instance to be installed (default: "$PG_USER_DEFAULT"): " PG_USER
read -s -p "Enter the password for the superuser of the Postgres instance to be installed (default: "$PG_USER_PASSWORD_DEFAULT"): " PG_USER_PASSWORD
echo
read -p "Enter the name for the pgAdmin container to be installed (default: "$PGADMIN_CTN_NAME_DEFAULT"): " PGADMIN_CTN_NAME
read -p "Enter the default administrator user email for the pgAdmin instance to be installed (default: "$PGADMIN_USER_EMAIL_DEFAULT"): " PGADMIN_USER_EMAIL
read -s -p "Enter the default administrator user password for the pgAdmin instance to be installed (default: "$PGADMIN_USER_PASSWORD_DEFAULT"): " PGADMIN_USER_PASSWORD
echo
read -p "Enter the name of the Postgres Docker image to be installed (default: "$PG_IMG_NAME_DEFAULT"): " PG_IMG_NAME
read -p "Enter the name of the pgAdmin Docker image to be installed (default: "$PGADMIN_IMG_NAME_DEFAULT"): " PGADMIN_IMG_NAME
read -p "Enter the name of the data volume to be associated with the Postgres instance to be installed (default: "$PG_VOL_NAME_DEFAULT"): " PG_VOL_NAME
read -p "Enter the name of the Docker network for connecting the Postgres and pgAdmin instances to be installed (default: "$NETWORK_NAME_DEFAULT"): " NETWORK_NAME

# defining the variables with the names and/or ids of the containers, images, volumes and network
if [ -z "$PG_CTN_NAME" ]; then
    PG_CTN_NAME=$PG_CTN_NAME_DEFAULT
fi
if [ -z "$PGADMIN_CTN_NAME" ]; then
    PGADMIN_CTN_NAME=$PGADMIN_CTN_NAME_DEFAULT
fi
if [ -z "$PG_IMG_NAME" ]; then
    PG_IMG_NAME=$PG_IMG_NAME_DEFAULT
fi
if [ -z "$PGADMIN_IMG_NAME" ]; then
    PGADMIN_IMG_NAME=$PGADMIN_IMG_NAME_DEFAULT
fi
if [ -z "$PG_VOL_NAME" ]; then
    PG_VOL_NAME=$PG_VOL_NAME_DEFAULT
fi
if [ -z "$NETWORK_NAME" ]; then
    NETWORK_NAME=$NETWORK_NAME_DEFAULT
fi
if [ -z "$PG_USER" ]; then
    PG_USER=$PG_USER_DEFAULT
fi
if [ -z "$PG_USER_PASSWORD" ]; then
    PG_USER_PASSWORD=$PG_USER_PASSWORD_DEFAULT
fi
if [ -z "$PGADMIN_USER_EMAIL" ]; then
    PGADMIN_USER_EMAIL=$PGADMIN_USER_EMAIL_DEFAULT
fi
if [ -z "$PGADMIN_USER_PASSWORD" ]; then
    PGADMIN_USER_PASSWORD=$PGADMIN_USER_PASSWORD_DEFAULT
fi

echo -e "\n¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨ Pull Image Action ¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨\n"

# pulling postgres image
if docker images --format '{{.Repository}}:{{.Tag}}' | grep -q "^$PG_IMG_NAME$"; then
    echo -e "Image '$PG_IMG_NAME' already exists.\n"
else
    echo -e "> Pulling Docker image Postgres ...\n"
    docker pull "$PG_IMG_NAME"
    if [ $? -eq 0 ]; then
        echo -e "\n... Image '$PG_IMG_NAME' PULLED successfully.\n"
    else
        echo -e "\n... FAILED to pull the image '$PG_IMG_NAME'.\n"
    fi
fi
# pulling pgadmin image
if docker images --format '{{.Repository}}:{{.Tag}}' | grep -q "^$PGADMIN_IMG_NAME$"; then
    echo "Image '$PGADMIN_IMG_NAME' already exists."
else
    echo -e "> Pulling Docker image pgAdmin ...\n"
    docker pull "$PGADMIN_IMG_NAME"
    if [ $? -eq 0 ]; then
        echo -e "\n... Image '$PGADMIN_IMG_NAME' PULLED successfully."
    else
        echo -e "\n... FAILED to pull the image '$PGADMIN_IMG_NAME'."
    fi
fi

echo -e "\n¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨ Create Network Action ¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨\n"

# creating network configuration
if docker network ls --format '{{.Name}}' | grep -q "^$NETWORK_NAME$"; then
    echo "Network '$NETWORK_NAME' already exists."
else
    docker network create "$NETWORK_NAME" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Network '$NETWORK_NAME' CREATED successfully."
    else
        echo "FAILED to create the network '$NETWORK_NAME'."
    fi
fi

echo -e "\n¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨ Run Container Action ¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨\n"

# running postgres container
if docker ps -a --format '{{.Names}}' | grep -q "^$PG_CTN_NAME$"; then
    if docker ps --format '{{.Names}}' | grep -q "^$PG_CTN_NAME$"; then
        echo -e "Container '$PG_CTN_NAME' already exists and is running.\n"
    else
        docker start "$PG_CTN_NAME" > /dev/null 2>&1
        echo -e "Container '$PG_CTN_NAME' already exists and has been successfully RESTARTED.\n"
    fi
else
    docker run --name "$PG_CTN_NAME" \
        --network "$NETWORK_NAME" \
        -p "$PG_HOST_PORT_DEFAULT":"$PG_CTN_PORT_DEFAULT" \
        -e POSTGRES_PASSWORD="$PG_USER_PASSWORD" \
        -e POSTGRES_USER="$PG_USER" \
        -e PGDATA="$PG_CTN_DATA_PATH_DEFAULT" \
        -v "$PG_VOL_NAME":"$PG_CTN_DATA_VOL_PATH_DEFAULT" \
        -d "$PG_IMG_NAME" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "Container '$PG_CTN_NAME' CREATED and RUNNED successfully.\n"
    else
        echo -e "FAILED to create and run the container '$PG_CTN_NAME'.\n"
    fi
fi
# running pgadmin container
if docker ps -a --format '{{.Names}}' | grep -q "^$PGADMIN_CTN_NAME$"; then
    if docker ps --format '{{.Names}}' | grep -q "^$PGADMIN_CTN_NAME$"; then
        echo "Container '$PGADMIN_CTN_NAME' already exists and is running."
    else
        docker start "$PGADMIN_CTN_NAME" > /dev/null 2>&1
        echo "Container '$PGADMIN_CTN_NAME' already exists and has been successfully RESTARTED."
    fi
else
    docker run --name "$PGADMIN_CTN_NAME" \
        --network "$NETWORK_NAME" \
        -p "$PGADMIN_HOST_PORT_DEFAULT":"$PGADMIN_CTN_PORT_DEFAULT" \
        -e PGADMIN_DEFAULT_EMAIL="$PGADMIN_USER_EMAIL" \
        -e PGADMIN_DEFAULT_PASSWORD="$PGADMIN_USER_PASSWORD" \
        -d "$PGADMIN_IMG_NAME" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Container '$PGADMIN_CTN_NAME' CREATED and RUNNED successfully."
    else
        echo "FAILED to create and run the container '$PGADMIN_CTN_NAME'."
    fi
fi

echo -e "\n¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨"
echo -e "\nNOTE: Installation procedure COMPLETED!\n====================================================================================================================="
exit 0
