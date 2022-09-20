FROM nvidia/cuda:11.4.0-base-ubuntu18.04
MAINTAINER Christophe Cutullic christophe.cutullic@b-com.com

## Configure Ubuntu environment
RUN apt-get update -y
RUN apt-get install -y libgtk2.0-dev
RUN apt-get install -y libva-dev
RUN apt-get install -y libvdpau-dev

## Copy SolARServiceMappingMultiNoDrop app files
RUN mkdir SolARServiceMappingMultiNoDrop

## Data files (fbow vocabulary)
RUN mkdir SolARServiceMappingMultiNoDrop/data
RUN mkdir SolARServiceMappingMultiNoDrop/data/fbow_voc
ADD data/fbow_voc/popsift_uint8.fbow /SolARServiceMappingMultiNoDrop/data/fbow_voc/

## Libraries and modules
RUN mkdir SolARServiceMappingMultiNoDrop/modules
ADD modules/* /SolARServiceMappingMultiNoDrop/modules/
ADD modules_common/* /SolARServiceMappingMultiNoDrop/modules/
ADD modules_cuda/* /SolARServiceMappingMultiNoDrop/modules/

## Project files
ADD SolARService_Mapping_Multi_NoDrop /SolARServiceMappingMultiNoDrop/
RUN chmod +x /SolARServiceMappingMultiNoDrop/SolARService_Mapping_Multi_NoDrop
RUN mkdir .xpcf
ADD *.xml /.xpcf/
ADD docker/start_server_cuda.sh .
RUN chmod +x start_server_cuda.sh

## Set application gRPC server url
ENV XPCF_GRPC_SERVER_URL=0.0.0.0:8080
## Set application gRPC max receive message size
ENV XPCF_GRPC_MAX_RECV_MSG_SIZE=7000000
## Set application gRPC max send message size
ENV XPCF_GRPC_MAX_SEND_MSG_SIZE=-1

## Set url to Map Update Service
ENV MAPUPDATE_SERVICE_URL=map-update-service
## Set url to Relocalization Service
ENV RELOCALIZATION_SERVICE_URL=relocalization-service

## Set application log level
## Log level expected: DEBUG, CRITICAL, ERROR, INFO, TRACE, WARNING
ENV SOLAR_LOG_LEVEL=INFO

## Run Server
CMD [ "./start_server_cuda.sh"  ]
