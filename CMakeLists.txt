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

# Read Branch/Tag and Version of components from this file
set(DEFAULT_LIBCOMPS ${CMAKE_CURRENT_SOURCE_DIR}/COMPONENTS)

# User options
option(OPENMP       "Enable OpenMP threading" OFF)
option(ENABLE_TESTS "Enable testing"          OFF)
option(BUILD_CRTM   "Build CRTM library"      ON)
option(BUILD_POST   "Build NCEPpost library"  ON)
option(DEPLOY       "Deploy modulefiles"      OFF)
option(LIBCOMPS     "File to read components from" ${DEFAULT_LIBCOMPS})

# Read list of components to install from:
if(NOT LIBCOMPS)
  set(LIBCOMPS_FILE ${DEFAULT_LIBCOMPS})
else()
  set(LIBCOMPS_FILE ${LIBCOMPS})
endif()
message(STATUS "Installing NCEPLIBS from ${LIBCOMPS_FILE}")

# Enable CRTM if NCEPpost library is desired.
if(BUILD_POST)
  if(NOT BUILD_CRTM)
    message(STATUS "Enabling NCEPpost will enable CRTM")
  endif()
  set(BUILD_CRTM ON)
endif()

# Option to overwrite modulefile (if DEPLOY = ON)
if(DEPLOY)
  message(STATUS "Installing NCEPLIBS modulefiles at ${CMAKE_INSTALL_PREFIX}/modules")
  option(OVERWRITEMODULES "Overwrite existing modules (if found!)" OFF)
  if(OVERWRITEMODULES)
    message(STATUS "WARNING: Overwriting NCEPLIBS modulefiles is ON")
  endif()
endif()

# Function to get the Branch/Tag and Version
function(getTagVer fileName libName tag ver)
  set(${tag} "develop" PARENT_SCOPE)
  execute_process(
    COMMAND cat ${fileName}
    COMMAND grep -w ${libName}
    COMMAND cut -d| -f2
    RESULT_VARIABLE _ret OUTPUT_VARIABLE _val)
  if( _ret EQUAL 0 )
    string( STRIP ${_val} _val ) # Strip out leading/trailing blanks
    set( ${tag} ${_val} PARENT_SCOPE )
  endif()
  set(${ver} "develop" PARENT_SCOPE)
  execute_process(
    COMMAND cat ${fileName}
    COMMAND grep -w ${libName}
    COMMAND cut -d| -f3
    RESULT_VARIABLE _ret OUTPUT_VARIABLE _val)
  if( _ret EQUAL 0 )
    string( STRIP ${_val} _val ) # Strip out leading/trailing blanks
    string( REPLACE "/" "-" _val ${_val} ) # replace / in names with - (dont want subdirectories)
    set( ${ver} ${_val} PARENT_SCOPE )
  endif()
endfunction()

# Collect list of components to append to CMAKE_PREFIX_PATH
list(APPEND _comps
  bacio sigio sfcio gfsio ip sp w3nco g2 g2tmpl nemsio nemsiogfs landsfcutil w3emc)
if(BUILD_CRTM)
  list(APPEND _comps crtm)
endif()
if(BUILD_POST)
  list(APPEND _comps nceppost)
endif()
list(APPEND _cpath "${CMAKE_PREFIX_PATH}")
list(APPEND _cpath "${CMAKE_INSTALL_PREFIX}")
foreach(_comp ${_comps})
  list(APPEND _cpath "${CMAKE_INSTALL_PREFIX}/${_comp}")
endforeach()
# Create CMAKE_PREFIX_PATH list with an alternate separator
string(REPLACE ";" "|" CMAKE_PREFIX_PATH_ALT_SEP "${_cpath}")

