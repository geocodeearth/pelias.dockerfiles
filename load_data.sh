#!/bin/bash

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

sleep 5

# create the index in elasticsearch before importing data
docker-compose run -T --rm schema npm run create_index &
wait;

# polylines data prep requires openstreetmap data, so wait until that's done to start this
# but then wait to run the polylines importer process until this is finished
docker-compose run -T --rm polylines bash ./docker_extract.sh &
wait;

docker-compose run -T --rm placeholder npm run extract &
docker-compose run -T --rm placeholder npm run build &
wait;


docker-compose run -T --rm interpolation bash ./docker_build.sh &
wait;

docker-compose run -T --rm openaddresses npm start &
wait;

docker-compose run -T --rm openstreetmap npm start &
wait;

docker-compose run -T --rm polylines npm start &
wait;

docker-compose run -T --rm transit npm start &
wait;

