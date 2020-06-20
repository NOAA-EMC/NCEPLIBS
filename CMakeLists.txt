cmake_minimum_required(VERSION 3.15)

file(STRINGS "VERSION" pVersion)

project(
  NCEPLIBS
  VERSION ${pVersion}
  LANGUAGES C Fortran)

include(ExternalProject)
include(GNUInstallDirs)

if(NOT CMAKE_BUILD_TYPE MATCHES "^(Debug|Release|RelWithDebInfo|MinSizeRel)$")
  message(STATUS "Setting build type to 'Release' as none was specified.")
  set(CMAKE_BUILD_TYPE
    "Release"
    CACHE STRING "Choose the type of build." FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release"
    "MinSizeRel" "RelWithDebInfo")
endif()

if(NOT CMAKE_C_COMPILER_ID MATCHES "^(Intel|GNU|Clang|AppleClang)$")
  message(WARNING "Compiler not officially supported: ${CMAKE_C_COMPILER_ID}")
endif()

option(OPENMP       "Enable OpenMP threading" OFF)
option(ENABLE_TESTS "Enable testing"          OFF)
option(BUILD_CRTM   "Build CRTM library"      ON)
option(BUILD_POST   "Build NCEPpost library"  ON)

# Enable CRTM if NCEPpost library is desired.
if(BUILD_POST)
  if(NOT BUILD_CRTM)
    message(STATUS "Enabling NCEPpost will enable CRTM")
  endif()
  set(BUILD_CRTM ON)
endif()

# Function to get the Branch/Tag and Version
function(getTagVer fileName libName tag ver)
  set(${tag} "develop" PARENT_SCOPE)
  execute_process(
    COMMAND cat ${fileName}
    COMMAND grep ${libName}
    COMMAND cut -d| -f2
    RESULT_VARIABLE _ret OUTPUT_VARIABLE _val)
  if( _ret EQUAL 0 )
    string( STRIP ${_val} _val )
    set( ${tag} ${_val} PARENT_SCOPE )
  endif()
  set(${ver} "develop" PARENT_SCOPE)
  execute_process(
    COMMAND cat ${fileName}
    COMMAND grep ${libName}
    COMMAND cut -d| -f3
    RESULT_VARIABLE _ret OUTPUT_VARIABLE _val)
  if( _ret EQUAL 0 )
    string( STRIP ${_val} _val )
    set( ${ver} ${_val} PARENT_SCOPE )
  endif()
endfunction()

getTagVer("${CMAKE_CURRENT_SOURCE_DIR}/COMPONENTS" "bacio" tag ver)
ExternalProject_Add(bacio
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-bacio"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/bacio"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/bacio/${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

getTagVer("${CMAKE_CURRENT_SOURCE_DIR}/COMPONENTS" "sigio" tag ver)
ExternalProject_Add(sigio
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-sigio"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/sigio"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/sigio/${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

getTagVer("${CMAKE_CURRENT_SOURCE_DIR}/COMPONENTS" "sfcio" tag ver)
ExternalProject_Add(sfcio
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-sfcio"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/sfcio"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/sfcio/${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

getTagVer("${CMAKE_CURRENT_SOURCE_DIR}/COMPONENTS" "gfsio" tag ver)
ExternalProject_Add(gfsio
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-gfsio"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/gfsio"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/gfsio/${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

getTagVer("${CMAKE_CURRENT_SOURCE_DIR}/COMPONENTS" "ip" tag ver)
ExternalProject_Add(ip
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-ip"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/ip"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/ip/${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
                 "-DOPENMP=${OPENMP}"
  )

getTagVer("${CMAKE_CURRENT_SOURCE_DIR}/COMPONENTS" "sp" tag ver)
ExternalProject_Add(sp
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-sp"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/sp"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/sp/${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
                 "-DOPENMP=${OPENMP}"
  )

getTagVer("${CMAKE_CURRENT_SOURCE_DIR}/COMPONENTS" "w3nco" tag ver)
ExternalProject_Add(w3nco
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-w3nco"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/w3nco"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/w3nco/${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

getTagVer("${CMAKE_CURRENT_SOURCE_DIR}/COMPONENTS" "nemsio" tag ver)
ExternalProject_Add(nemsio
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-nemsio"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/nemsio"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/nemsio/${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  DEPENDS        bacio w3nco
  )

getTagVer("${CMAKE_CURRENT_SOURCE_DIR}/COMPONENTS" "nemsiogfs" tag ver)
ExternalProject_Add(nemsiogfs
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-nemsiogfs"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/nemsiogfs"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/nemsiogfs/${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
                 "-DOPENMP=${OPENMP}"
  DEPENDS        nemsio
  )

getTagVer("${CMAKE_CURRENT_SOURCE_DIR}/COMPONENTS" "landsfcutil" tag ver)
ExternalProject_Add(landsfcutil
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-landsfcutil"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/landsfcutil"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/landsfcutil/${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  DEPENDS        nemsio
  )

getTagVer("${CMAKE_CURRENT_SOURCE_DIR}/COMPONENTS" "g2" tag ver)
ExternalProject_Add(g2
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-g2"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/g2"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/g2/${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

getTagVer("${CMAKE_CURRENT_SOURCE_DIR}/COMPONENTS" "g2tmpl" tag ver)
ExternalProject_Add(g2tmpl
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-g2tmpl"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/g2tmpl"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/g2tmpl/${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

getTagVer("${CMAKE_CURRENT_SOURCE_DIR}/COMPONENTS" "w3emc" tag ver)
ExternalProject_Add(w3emc
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-w3emc"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/w3emc"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/w3emc/${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  DEPENDS        nemsio sigio
  )

if(BUILD_CRTM)
  getTagVer("${CMAKE_CURRENT_SOURCE_DIR}/COMPONENTS" "crtm" tag ver)
  ExternalProject_Add(crtm
    GIT_REPOSITORY "https://github.com/noaa-emc/emc_crtm"
    GIT_TAG        "${tag}"
    PREFIX         "${CMAKE_BINARY_DIR}/crtm"
    CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                   "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/crtm/${ver}"
    )
endif()

if(BUILD_POST)
  getTagVer("${CMAKE_CURRENT_SOURCE_DIR}/COMPONENTS" "nceppost" tag ver)
  ExternalProject_Add(nceppost
    GIT_REPOSITORY "https://github.com/aerorahul/emc_post"
    GIT_TAG        "${tag}"
    GIT_SUBMODULES "CMakeModules"
    PREFIX         "${CMAKE_BINARY_DIR}/nceppost"
    CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                   "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/nceppost/${ver}"
                   "-DBUILD_POSTEXEC=OFF"
    DEPENDS        bacio sigio sfcio gfsio nemsio w3nco w3emc g2 g2tmpl ip sp crtm
    )
endif()
