
set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)

if( NOT DEFINED ENV{CC} )
  find_path( crayComp "ftn" )
  find_path( wcossIntel "mpfort" )
  find_path( intelComp "ifort" )
  find_path( pgiComp "pgf90" )
  if( crayComp )
    message("Setting CrayLinuxEnvironment")
    set(CMAKE_SYSTEM_NAME "CrayLinuxEnvironment")
    set(CMAKE_C_COMPILER "${crayComp}/cc")
    set(CMAKE_CXX_COMPILER "${crayComp}/CC")
    set(CMAKE_Fortran_COMPILER "${crayComp}/ftn")
  endif()
  if( intelComp )
    set(ENV{CC} "icc")
    set(ENV{CXX} "icpc")
    set(ENV{FC} "ifort")
  endif()
  if( wcossIntel )
    message("Setting env for wcoss intel")
    set(ENV{CC} "mpcc")
    set(ENV{CXX} "mpCC")
    set(ENV{FC} "mpfort")
  endif()
  if( pgiComp )
    set(ENV{CC} "pgcc")
    set(ENV{CXX} "pgCC")
    set(ENV{FC} "pgf90")
  endif()
endif()

cmake_policy(SET CMP0048 NEW) 

project(NCEPLIBS)
cmake_minimum_required(VERSION 3.16)
enable_language(Fortran)

# set default install path if not provided
if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set (CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install" CACHE PATH "default install path" FORCE )
endif()

# Options for CMake
#Set up module and lib paths for build
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

#Include all the macros/functions
#include(GNUInstallDirs)
# include(${CMAKE_SOURCE_DIR}/cmake/Modules/setPlatformVariables.cmake)
# include(${CMAKE_SOURCE_DIR}/cmake/Modules/setIntelFlags.cmake)
# include(${CMAKE_SOURCE_DIR}/cmake/Modules/setGNUFlags.cmake)
# include(${CMAKE_SOURCE_DIR}/cmake/Modules/setPGIFlags.cmake)
#include(${CMAKE_SOURCE_DIR}/esmf/cmake/FindESMF.cmake)
#  include(${CMAKE_SOURCE_DIR}/cmake/Modules/setHOST.cmake)

#Set cmake policies
if(POLICY CMP0009)
  cmake_policy(SET CMP0009 NEW)
endif()
if(POLICY CMP0046)
  cmake_policy(SET CMP0046 NEW)
endif()
if(POLICY CMP0074)
  cmake_policy(SET CMP0074 NEW)
endif()


# make sure that the default is a RELEASE
if (NOT CMAKE_BUILD_TYPE)
  set (CMAKE_BUILD_TYPE RELEASE CACHE STRING
    "Choose the type of build, options are: PRODUCTION Debug Release."
    FORCE)
endif (NOT CMAKE_BUILD_TYPE)

STRING(COMPARE EQUAL ${CMAKE_BUILD_TYPE} "RelWithDebInfo" BUILD_RELEASE)
if(NOT BUILD_RELEASE)
  STRING(COMPARE EQUAL ${CMAKE_BUILD_TYPE} "RELEASE" BUILD_RELEASE)
endif()
STRING(COMPARE EQUAL ${CMAKE_BUILD_TYPE} "PRODUCTION" BUILD_PRODUCTION)
STRING(COMPARE EQUAL ${CMAKE_BUILD_TYPE} "PROFILE" BUILD_PROFILE)
if( BUILD_PRODUCTION )
  set( CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/exec )
endif()

if(DEFINED ENV{BASEDIR})
  set(Jasper_ROOT $ENV{BASEDIR})
  set(PNG_ROOT $ENV{BASEDIR})
  set(ZLIB_ROOT $ENV{BASEDIR})
  set(ENV{ESMFMKFILE} "$ENV{BASEDIR}/lib/esmf.mk")
  set(HDF5_ROOT $ENV{BASEDIR})
  set(NETCDF $ENV{BASEDIR})
endif()

find_package(MPI REQUIRED)

add_subdirectory(NCEPLIBS-bacio)
add_subdirectory(NCEPLIBS-ip)
add_subdirectory(NCEPLIBS-g2)
add_subdirectory(NCEPLIBS-sigio)
add_subdirectory(NCEPLIBS-sp)
add_subdirectory(NCEPLIBS-nemsio)
add_subdirectory(NCEPLIBS-w3nco)
add_subdirectory(NCEPLIBS-grib_util)
add_subdirectory(NCEPLIBS-bufr)
add_subdirectory(NCEPLIBS-crtm)
add_subdirectory(NCEPLIBS-g2tmpl)
add_subdirectory(NCEPLIBS-gfsio)
add_subdirectory(NCEPLIBS-landsfcutil)
add_subdirectory(NCEPLIBS-sfcio)
add_subdirectory(NCEPLIBS-w3emc)
add_subdirectory(NCEPLIBS-prod_util)
add_subdirectory(NCEPLIBS-nemsiogfs)
add_subdirectory(UFS_UTILS)


# include(ExternalProject)
# ExternalProject_Add(NCEPLIBS-post
#   PREFIX ${PROJECT_BINARY_DIR}/NCEPLIBS-post
#   CMAKE_ARGS
#   -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
#   -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
#   -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
#   -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
#   -DNETCDF_DIR=${NETCDF_DIR}
#   -DCMAKE_BUILD_TYPE=RELEASE
#   SOURCE_DIR ${PROJECT_SOURCE_DIR}/NCEPLIBS-post
#   DEPENDS NCEPLIBS-sigio
#   DEPENDS NCEPLIBS-w3nco
#   DEPENDS NCEPLIBS-g2
#   DEPENDS NCEPLIBS-g2tmpl
#   DEPENDS NCEPLIBS-bacio
#   DEPENDS NCEPLIBS-bufr
#   DEPENDS NCEPLIBS-ip
#   DEPENDS NCEPLIBS-sp
#   DEPENDS NCEPLIBS-sfcio
#   DEPENDS NCEPLIBS-nemsio
#   DEPENDS NCEPLIBS-w3emc
#   DEPENDS NCEPLIBS-gfsio
#   DEPENDS NCEPLIBS-crtm
#   DEPENDS netcdf-fortran
#   DEPENDS esmf
#   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
#   BUILD_COMMAND make -j 10
#   INSTALL_COMMAND make install
#   )




