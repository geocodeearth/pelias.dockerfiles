if [ $1 == 'ALL' ]
then

    echo kill ALL CONTAINERS
    docker kill $(docker ps -q)

else

    echo kill ONLY DELETE THE PELIAS RUN-TIME CONTAINERS
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
fi

docker ps -a
