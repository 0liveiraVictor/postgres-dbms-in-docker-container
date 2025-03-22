#!/bin/bash

##########################################################################
#                            AUTHORSHIP                                  #
#------------------------------------------------------------------------#
# Author:           Victor Oliveira                                      #
# Email:            victor.soliveira@ufpe.br                             #
# Start Date:       21/03/2025                                           #
# Update Dates:     22/03/2025 | ----------                              #
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
    echo -e "\nDocker is not installed in the environment.\nNOTE: Please install Docker before proceeding with this procedure!\n\nAccess the Docker Engine documentation at: https://docs.docker.com/engine/install/"
    echo "==================================================================================================================="    
    exit 1
fi
echo

# reading user input data
read -p "Enter the name or container ID of the installed Postgres container (default: "$PG_CTN_NAME_DEFAULT"): " PG_CTN_NAME
read -p "Enter the name or container ID of the installed pgAdmin container (default: "$PGADMIN_CTN_NAME_DEFAULT"): " PGADMIN_CTN_NAME
read -p "Enter the name or image ID of the installed Postgres Docker image (default: "$PG_IMG_NAME_DEFAULT"): " PG_IMG_NAME
read -p "Enter the name or image ID of the installed pgAdmin Docker image (default: "$PGADMIN_IMG_NAME_DEFAULT"): " PGADMIN_IMG_NAME
read -p "Enter the name of the data volume associated with the installed Postgres instance (default: "$PG_VOL_NAME_DEFAULT"): " PG_VOL_NAME
read -p "Enter the name of the data volume associated with the installed pgAdmin instance (default: "$PGADMIN_VOL_NAME_DEFAULT"): " PGADMIN_VOL_NAME
read -p "Enter the name or network ID of the Docker network connecting the installed Postgres and pgAdmin instances (default: "$NETWORK_NAME_DEFAULT"): " NETWORK_NAME

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

echo -e "\n¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨ Container Removal Action ¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨\n"

# removing postgres container
if docker ps -a --format '{{.Names}}' | grep -q "^$PG_CTN_NAME$"; then
    if docker ps --format '{{.Names}}' | grep -q "^$PG_CTN_NAME$"; then
        docker stop "$PG_CTN_NAME" > /dev/null 2>&1
        echo "Container '$PG_CTN_NAME' STOPPED successfully."
    fi
    docker rm "$PG_CTN_NAME" > /dev/null 2>&1
    echo -e "Container '$PG_CTN_NAME' REMOVED successfully.\n"
else
    echo -e "Container '$PG_CTN_NAME' does not exist.\n"
fi
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

echo -e "\n¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨ Image Removal Action ¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨\n"

# removing postgres image
if docker images --format '{{.Repository}}:{{.Tag}}' | grep -q "^$PG_IMG_NAME$"; then
    docker rmi "$PG_IMG_NAME" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "Image '$PG_IMG_NAME' REMOVED successfully.\n"
    else
        echo -e "FAILED to remove image '$PG_IMG_NAME'. NOTE: It might still be in use or there is an issue with the image.\n"
    fi
else
    echo -e "Image '$PG_IMG_NAME' does not exist.\n"
fi
# removing pgadmin image
if docker images --format '{{.Repository}}:{{.Tag}}' | grep -q "^$PGADMIN_IMG_NAME$"; then
    docker rmi "$PGADMIN_IMG_NAME" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Image '$PGADMIN_IMG_NAME' REMOVED successfully."
    else
        echo "FAILED to remove image '$PGADMIN_IMG_NAME'. NOTE: It might still be in use or there is an issue with the image."
    fi
else
    echo "Image '$PGADMIN_IMG_NAME' does not exist."
fi

echo -e "\n¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨ Volume Removal Action ¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨\n"

# removing postgres volume
if docker volume ls --format '{{.Name}}' | grep -q "^$PG_VOL_NAME$"; then
    docker volume rm "$PG_VOL_NAME" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Volume '$PG_VOL_NAME' REMOVED successfully."
    else
        echo "FAILED to remove volume '$PG_VOL_NAME'. Note: It might still be in use or there is an issue with the volume."
    fi
else
    echo "Volume '$PG_VOL_NAME' does not exist."
fi
# removing pgadmin volume
if [ -n "$PGADMIN_VOL_NAME" ]; then
    if docker volume ls --format '{{.Name}}' | grep -q "^$PGADMIN_VOL_NAME$"; then
        docker volume rm "$PGADMIN_VOL_NAME" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo -e "\nVolume '$PGADMIN_VOL_NAME' REMOVED successfully."
        else
            echo -e "\nFAILED to remove volume '$PGADMIN_VOL_NAME'. Note: It might still be in use or there is an issue with the volume."
        fi
    else
        echo -e "\nVolume '$PGADMIN_VOL_NAME' does not exist."
    fi
fi

echo -e "\n¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨ Network Removal Action ¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨\n"

# removing network configuration
if docker network ls --format '{{.Name}}' | grep -q "^$NETWORK_NAME$"; then
    docker network rm "$NETWORK_NAME" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Network '$NETWORK_NAME' REMOVED successfully."
    else
        echo "FAILED to remove the network '$NETWORK_NAME'. Note: It might still be in use or there is an issue with the network."
    fi
else
    echo "Network '$NETWORK_NAME' does not exist."
fi

echo -e "\n¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨"
echo -e "\nNOTE: Uninstallation procedure COMPLETED!\n==================================================================================================================="
exit 0
