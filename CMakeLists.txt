cmake_minimum_required(VERSION 3.15)
set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)

cmake_policy(SET CMP0048 NEW)

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


project(NCEPLIBS)
cmake_minimum_required(VERSION 3.15)
enable_language(Fortran)

set(CMAKE_FIND_PACKAGE_PREFER_CONFIG true)

# set default install path if not prov ided
if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set (CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install" CACHE PATH "default install path" FORCE )
endif()

#Set up module and lib paths for build
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

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

if(DEFINED EXTERNAL_LIBS_DIR)
  set(Jasper_ROOT ${EXTERNAL_LIBS_DIR})
  set(PNG_ROOT ${EXTERNAL_LIBS_DIR})
  set(ZLIB_ROOT ${EXTERNAL_LIBS_DIR})
  if (NOT DEFINED ENV{ESMFMKFILE})
    set(ENV{ESMFMKFILE} "${EXTERNAL_LIBS_DIR}/lib/esmf.mk")
  endif()  
  set(HDF5_ROOT ${EXTERNAL_LIBS_DIR})
  set(NETCDF ${EXTERNAL_LIBS_DIR})
endif()

if(NOT DEFINED ENV{ESMFMKFILE})
  message("ESMFMKFILE not set, FindPackage won't be able to find ESMF")
endif()

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
add_subdirectory(NCEPLIBS-post)


