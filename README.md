# pelias.dockerfiles

Load both Pelias, and also Transit landmarks (GTFS, intersections from OSM, landmarks from .csv files, etc...)

1. pre-reqs: have docker and docker-compose installed on your system, plus plenty of disk and memory
1. git clone --recursive https://github.com/OpenTransitTools/pelias.dockerfiles.git
1. mkdir data
1. export DATA_DIR=$PWD/data
1. cd pelias.dockerfiles
1. emacs pelias.json # add your MapZen key where instructed in pelias.json (download WoF data from MapZen)
1. git update-index --assume-unchanged pelias.json
1. git submodule update --init --recursive
1. ./build.sh
1. curl http://localhost:4000/v1/search?text=888%20SE%20Lambert%20St # should see "match_type": "interpolated" somewhere in there (that's good)

