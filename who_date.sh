# used by scripts to tell whether we have new Who's on First data (if new, probably don't want to load)
WHO_FILE=${WHO_FILE:="$DATA_DIR/whosonfirst/meta/wof-neighbourhood-latest.csv"}
WHO_AGE=${WHO_AGE:=86400}
WHO_FILETIME=`stat -c %Y $WHO_FILE`
WHO_NOW=`date +%s` 
let WHO_DIFF=$WHO_NOW-$WHO_FILETIME;

