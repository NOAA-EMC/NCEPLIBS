cmake_minimum_required(VERSION 3.15)

cmake_policy(SET CMP0048 NEW)

# Set cmake policies

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

project(
  NCEPLIBS
  VERSION 1.0.0
  LANGUAGES C CXX Fortran)

set(CMAKE_FIND_PACKAGE_PREFER_CONFIG true)

include(GNUInstallDirs)

# set default install path if not provided
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX
      "${CMAKE_BINARY_DIR}/install"
      CACHE PATH "default install path" FORCE)
endif()

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

# Configure RPATH for macOS
if(APPLE)
  set(CMAKE_INSTALL_RPATH_USE_LINK_PATH true)
endif()

add_subdirectory(NCEPLIBS-bacio)
add_subdirectory(NCEPLIBS-ip)
add_subdirectory(NCEPLIBS-g2)
add_subdirectory(NCEPLIBS-sigio)
add_subdirectory(NCEPLIBS-sp)
add_subdirectory(NCEPLIBS-nemsio)
add_subdirectory(NCEPLIBS-w3nco)
# add_subdirectory(NCEPLIBS-bufr)
add_subdirectory(NCEPLIBS-g2tmpl)
add_subdirectory(NCEPLIBS-gfsio)
add_subdirectory(NCEPLIBS-landsfcutil)
add_subdirectory(NCEPLIBS-sfcio)
add_subdirectory(NCEPLIBS-w3emc)
add_subdirectory(NCEPLIBS-nemsiogfs)
