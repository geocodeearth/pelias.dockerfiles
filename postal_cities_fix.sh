#!/bin/bash

# ensure DATA_DIR is set
[ -z "$DATA_DIR" ] && { echo "Need to set DATA_DIR"; exit 1; }

# apply postal cities fixes
function addHierarchyValue(){
  docker run --rm -i 'pelias/placeholder' jq \
    --arg 'placetype' "${1}" \
    --arg 'id' "${2}" \
    '.properties["wof:hierarchy"][0][$placetype] = ($id | tonumber)'
}

function addPortlandLocalAdmin(){
  if [[ ! -f $1 ]]; then
    printf '%s does not exist!\n' "$1"
  else
    printf '[patch] %s\n' "$1"
    BASENAME=${1##*/}
    cat "${1}" | addHierarchyValue 'localadmin_id' 999999999 > "/tmp/${BASENAME}" && \
      mv "/tmp/${BASENAME}" "${1}"
  fi
}

# create a localadmin record for portland
WOF_DATA="${DATA_DIR}/whosonfirst/data";
WOF_META="${DATA_DIR}/whosonfirst/meta";

# filter records by placetype
# removing any file names from the stream whose body does not match the pattern
function hierarchyFilter {
  while IFS= read -r FILENAME; do
    grep --files-with-match "\"$1\":\s*$2" "${FILENAME}" || true;
  done
}

# find all files in the file system which list the target k->v as a parent
function findDescendants {
  find "${WOF_DATA}" -type f -name '*.geojson' | hierarchyFilter "${1}" "${2}"
}

# create geojson file
mkdir -p "${WOF_DATA}/999/999/999";
cp "${WOF_DATA}/101/715/829/101715829.geojson" "${WOF_DATA}/999/999/999/999999999.geojson";

# generate meta file for localadmin
head -n1 "${WOF_META}/wof-locality-latest.csv" > "${WOF_META}/wof-localadmin-latest.csv";
grep Portland "${WOF_META}/wof-locality-latest.csv" >> "${WOF_META}/wof-localadmin-latest.csv";

# OSX sed is broken, please install 'gsed' on OSX via brew
if type gsed >/dev/null
  then
    gsed -i 's/101715829/999999999/g' "${WOF_DATA}/999/999/999/999999999.geojson";
    gsed -i 's/locality/localadmin/g' "${WOF_DATA}/999/999/999/999999999.geojson";
    gsed -i 's/101715829/999999999/g' "${WOF_META}/wof-localadmin-latest.csv";
    gsed -i 's/101\/715\/829/999\/999\/999/g' "${WOF_META}/wof-localadmin-latest.csv";
    gsed -i 's/locality/localadmin/g' "${WOF_META}/wof-localadmin-latest.csv";
  else
    sed -i 's/101715829/999999999/g' "${WOF_DATA}/999/999/999/999999999.geojson";
    sed -i 's/locality/localadmin/g' "${WOF_DATA}/999/999/999/999999999.geojson";
    sed -i 's/101715829/999999999/g' "${WOF_META}/wof-localadmin-latest.csv";
    sed -i 's/101\/715\/829/999\/999\/999/g' "${WOF_META}/wof-localadmin-latest.csv";
    sed -i 's/locality/localadmin/g' "${WOF_META}/wof-localadmin-latest.csv";
fi

# patch geojson files to update hierarchy
export -f addPortlandLocalAdmin
export -f addHierarchyValue

# Washington County
findDescendants 'county_id' 102082215 | xargs -n 1 -P 32 bash -c 'addPortlandLocalAdmin "$@"' _;

# Clackamas County
findDescendants 'county_id' 102082213 | xargs -n 1 -P 32 bash -c 'addPortlandLocalAdmin "$@"' _;

# Multnomah County
findDescendants 'county_id' 102081631 | xargs -n 1 -P 32 bash -c 'addPortlandLocalAdmin "$@"' _;

# Yamhill County
findDescendants 'county_id' 102081613 | xargs -n 1 -P 32 bash -c 'addPortlandLocalAdmin "$@"' _;

# Marion County
findDescendants 'county_id' 102082219 | xargs -n 1 -P 32 bash -c 'addPortlandLocalAdmin "$@"' _;

# Polk County
findDescendants 'county_id' 102081601 | xargs -n 1 -P 32 bash -c 'addPortlandLocalAdmin "$@"' _;

# Clark County (WA)
findDescendants 'county_id' 102084251 | xargs -n 1 -P 32 bash -c 'addPortlandLocalAdmin "$@"' _;
