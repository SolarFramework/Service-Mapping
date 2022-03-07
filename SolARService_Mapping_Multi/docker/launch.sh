#!/bin/sh

# Get Map Update Service URL from parameters
if [ "$1" ]
then
    echo "Map Update Service URL = $1"
else
    echo "You need to give Map Update Service URL as first parameter!"
    exit 1
fi

# Set MapUpdate Service URL
export MAPUPDATE_SERVICE_URL=$1

# Get Relocalization Service URL from parameters
if [ "$2" ]
then
    echo "Relocalization Service URL = $2"
else
    echo "You need to give Relocalization Service URL as second parameter!"
    exit 1
fi

# Set Relocalization Service URL
export RELOCALIZATION_SERVICE_URL=$2

# Set application log level
# Log level expected: DEBUG, CRITICAL, ERROR, INFO, TRACE, WARNING
export SOLAR_LOG_LEVEL=INFO

docker rm -f solarservicemappingmulti
docker run -d -p 50051:8080 -e SOLAR_LOG_LEVEL -e MAPUPDATE_SERVICE_URL -e RELOCALIZATION_SERVICE_URL -e "SERVICE_NAME=SolARServiceMappingMulti" --log-opt max-size=50m -e "SERVICE_TAGS=SolAR" --name solarservicemappingmulti artwin/solar/services/mapping-multi-service:latest
