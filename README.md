# pelias.dockerfiles

Load both Pelias, and also Transit landmarks (GTFS, intersections from OSM, landmarks from .csv files, etc...)

1. pre-reqs: have docker and docker-compose installed on your system, plus plenty of disk and memory
1. export DATA_DIR=$PWD/data
1. mkdir $DATA_DIR
1. git clone --recursive https://github.com/OpenTransitTools/pelias.dockerfiles.git
1. cd pelias.dockerfiles
1. emacs pelias.json # add your MapZen key where instructed in pelias.json (download WoF data from MapZen)
1. git update-index --assume-unchanged pelias.json
1. ./build.sh

Test:
1. curl http://localhost:4000/v1/search?text=888%20SE%20Lambert%20St # should see "match_type": "interpolated" somewhere in there (that's good)
1. curl http://localhost:4000/v1/search?text=stop%202 # should see "match_type": a bunch of records that are stop locations
1. curl http://localhost:9200/pelias/_search?pretty=true&q=layer:intersections
1. Call ES directly: http://localhost:9200/pelias/_search?pretty=true&q=layer:stops
1. More ES: http://localhost:9200/pelias/_search?pretty=true&q=*

Update:
1. cd pelias.dockerfiles
1. git submodule update --init --recursive
1. git pull
1. ./nuke_containers.sh # use with caution, will drop most / all of your non-Pelias Docker env
1. ./build.sh

Notes: 
1. [pelias.transit.loader](https://hub.docker.com/r/opentransittools/pelias.transit.loader/builds/) docker image on Docker Hub
1. [pelias.transit.loader](https://github.com/OpenTransitTools/pelias.transit.loader) code on GitHub
1. TriMet's Staging Server Instance: https://ws-st.trimet.org/pelias/v1/search?api_key=YourTriMetApiKey&text=stops%202
