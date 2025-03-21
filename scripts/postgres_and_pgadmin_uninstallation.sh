#!/bin/bash

##########################################################################
#                            AUTHORSHIP                                  #
#------------------------------------------------------------------------#
# Author:           Victor Oliveira                                      #
# Email:            victor.soliveira@ufpe.br                             #
# Start Date:       21/03/2025                                           #
# Update Dates:                                                          #
# Description:      Script for the complete uninstallation of the        # 
#                   Postgres DBMS and the pgAdmin Graphical              #
#                   Interface Tool                                       #
##########################################################################


# default variables | NOTE:. VARIABLES CAN BE EDITED
PG_CTN_NAME_DEFAULT="postgres-dbms"
PGADMIN_CTN_NAME_DEFAULT="pgadmin"
PG_IMG_NAME_DEFAULT="postgres:latest"
PGADMIN_IMG_NAME_DEFAULT="dpage/pgadmin4:latest"
PG_VOL_NAME_DEFAULT="pg_data_volume"
PGADMIN_VOL_NAME_DEFAULT=""
NETWORK_NAME_DEFAULT="postgres-dbms_pgadmin_bridge"


echo "==================================================================================================================="
echo "  P   o   s   t   g   r   e   s     a   n   d     p   g   A   d   m   i   n     U   n   i   n   s   t   a   l   l  " 
echo "==================================================================================================================="

# check if docker is installed
if ! command -v docker &> /dev/null
then
    echo
    echo "Docker is not installed in the environment."
    echo "NOTE: Please install Docker before proceeding with this procedure!"
    echo
    echo "==================================================================================================================="    
    exit 1
fi
echo

# reading user input data
read -p "Enter the name or container ID of the installed Postgres container (default: postgres-dbms): " PG_CTN_NAME
read -p "Enter the name or container ID of the installed pgAdmin container (default: pgadmin): " PGADMIN_CTN_NAME
read -p "Enter the name or image ID of the installed Postgres Docker image (default: postgres:latest): " PG_IMG_NAME
read -p "Enter the name or image ID of the installed pgAdmin Docker image (default: dpage/pgadmin4:latest): " PGADMIN_IMG_NAME
read -p "Enter the name of the data volume associated with the installed Postgres instance (default: pg_data_volume): " PG_VOL_NAME
read -p "Enter the name of the data volume associated with the installed pgAdmin instance (default: ---): " PGADMIN_VOL_NAME
read -p "Enter the name of the Docker network connecting the installed Postgres and pgAdmin instances (default: postgres-dbms_pgadmin_bridge): " NETWORK_NAME
echo

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

if [ -z "$PGADMIN_VOL_NAME" ]; then
    PGADMIN_VOL_NAME=$PGADMIN_VOL_NAME_DEFAULT
fi

if [ -z "$NETWORK_NAME" ]; then
    NETWORK_NAME=$NETWORK_NAME_DEFAULT
fi

echo "¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨ Container Removal Action ¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨"
# removing postgres container
if docker ps -a --format '{{.Names}}' | grep -q "^$PG_CTN_NAME$"; then
    if docker ps --format '{{.Names}}' | grep -q "^$PG_CTN_NAME$"; then
        docker stop "$PG_CTN_NAME" > /dev/null 2>&1
        echo "Container '$PG_CTN_NAME' STOPPED successfully."
    fi
    docker rm "$PG_CTN_NAME" > /dev/null 2>&1
    echo "Container '$PG_CTN_NAME' REMOVED successfully."
else
    echo "Container '$PG_CTN_NAME' does not exist."
fi
echo

# removing pgadmin container
if docker ps -a --format '{{.Names}}' | grep -q "^$PGADMIN_CTN_NAME$"; then
    if docker ps --format '{{.Names}}' | grep -q "^$PGADMIN_CTN_NAME$"; then
        docker stop "$PGADMIN_CTN_NAME" > /dev/null 2>&1
        echo "Container '$PGADMIN_CTN_NAME' STOPPED successfully."
    fi
    docker rm "$PGADMIN_CTN_NAME" > /dev/null 2>&1
    echo "Container '$PGADMIN_CTN_NAME' REMOVED successfully."
else
    echo "Container '$PGADMIN_CTN_NAME' does not exist."
fi
echo

echo "¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨ Image Removal Action ¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨"
# removing postgres image
if docker images --format '{{.Repository}}' | grep -q "^$PG_IMG_NAME$"; then
    docker rmi "$PG_IMG_NAME" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Image '$PG_IMG_NAME' REMOVED successfully."
    else
        echo "FAILED to remove image '$PG_IMG_NAME'. NOTE: It might still be in use or there is an issue with the image."
    fi
else
    echo docker rm $PG_IMG_NAME
    echo "Image '$PG_IMG_NAME' does not exist."
fi
echo

