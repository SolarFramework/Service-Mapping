#!/bin/bash

export REMAKENROOT=$HOME/.remaken/packages/linux-gcc
export PKG_CONFIG_PATH=/home/linuxbrew/.linuxbrew/opt/openssl/lib/pkgconfig:/home/linuxbrew/.linuxbrew/lib/pkgconfig/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/linuxbrew/.linuxbrew/lib:.


## Set application gRPC server url
export XPCF_GRPC_SERVER_URL=0.0.0.0:50051
## Set application gRPC max receive message size
export XPCF_GRPC_MAX_RECV_MSG_SIZE=7000000
## Set application gRPC max send message size
export XPCF_GRPC_MAX_SEND_MSG_SIZE=20000000
## Set application log level
## Log level expected: DEBUG, CRITICAL, ERROR, INFO, TRACE, WARNING
export SOLAR_LOG_LEVEL=INFO


# include dependencies path to ld_library_path
ld_library_path="./"
if [ -f "$PWD/SolARService_$1_modules.xml" ]; then
	for modulePath in $(grep -o "\$XPCF_MODULE_ROOT.*lib" SolARService_$1_modules.xml)
	do
	   modulePath=${modulePath/"\$XPCF_MODULE_ROOT"/${XPCF_MODULE_ROOT}}
	   if ! [[ $ld_library_path =~ "$modulePath/x86_64/shared/release" ]]
	   then
		  ld_library_path=$ld_library_path:$modulePath/x86_64/shared/release
	   fi 
	done
fi

echo LD_LIBRARY_PATH $ld_library_path

LD_LIBRARY_PATH=$ld_library_path ./SolARService_$1 -m SolARService_$1_modules.xml -p SolARService_$1_properties.xml

