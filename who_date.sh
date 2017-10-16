# used by scripts to tell whether we have new Who's on First data (if new, probably don't want to load)
WHO_FILE=${WHO_FILE:="$DATA_DIR/whosonfirst/meta/wof-neighbourhood-latest.csv"}
WHO_FILETIME=`stat -c %Y $WHO_FILE`

UPDATE_WHO=false
if [ -z "$WHO_FILETIME" ];
then
  UPDATE_WHO=true
else
  WHO_AGE=${WHO_AGE:=86400}
  WHO_NOW=`date +%s`
  let WHO_DIFF=$WHO_NOW-$WHO_FILETIME;
  if [ $WHO_DIFF -gt $WHO_AGE ]; then
    UPDATE_WHO=true
  fi
fi
