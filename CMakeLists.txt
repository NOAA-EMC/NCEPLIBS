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

# By default turn off OpenMP support
option(OPENMP "use OpenMP threading" OFF)
option(ENABLE_TESTS "Enable testing" OFF)

#list(APPEND CMAKE_ARGS "-DOPENMP=${OPENMP}")
#list(APPEND CMAKE_ARGS "-DENABLE_TESTS=${ENABLE_TESTS}")

ExternalProject_Add(bacio
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-bacio"
  GIT_TAG        "develop"
  PREFIX         "${CMAKE_BINARY_DIR}/bacio"
  CMAKE_ARGS     "-DENABLE_TESTS=${ENABLE_TESTS}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/bacio"
)

ExternalProject_Add(sigio
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-sigio"
  GIT_TAG        "develop"
  PREFIX         "${CMAKE_BINARY_DIR}/sigio"
  CMAKE_ARGS     "-DENABLE_TESTS=${ENABLE_TESTS}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/sigio"
)

ExternalProject_Add(sfcio
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-sfcio"
  GIT_TAG        "develop"
  PREFIX         "${CMAKE_BINARY_DIR}/sfcio"
  CMAKE_ARGS     "-DENABLE_TESTS=${ENABLE_TESTS}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/sfcio"
)

ExternalProject_Add(gfsio
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-gfsio"
  GIT_TAG        "develop"
  PREFIX         "${CMAKE_BINARY_DIR}/gfsio"
  CMAKE_ARGS     "-DENABLE_TESTS=${ENABLE_TESTS}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/gfsio"
)

ExternalProject_Add(ip
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-ip"
  GIT_TAG        "develop"
  PREFIX         "${CMAKE_BINARY_DIR}/ip"
  CMAKE_ARGS     "-DENABLE_TESTS=${ENABLE_TESTS}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/ip"
)

ExternalProject_Add(sp
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-sp"
  GIT_TAG        "develop"
  PREFIX         "${CMAKE_BINARY_DIR}/sp"
  CMAKE_ARGS     "-DENABLE_TESTS=${ENABLE_TESTS}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/sp"
)

#ExternalProject_Add(w3nco
#  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-w3nco"
#  GIT_TAG        "develop"
#  PREFIX         "${CMAKE_BINARY_DIR}/w3nco"
#  CMAKE_ARGS     "-DENABLE_TESTS=${ENABLE_TESTS}"
#                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/w3nco"
#)
#
#ExternalProject_Add(nemsio
#  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-nemsio"
#  GIT_TAG        "develop"
#  PREFIX         "${CMAKE_BINARY_DIR}/nemsio"
#  CMAKE_ARGS     "-DENABLE_TESTS=${ENABLE_TESTS}"
#                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/nemsio"
#)

#ExternalProject_Add(bacio
#  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-bacio"
#  GIT_TAG        "develop"
#  PREFIX         "${CMAKE_BINARY_DIR}/bacio"
#  CMAKE_ARGS     "-DENABLE_TESTS=${ENABLE_TESTS}"
#                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/bacio"
#)
