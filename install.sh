#!/bin/bash

source .env

docker run --name $CONTAINER_NAME \
    -e "ACCEPT_EULA=Y" \
    -e "MSSQL_SA_PASSWORD=$SA_PASSWORD" \
    -p 1433:1433 \
    -d mcr.microsoft.com/mssql/server:2022-latest

if [ $? -ne 0 ]; then
    echo 'Failed to start a container.'
    exit 1
fi

echo "Waiting for server to be ready in 60 s."
sleep 60
until docker exec $CONTAINER_NAME $SQLCMD_PATH -S localhost -C -U sa -P $SA_PASSWORD -Q "SELECT 1" &> /dev/null
do
    echo "Retrying in 10 s..."
    sleep 10
done
echo "The server is ready."

docker exec -i $CONTAINER_NAME $SQLCMD_PATH -S localhost -C -U sa -P $SA_PASSWORD -e < $SETUP_SCRIPT > /dev/null
if [ $? -eq 0 ]; then
    echo 'Successful setup!'
else
    echo 'Failed to setup.'
    exit 1
fi
