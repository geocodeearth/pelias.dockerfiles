containers=(placeholder pip api interpolation)
if [ $# -gt 0 ]
then
   containers+=(elasticsearch)
fi

for x in "${containers[@]}"
do
    echo docker stop pelias_$x
    docker stop pelias_$x
done

docker ps
