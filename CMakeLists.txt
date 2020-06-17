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

ExternalProject_Add(bacio
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-bacio"
  GIT_TAG        "develop"
  PREFIX         "${CMAKE_BINARY_DIR}/bacio"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/bacio"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

ExternalProject_Add(sigio
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-sigio"
  GIT_TAG        "develop"
  PREFIX         "${CMAKE_BINARY_DIR}/sigio"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/sigio"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

ExternalProject_Add(sfcio
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-sfcio"
  GIT_TAG        "develop"
  PREFIX         "${CMAKE_BINARY_DIR}/sfcio"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/sfcio"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

ExternalProject_Add(gfsio
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-gfsio"
  GIT_TAG        "develop"
  PREFIX         "${CMAKE_BINARY_DIR}/gfsio"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/gfsio"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

ExternalProject_Add(ip
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-ip"
  GIT_TAG        "develop"
  PREFIX         "${CMAKE_BINARY_DIR}/ip"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/ip"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
                 "-DOPENMP=${OPENMP}"
  )

ExternalProject_Add(sp
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-sp"
  GIT_TAG        "develop"
  PREFIX         "${CMAKE_BINARY_DIR}/sp"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/sp"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
                 "-DOPENMP=${OPENMP}"
  )

ExternalProject_Add(w3nco
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-w3nco"
  GIT_TAG        "develop"
  PREFIX         "${CMAKE_BINARY_DIR}/w3nco"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/w3nco"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

ExternalProject_Add(nemsio
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-nemsio"
  GIT_TAG        "develop"
  PREFIX         "${CMAKE_BINARY_DIR}/nemsio"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/nemsio"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  DEPENDS        bacio w3nco
  )

ExternalProject_Add(nemsiogfs
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-nemsiogfs"
  GIT_TAG        "develop"
  PREFIX         "${CMAKE_BINARY_DIR}/nemsiogfs"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/nemsiogfs"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
                 "-DOPENMP=${OPENMP}"
  DEPENDS        nemsio
  )

ExternalProject_Add(landsfcutil
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-landsfcutil"
  GIT_TAG        "develop"
  PREFIX         "${CMAKE_BINARY_DIR}/landsfcutil"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/landsfcutil"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  DEPENDS        nemsio
  )

ExternalProject_Add(g2
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-g2"
  GIT_TAG        "develop"
  PREFIX         "${CMAKE_BINARY_DIR}/g2"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/g2"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

ExternalProject_Add(g2tmpl
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-g2tmpl"
  GIT_TAG        "develop"
  PREFIX         "${CMAKE_BINARY_DIR}/g2tmpl"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/g2tmpl"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

ExternalProject_Add(w3emc
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-w3emc"
  GIT_TAG        "develop"
  PREFIX         "${CMAKE_BINARY_DIR}/w3emc"
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/w3emc"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  DEPENDS        nemsio sigio
  )

if(BUILD_CRTM)
  ExternalProject_Add(crtm
    GIT_REPOSITORY "https://github.com/noaa-emc/emc_crtm"
    GIT_TAG        "develop"
    PREFIX         "${CMAKE_BINARY_DIR}/crtm"
    CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                   "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/crtm"
    )
endif()

if(BUILD_POST)
  ExternalProject_Add(post
    GIT_REPOSITORY "https://github.com/aerorahul/emc_post"
    GIT_TAG        "feature/cmakepkg"
    PREFIX         "${CMAKE_BINARY_DIR}/post"
    CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}"
                   "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/post"
                   "-DBUILD_POSTEXEC=OFF"
    DEPENDS        bacio sigio sfcio gfsio nemsio w3nco w3emc g2 g2tmpl ip sp crtm
    )
endif()
