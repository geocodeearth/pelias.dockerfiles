# pelias.dockerfiles test directory

Currently, this dir has a manually run script is for testing just the transit loader in a Docker environment.
There is a dependency on WoF data, such that we also do the point in admin districts.

@TODO: possibly add automated unit / integration testing here...

1. Assumes you have $DATA_DIR set, and your ../pelias.json file has a proper MapZen api key (see ../README.md for more). 
1. cd pelias.dockerfiles/test
1. git submodule update --init --recursive
1. emacs pelias.json # add your MapZen key where instructed in pelias.json (download WoF data from MapZen)
1. git update-index --assume-unchanged pelias.json
1. ./prep_data.sh
1. curl http://localhost:9200/pelias/_search?pretty=true&q=layer:intersections
1. Calling ES: http://localhost:9200/pelias/_search?pretty=true&q=* should then return transit stops data, etc...   
