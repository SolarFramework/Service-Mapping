## global defintions : target lib name, version
TARGET = SolARService_Mapping_Multi_NoDrop
VERSION=0.11.0

## remove Qt dependencies
CONFIG += c++1z
CONFIG += console
CONFIG += verbose
CONFIG -= qt

DEFINES += MYVERSION=\"\\\"$${VERSION}\\\"\"
DEFINES += WITHREMOTING

include(findremakenrules.pri)

CONFIG(debug,debug|release) {
    TARGETDEPLOYDIR = $${PWD}/../bin/Debug
    DEFINES += _DEBUG=1
    DEFINES += DEBUG=1
}

CONFIG(release,debug|release) {
    TARGETDEPLOYDIR = $${PWD}/../bin/Release
    DEFINES += _NDEBUG=1
    DEFINES += NDEBUG=1
}

win32:CONFIG -= static
win32:CONFIG += shared
QMAKE_TARGET.arch = x86_64 #must be defined prior to include
DEPENDENCIESCONFIG = shared install_recurse
PROJECTCONFIG = QTVS

#NOTE : CONFIG as staticlib or sharedlib,  DEPENDENCIESCONFIG as staticlib or sharedlib, QMAKE_TARGET.arch and PROJECTDEPLOYDIR MUST BE DEFINED BEFORE templatelibconfig.pri inclusion
include ($$shell_quote($$shell_path($${QMAKE_REMAKEN_RULES_ROOT}/templateappconfig.pri)))  # Shell_quote & shell_path required for visual on windows

HEADERS += \
    GrpcServerManager.h


SOURCES += \
    GrpcServerManager.cpp\
    SolARService_Mapping_Multi_NoDrop.cpp

unix {
    LIBS += -ldl
    QMAKE_CXXFLAGS += -DBOOST_LOG_DYN_LINK
}

linux {
    LIBS += -ldl
}


macx {
    DEFINES += _MACOS_TARGET_
    QMAKE_MAC_SDK= macosx
    QMAKE_CFLAGS += -mmacosx-version-min=10.7 #-x objective-c++
    QMAKE_CXXFLAGS += -mmacosx-version-min=10.7  -std=c++17 -fPIC#-x objective-c++
    QMAKE_LFLAGS += -mmacosx-version-min=10.7 -v -lstdc++
    LIBS += -lstdc++ -lc -lpthread
    LIBS += -L/usr/local/lib
}

win32 {
    QMAKE_LFLAGS += /MACHINE:X64
    DEFINES += WIN64 UNICODE _UNICODE
    QMAKE_COMPILER_DEFINES += _WIN64

    # Windows Kit (msvc2013 64)
    LIBS += -L$$(WINDOWSSDKDIR)lib/winv6.3/um/x64 -lshell32 -lgdi32 -lComdlg32
    INCLUDEPATH += $$(WINDOWSSDKDIR)lib/winv6.3/um/x64
}

linux {
    run_install.path = $${TARGETDEPLOYDIR}
    run_install.files = $${PWD}/start_mapping_multi_nodrop_service.sh
    CONFIG(release,debug|release) {
        run_install.extra = cp $$files($${PWD}/start_mapping_multi_nodrop_service_release.sh) $${PWD}/start_mapping_multi_nodrop_service.sh
    }
    CONFIG(debug,debug|release) {
        run_install.extra = cp $$files($${PWD}/start_mapping_multi_nodrop_service_debug.sh) $${PWD}/start_mapping_multi_nodrop_service.sh
    }
    INSTALLS += run_install
}

DISTFILES += \
    SolARService_Mapping_Multi_NoDrop_modules.xml \
    SolARService_Mapping_Multi_NoDrop_properties.xml \
    docker/build.sh \
    packagedependencies.txt \
    docker/build.sh \
    docker/launch.bat \
    docker/launch.sh \
    docker/mapping-service-manifest.yaml \
    docker/SolARServiceMappingMultiNoDrop.dockerfile \
    docker/start_server.sh \
    start_mapping_multi_nodrop_service_debug.sh \
    start_mapping_multi_nodrop_service_release.sh

xml_files.path = $${TARGETDEPLOYDIR}
xml_files.files =  SolARService_Mapping_Multi_NoDrop_modules.xml \
                   SolARService_Mapping_Multi_NoDrop_properties.xml

INSTALLS += xml_files

