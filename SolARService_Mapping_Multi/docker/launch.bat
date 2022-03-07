ECHO off

REM Get Map Update Service URL from parameters
IF "%1"=="" (
    ECHO You need to give Map Update service URL as first parameter!
    GOTO end
) ELSE (
    ECHO Map Update Service URL = %1
)

REM Set Map Update Service URL
SET MAPUPDATE_SERVICE_URL=%1

REM Get Relocalization Service URL from parameters
IF "%2"=="" (
    ECHO You need to give Relocalization service URL as second parameter!
    GOTO end
) ELSE (
    ECHO Relocalization Service URL = %2
)

REM Set Relocalization Service URL
SET RELOCALIZATION_SERVICE_URL=%2

REM Set application log level
REM Log level expected: DEBUG, CRITICAL, ERROR, INFO, TRACE, WARNING
SET SOLAR_LOG_LEVEL=INFO

docker rm -f solarservicemappingmulti
docker run -d -p 50051:8080 -e SOLAR_LOG_LEVEL -e MAPUPDATE_SERVICE_URL -e RELOCALIZATION_SERVICE_URL -e "SERVICE_NAME=SolARServiceMappingMulti" --log-opt max-size=50m -e "SERVICE_TAGS=SolAR" --name solarservicemappingmulti artwin/solar/services/mapping-multi-service:latest

:end
