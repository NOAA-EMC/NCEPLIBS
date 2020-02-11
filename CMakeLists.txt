cmake_minimum_required(VERSION 3.15)
set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)

cmake_policy(SET CMP0048 NEW)

#Set cmake policies

# FILE GLOB_RECURSE calls should not follow symlinks by default
if(POLICY CMP0009)
  cmake_policy(SET CMP0009 NEW)
endif()
# Error on non-existent dependency in add_dependencies
if(POLICY CMP0046)
  cmake_policy(SET CMP0046 NEW)
endif()
# CMP0074: find_package uses PackageName_ROOT variables
if(POLICY CMP0074)
  cmake_policy(SET CMP0074 NEW)
endif()

project(NCEPLIBS)
enable_language(Fortran)

set(CMAKE_FIND_PACKAGE_PREFER_CONFIG true)

include(GNUInstallDirs)

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
  # Import the configuration from the NCEPLIBS-external cmake configuration file
  set(CMAKE_CONFIG_FILE_EXTERNAL "${EXTERNAL_LIBS_DIR}/${CMAKE_INSTALL_DATAROOTDIR}/nceplibs-external.cmake.config")
  if(EXISTS ${CMAKE_CONFIG_FILE_EXTERNAL})
    message(STATUS "importing configuration from ${CMAKE_CONFIG_FILE_EXTERNAL}")
    include(${CMAKE_CONFIG_FILE_EXTERNAL})
  else()
    message(FATAL_ERROR "CMake configuration for NCEPLIBS-external not found: ${CMAKE_CONFIG_FILE_EXTERNAL}")
  endif()
  # Set RPATH for macOS
  set(CMAKE_INSTALL_RPATH "${EXTERNAL_LIBS_DIR}/${CMAKE_INSTALL_LIBDIR}")
endif()

# Workaround: configure NetCDF here to avoid issues later on
find_package(NetCDF REQUIRED MODULE)
if(NOT NETCDF_INCLUDES OR NOT NETCDF_LIBRARIES)
  message(DEBUG "Applying workaround for cmake ignoring find_package(NetCDF REQUIRED)")
  set(NETCDF_INCLUDES ${NETCDF}/${CMAKE_INSTALL_INCLUDEDIR})
  set(NETCDF_LIBRARIES ${NETCDF}/${CMAKE_INSTALL_LIBDIR}/${CMAKE_SHARED_LIBRARY_PREFIX}netcdff${CMAKE_SHARED_LIBRARY_SUFFIX};${NETCDF}/${CMAKE_INSTALL_LIBDIR}/${CMAKE_SHARED_LIBRARY_PREFIX}netcdf${CMAKE_SHARED_LIBRARY_SUFFIX})
endif()
# End workaround

# Configure RPATH for macOS
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH true)

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

# Create shell scripts for bash and tcsh to set all necessary environment variables for NCEPLIBS and its dependencies
set(SCRIPT_NAME_BASH "${CMAKE_INSTALL_PREFIX}/bin/setenv_nceplibs.sh")
set(SCRIPT_NAME_TCSH "${CMAKE_INSTALL_PREFIX}/bin/setenv_nceplibs.csh")

message(STATUS "Creating bash shell script ${SCRIPT_NAME_BASH} to set environment variables for using NCEPLIBS")
file( WRITE  ${SCRIPT_NAME_BASH} "#/bin/bash\n")
file( APPEND ${SCRIPT_NAME_BASH} "\n")
file( APPEND ${SCRIPT_NAME_BASH} "echo 'Setting environment variables for NCEPLIBS and its dependencies'\n")
file( APPEND ${SCRIPT_NAME_BASH} "# Dependencies\n")
file( APPEND ${SCRIPT_NAME_BASH} "export PATH=\"${EXTERNAL_LIBS_DIR}/${CMAKE_INSTALL_BINDIR}:\$\{PATH\}\"\n")
file( APPEND ${SCRIPT_NAME_BASH} "export LD_LIBRARY_PATH=\"${EXTERNAL_LIBS_DIR}/${CMAKE_INSTALL_LIBDIR}:\$\{LD_LIBRARY_PATH\}\"\n")
file( APPEND ${SCRIPT_NAME_BASH} "export ESMFMKFILE=${ESMFMKFILE}\n")
file( APPEND ${SCRIPT_NAME_BASH} "export NETCDF=${NETCDF}\n")
file( APPEND ${SCRIPT_NAME_BASH} "# NCEPLIBS\n")
file( APPEND ${SCRIPT_NAME_BASH} "export NCEPLIBS_DIR=${CMAKE_INSTALL_PREFIX}\n")
file( APPEND ${SCRIPT_NAME_BASH} "export NEMSIO_INC=${CMAKE_INSTALL_PREFIX}/include\n")
file( APPEND ${SCRIPT_NAME_BASH} "export NEMSIO_LIB=${CMAKE_INSTALL_PREFIX}/lib/libnemsio_v2.2.3.a\n")
file( APPEND ${SCRIPT_NAME_BASH} "export BACIO_LIB4=${CMAKE_INSTALL_PREFIX}/lib/libbacio_v2.1.0_4.a\n")
file( APPEND ${SCRIPT_NAME_BASH} "export SP_LIBd=${CMAKE_INSTALL_PREFIX}/lib/libsp_v2.0.2_d.a\n")
file( APPEND ${SCRIPT_NAME_BASH} "export W3EMC_LIBd=${CMAKE_INSTALL_PREFIX}/lib/libw3emc_v2.2.0_d.a\n")
file( APPEND ${SCRIPT_NAME_BASH} "export W3NCO_LIBd=${CMAKE_INSTALL_PREFIX}/lib/libw3nco_v2.0.6_d.a\n")
file( APPEND ${SCRIPT_NAME_BASH} "#\n")

