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

# By default turn off OpenMP support
option(OPENMP "use OpenMP threading" OFF)
# Indicate to cmake what the default link type is
option(STATIC_IS_DEFAULT "turn on for systems that use static linking by default" OFF)

# When building on macOS using ifort add the -c flag to ranlib so that common symbols are visible
# in the .a. Otherwise uninitialized module variables will report as missing symbols
if(APPLE)
  if(CMAKE_Fortran_COMPILER_ID STREQUAL "Intel")
    set(CMAKE_Fortran_ARCHIVE_FINISH "<CMAKE_RANLIB> -c <TARGET>")
  endif()
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
  # Set RPATH for shared linking
  if(NOT STATIC_IS_DEFAULT)
    set(CMAKE_INSTALL_RPATH "${EXTERNAL_LIBS_DIR}/${CMAKE_INSTALL_LIBDIR}")
  endif()
endif()

# Workaround: detect NetCDF here using the MODULE logic to avoid issues later on
find_package(NetCDF REQUIRED MODULE)
if(STATIC_IS_DEFAULT)
  find_package(HDF5 REQUIRED MODULE COMPONENTS "C" "HL")
  find_package(ZLIB REQUIRED MODULE)
  set(NETCDF_LIBRARIES "${NETCDF_LIBRARIES};${HDF5_HL_LIBRARIES};${HDF5_LIBRARIES};${ZLIB_LIBRARIES}")
endif()
LIST(REMOVE_DUPLICATES NETCDF_LIBRARIES)
message(STATUS "NETCDF LIBRARIES: ${NETCDF_LIBRARIES}")

# End workaround

# Configure RPATH for shared linking
if(NOT STATIC_IS_DEFAULT)
  set(CMAKE_INSTALL_RPATH_USE_LINK_PATH true)
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



# Create shell scripts for bash and tcsh to set all necessary environment variables for NCEPLIBS and its dependencies
message(STATUS "Creating shell scripts to set environment variables for using NCEPLIBS")
configure_file(setenv_nceplibs_csh_template.txt ${CMAKE_INSTALL_PREFIX}/bin/setenv_nceplibs.csh @ONLY)
configure_file(setenv_nceplibs_bash_template.txt ${CMAKE_INSTALL_PREFIX}/bin/setenv_nceplibs.sh @ONLY)


