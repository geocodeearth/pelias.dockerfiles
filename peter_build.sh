#!/bin/bash

docker-compose kill;
docker-compose down;
rm -rf "${DATA_DIR}/elasticsearch/*";

# start elasticsearch if it's not already running
if ! [ $(curl --output /dev/null --silent --head --fail http://localhost:9200) ]; then
    docker-compose up -d elasticsearch;

    # wait for elasticsearch to start up
    echo 'waiting for elasticsearch service to come up';
    until $(curl --output /dev/null --silent --head --fail http://localhost:9200); do
      printf '.'
      sleep 2
    done
fi

# create the index in elasticsearch before importing data
docker-compose run -T --rm schema node scripts/drop_index.js --force-yes;
docker-compose run -T --rm schema npm run create_index;

# assuming elasticsearch is already running

# run ES importers
docker-compose run -T --rm openaddresses npm start;
docker-compose run -T --rm openstreetmap npm start;
docker-compose run -T --rm polylines npm start;
docker-compose run -T --rm transit npm start;

# start the containers
# note: the -d flag will background the logs
docker-compose up -d libpostal;
docker-compose up -d placeholder;
docker-compose up -d pip;
docker-compose up -d interpolation;
docker-compose up -d api;
