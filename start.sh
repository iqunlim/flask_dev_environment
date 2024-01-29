#!/bin/bash
#WIP

if [ $1 = "dev" ]; then
    docker compose -f docker-compose-dev.yml up --build
fi

if [ $1 = "prod" ]; then
    docker compose -f docker-compose-prod.yml up --build
fi

if [ $1 = "debug" ]; then
    docker compose -f docker-compose-dev.yml -f docker-compose-debug.yml up --build

if [ $1 = "test" ]; then
    docker compose -f docker-compose-dev.yml -f docker.compose-test.yml up --abort-on-container-exit --exit-code-from flask
    if [ $? = 0 ]; then
        docker compose -f docker-compose-dev.yml -f docker-compose-test.yml down
        echo Tests Succeeded
    else
        echo Tests did not succeed. Check your code and run "./start.sh test" again
    fi
fi

if [ $1 = "stop" ]; then
    docker compose -f docker-compose-dev.yml stop
    docker compose -f docker-compose-prod.yml stop
fi

if [ $1 = "down" ]; then
    docker compose -f docker-compose-prod.yml down
    docker compose -f docker-compose-test.yml down
    docker compose -f docker-compose-dev.yml down
fi