message(STATUS "Creating tcsh shell script ${SCRIPT_NAME_TCSH} to set environment variables for using NCEPLIBS")
file( WRITE  ${SCRIPT_NAME_TCSH} "#/bin/tcsh\n")
file( APPEND ${SCRIPT_NAME_TCSH} "\n")
file( APPEND ${SCRIPT_NAME_TCSH} "echo 'Setting environment variables for NCEPLIBS and its dependencies'\n")
file( APPEND ${SCRIPT_NAME_TCSH} "# Dependencies\n")
file( APPEND ${SCRIPT_NAME_TCSH} "setenv PATH \"${EXTERNAL_LIBS_DIR}/${CMAKE_INSTALL_BINDIR}:\$\{PATH\}\"\n")
file( APPEND ${SCRIPT_NAME_TCSH} "if ( $?LD_LIBRARY_PATH ) then\n")
file( APPEND ${SCRIPT_NAME_TCSH} "  setenv LD_LIBRARY_PATH \"${EXTERNAL_LIBS_DIR}/${CMAKE_INSTALL_LIBDIR}:\$\{LD_LIBRARY_PATH\}\"\n")
file( APPEND ${SCRIPT_NAME_TCSH} "else\n")
file( APPEND ${SCRIPT_NAME_TCSH} "  setenv LD_LIBRARY_PATH \"${EXTERNAL_LIBS_DIR}/${CMAKE_INSTALL_LIBDIR}\"\n")
file( APPEND ${SCRIPT_NAME_TCSH} "endif\n")
file( APPEND ${SCRIPT_NAME_TCSH} "setenv ESMFMKFILE ${ESMFMKFILE}\n")
file( APPEND ${SCRIPT_NAME_TCSH} "setenv NETCDF ${NETCDF}\n")
file( APPEND ${SCRIPT_NAME_TCSH} "# NCEPLIBS\n")
file( APPEND ${SCRIPT_NAME_TCSH} "setenv NCEPLIBS_DIR ${CMAKE_INSTALL_PREFIX}\n")
file( APPEND ${SCRIPT_NAME_TCSH} "setenv NEMSIO_INC ${CMAKE_INSTALL_PREFIX}/include\n")
file( APPEND ${SCRIPT_NAME_TCSH} "setenv NEMSIO_LIB ${CMAKE_INSTALL_PREFIX}/lib/libnemsio_v2.2.3.a\n")
file( APPEND ${SCRIPT_NAME_TCSH} "setenv BACIO_LIB4 ${CMAKE_INSTALL_PREFIX}/lib/libbacio_v2.1.0_4.a\n")
file( APPEND ${SCRIPT_NAME_TCSH} "setenv SP_LIBd ${CMAKE_INSTALL_PREFIX}/lib/libsp_v2.0.2_d.a\n")
file( APPEND ${SCRIPT_NAME_TCSH} "setenv W3EMC_LIBd ${CMAKE_INSTALL_PREFIX}/lib/libw3emc_v2.2.0_d.a\n")
file( APPEND ${SCRIPT_NAME_TCSH} "setenv W3NCO_LIBd ${CMAKE_INSTALL_PREFIX}/lib/libw3nco_v2.0.6_d.a\n")
file( APPEND ${SCRIPT_NAME_TCSH} "#\n")
