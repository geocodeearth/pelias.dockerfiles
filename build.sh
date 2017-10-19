#!/bin/bash
if [ -z "$DATA_DIR" ]
then
    export DATA_DIR=~/data
    mkdir $DATA_DIR
fi


# bring containers down
# note: the -v flag deletes ALL persistent data volumes
docker-compose down || true;

# rebuild the images
#docker-compose build;
docker-compose pull;

time sh ./download_data.sh;
wait;
time sh ./load_data.sh;
wait;
time sh ./run_services.sh;
