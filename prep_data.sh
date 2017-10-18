#!/bin/bash

# create the index in elasticsearch before importing data
docker-compose run --rm schema npm run create_index;

# download all the data to be used by imports
. ./who_date.sh
if $UPDATE_WHO ; then
  docker-compose run --rm whosonfirst npm run download &
fi
docker-compose run --rm openaddresses npm run download &
docker-compose run --rm openstreetmap npm run download &
docker-compose run --rm interpolation npm run download-tiger &
docker-compose run --rm transit npm run download &

wait;