getTagVer("${LIBCOMPS_FILE}" "bacio" tag ver)
ExternalProject_Add(bacio
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-bacio"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/bacio"
  LIST_SEPARATOR |
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/bacio/bacio-${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

getTagVer("${LIBCOMPS_FILE}" "sigio" tag ver)
ExternalProject_Add(sigio
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-sigio"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/sigio"
  LIST_SEPARATOR |
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/sigio/sigio-${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

getTagVer("${LIBCOMPS_FILE}" "sfcio" tag ver)
ExternalProject_Add(sfcio
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-sfcio"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/sfcio"
  LIST_SEPARATOR |
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/sfcio/sfcio-${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

getTagVer("${LIBCOMPS_FILE}" "gfsio" tag ver)
ExternalProject_Add(gfsio
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-gfsio"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/gfsio"
  LIST_SEPARATOR |
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/gfsio/gfsio-${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

getTagVer("${LIBCOMPS_FILE}" "ip" tag ver)
ExternalProject_Add(ip
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-ip"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/ip"
  LIST_SEPARATOR |
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/ip/ip-${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
                 "-DOPENMP=${OPENMP}"
  )

getTagVer("${LIBCOMPS_FILE}" "sp" tag ver)
ExternalProject_Add(sp
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-sp"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/sp"
  LIST_SEPARATOR |
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/sp/sp-${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
                 "-DOPENMP=${OPENMP}"
  )

getTagVer("${LIBCOMPS_FILE}" "w3nco" tag ver)
ExternalProject_Add(w3nco
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-w3nco"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/w3nco"
  LIST_SEPARATOR |
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/w3nco/w3nco-${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

getTagVer("${LIBCOMPS_FILE}" "nemsio" tag ver)
ExternalProject_Add(nemsio
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-nemsio"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/nemsio"
  LIST_SEPARATOR |
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/nemsio/nemsio-${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  DEPENDS        bacio w3nco
  )

getTagVer("${LIBCOMPS_FILE}" "nemsiogfs" tag ver)
ExternalProject_Add(nemsiogfs
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-nemsiogfs"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/nemsiogfs"
  LIST_SEPARATOR |
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/nemsiogfs/nemsiogfs-${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
                 "-DOPENMP=${OPENMP}"
  DEPENDS        nemsio
  )

getTagVer("${LIBCOMPS_FILE}" "landsfcutil" tag ver)
ExternalProject_Add(landsfcutil
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-landsfcutil"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/landsfcutil"
  LIST_SEPARATOR |
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/landsfcutil/landsfcutil-${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  DEPENDS        nemsio
  )

getTagVer("${LIBCOMPS_FILE}" "g2" tag ver)
ExternalProject_Add(g2
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-g2"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/g2"
  LIST_SEPARATOR |
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/g2/g2-${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

getTagVer("${LIBCOMPS_FILE}" "g2tmpl" tag ver)
ExternalProject_Add(g2tmpl
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-g2tmpl"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/g2tmpl"
  LIST_SEPARATOR |
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/g2tmpl/g2tmpl-${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  )

getTagVer("${LIBCOMPS_FILE}" "w3emc" tag ver)
ExternalProject_Add(w3emc
  GIT_REPOSITORY "https://github.com/noaa-emc/nceplibs-w3emc"
  GIT_TAG        "${tag}"
  PREFIX         "${CMAKE_BINARY_DIR}/w3emc"
  LIST_SEPARATOR |
  CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                 "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/w3emc/w3emc-${ver}"
                 "-DENABLE_TESTS=${ENABLE_TESTS}"
  DEPENDS        nemsio sigio
  )

if(BUILD_CRTM)
  getTagVer("${LIBCOMPS_FILE}" "crtm" tag ver)
  ExternalProject_Add(crtm
    GIT_REPOSITORY "https://github.com/noaa-emc/emc_crtm"
    GIT_TAG        "${tag}"
    PREFIX         "${CMAKE_BINARY_DIR}/crtm"
    LIST_SEPARATOR |
    CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                   "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/crtm/crtm-${ver}"
    )
endif()

if(BUILD_POST)
  getTagVer("${LIBCOMPS_FILE}" "nceppost" tag ver)
  ExternalProject_Add(nceppost
    GIT_REPOSITORY "https://github.com/aerorahul/emc_post"
    GIT_TAG        "${tag}"
    GIT_SUBMODULES "CMakeModules"
    PREFIX         "${CMAKE_BINARY_DIR}/nceppost"
    LIST_SEPARATOR |
    CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                   "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/nceppost/nceppost-${ver}"
                   "-DOPENMP=${OPENMP}"
                   "-DBUILD_POSTEXEC=OFF"
    DEPENDS        bacio w3nco w3emc g2 g2tmpl ip sp crtm
    )
endif()

# Prepare to deploy modulefiles
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/deploy_modulefiles.sh.in
               ${CMAKE_CURRENT_BINARY_DIR}/deploy_modulefiles.sh
               @ONLY)
add_custom_target(prep2deploy ALL
  COMMAND chmod +x ${CMAKE_CURRENT_BINARY_DIR}/deploy_modulefiles.sh
  DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/deploy_modulefiles.sh)

# Deploy modulefiles (if enabled), but do not add to make all (make user do it)
if(DEPLOY)
  add_custom_target(deploy
    COMMAND ${CMAKE_CURRENT_BINARY_DIR}/deploy_modulefiles.sh)
  add_dependencies(deploy prep2deploy)
endif()
