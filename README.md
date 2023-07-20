# DEPRECATED - This repo is no longer maintained

----

# Service-Mapping
[![License](https://img.shields.io/github/license/SolARFramework/SolARModuleTools?style=flat-square&label=License)](https://www.apache.org/licenses/LICENSE-2.0)

These services integrate mapping pipelines to make them deployable on cloud architecture.

The services for mapping are open-source, designed by [b<>com](https://b-com.com/en), under [Apache v2 licence](https://www.apache.org/licenses/LICENSE-2.0).

## How to run (Linux only)

### Install required data

Before running the services, you need to download data such as Hololens captures, maps and the vocabulary of the bag of word used for image retrieval.
To install the required data, just launch the following script:

	./installData.sh

This script will install the following data into the `./data` folder:
- The bag of words downloaded from our [GitHub releases](https://github.com/SolarFramework/binaries/releases/download/fbow%2F0.0.1%2Fwin/fbow_voc.zip) and unzipped in the `./data` folder.
- Hololens captures (image and poses) downloaded from our Artifactory ([Loop_Desktop_A](https://repository.solarframework.org/generic/captures/hololens/bcomLab/loopDesktopA.zip) and [Loop_Desktop_B](https://repository.solarframework.org/generic/captures/hololens/bcomLab/loopDesktopB.zip)) and copied into the `./data/data_hololens` folder.

<strong>Loop_Desktop_A</strong> is a video sequence captured with a Hololens 1 around a desktop starting and finishing with the fiducial Marker A with a loop trajectory. A fiducial marker B is captured during the trajectory.

<strong>Loop_Dekstop_B</strong> is a video sequence captured with a Hololens 1 within an open-space starting and finishing with the fiducial Marker B with a loop trajectory. A part of the trajectory is common to the `Loop_Desktop_A` trajectory to test map overlap detection and map fusion.


### Install required modules

Some samples require several SolAR modules such as OpenGL, OpenCV, FBOW and G20. If they are not yet installed on your machine, please run the following command from the test folder:

<pre><code>remaken install packagedependencies.txt</code></pre>

and for debug mode:

<pre><code>remaken install packagedependencies.txt -c debug</code></pre>

For more information about how to install remaken on your machine, visit the [install page](https://solarframework.github.io/install/) on the SolAR website.

## Run the services (Linux only)

### Mapping Multi service

This service is based on the Mapping Multi pipeline.

in the "./bin/Release" or "./bin/Debug" folder:

	./start_mapping_multi_service.sh

## Build Docker images (Linux only)

To make these services deployable on a cloud architecture, you need first to integrate them in a Docker image.

For this, you need to install the Docker environment on your computer: https://www.docker.com/

Then, all the necessary files are provided in the "docker" subfolder of each project:
- *build.sh* : to build the Docker image
- *launch.sh* to launch the Docker container (to test it on your computer)
- ".dockerfile" used by the build script to construct the image
- "start_server.sh" used by the Docker container to start the service

To use the "build" and "launch" script files, you must first bundle your service by creating a folder with the following structure:
- service bundle folder
	-- the service executable file (built previously with QT creator or Visual Studio)
	-- the service configuration files for modules (xxx_modules.xml) and for properties (xxx_properties.xml)
	-- *data* folder: containing all the data needed by the service (see "Install required data")
	-- *modules* folder: containing all the modules needed by the service (you can use *remaken bundleXpcf* to copy all needed modules here)
    -- *docker* folder: containing all the files of the "docker" subfolder of the project	

## Deploy the service on a cloud architecture

To help you to deploy SolAR services, a *kubernetes* manifest file is provided as an example for each project, in the "docker" subfolder (YAML format).

## Run the test applications

Three test applications are provided with the Mapping services:
- SolARServiceTest_Mapping_Multi_Producer: read some Hololens captured images on disk and send them (with poses) to the Mapping service to process mapping and tracking
- SolARServiceTest_Mapping_Multi_Viewer: request the Mapping service for the current point cloud (and tracking) to display it on a graphical window
- SolARServiceTest_Mapping_Multi_Relocalization: same behavior than the SolARServiceTest_Mapping_Multi_Producer, but with relocalization tries every "n" images (based on *SolAR Relocalization service*)
  => for this test application, you need first to start the Relocalization service
  
To run these applications, you can use the "run.sh" scripts provided with the projects:

in the "./bin/Release" or "./bin/Debug" folder:

    ./run.sh ./test_application_exe_name -f configuration_file.xml

exemple:

    ./run.sh ./SolARServiceTest_Mapping_Multi_Producer -f SolARServiceTest_Mapping_Multi_Producer_conf.xml
	
Important: *Before running a test application, you must set the services URL in the xml configuration file*
           (and the services must be running of course)

        <!-- gRPC proxy configuration-->
        <configure component="110a089c-0bb1-488e-b24b-c1b96bc9df3b">
            <property name="channelUrl" access="rw" type="string" value="0.0.0.0:50051"/>
