# pelias.dockerfiles test directory

This is for testing just the transit loader in a Docker environment.
There is a dependency on WoF data, such that we also do the point in admin districts.

1. Assumes you have $DATA_DIR set, and your ../pelias.json file has a proper MapZen api key (see ../README.md for more). 
1. ./prep_data.sh
1. you should see a bunch of stuff install (including Elasticsearch), including the OTT pelias.transit.loader.  
1. the transit loader loader will then download GTFS data, processing the points thru WoF, and finally inserting things 
into Elasticsearch.
1. Calling ES: http://localhost:9200/pelias/_search?pretty=true&q=* should then return transit stops data, etc...   
