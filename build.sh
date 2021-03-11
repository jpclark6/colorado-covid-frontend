#!/bin/sh
echo "Getting updates from GitHub"
git pull origin master

echo "Building docker container"
docker build -t coloradocoviddata .

echo "Deploying"
docker stop dockerize-coloradocoviddata
docker rm dockerize-coloradocoviddata
docker run -p 8080:8080 -d --name dockerize-coloradocoviddata coloradocoviddata
echo "Success"