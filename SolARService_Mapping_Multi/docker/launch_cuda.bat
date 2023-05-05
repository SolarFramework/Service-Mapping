ECHO off

REM Get service port from parameters
IF "%1"=="" (
    ECHO You need to give Mapping service port as first parameter!
    GOTO end
) ELSE (
    ECHO Mapping service port = %1
)

REM Set Mapping service external URL
SET SERVER_EXTERNAL_URL=172.17.0.1:%1

REM Get Service Manager URL from parameters
IF "%2"=="" (
    ECHO You need to give Service Manager URL as second parameter!
    GOTO end
) ELSE (
    ECHO Service Manager Service URL = %2
)

REM Set Service Manager URL
SET SERVICE_MANAGER_URL=%2

REM Set application log level
REM Log level expected: DEBUG, CRITICAL, ERROR, INFO, TRACE, WARNING
SET SOLAR_LOG_LEVEL=INFO

docker rm -f solarservicemappingmulticuda
docker run --gpus all -d -p %1:8080 -e SOLAR_LOG_LEVEL -e SERVER_EXTERNAL_URL -e SERVICE_MANAGER_URL -e "SERVICE_NAME=SolARServiceMappingMultiCuda" --log-opt max-size=50m -e "SERVICE_TAGS=SolAR" --name solarservicemappingmulticuda artwin/solar/services/mapping-multi-cuda-service:latest

:end
