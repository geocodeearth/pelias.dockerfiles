# pelias.dockerfiles

Minimal test load of transit data

1. pre-reqs: have docker and docker-compose installed on your system, plus plenty of disk and memory
1. export DATA_DIR=$PWD/data
1. mkdir $DATA_DIR
1. cd pelias.dockerfiles/test
1. git submodule update --init --recursive
1. emacs pelias.json # add your MapZen key where instructed in pelias.json (download WoF data from MapZen)
1. git update-index --assume-unchanged pelias.json
1. ./prep_data.sh
1. curl http://localhost:9200/pelias/_search?pretty=true&q=layer:intersections
