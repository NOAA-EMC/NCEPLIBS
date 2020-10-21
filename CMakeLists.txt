# This is the main CMake file for the NCEPLIBS project.
#
# Kyle Gerheiser, Dom Heinzeller
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
option(OPENMP        "Enable OpenMP threading" OFF)
option(ENABLE_TESTS  "Enable testing"          OFF)
option(BUILD_CRTM    "Build CRTM library"      ON)
option(BUILD_POST    "Build NCEPpost library"  ON)
option(DEPLOY        "Deploy modulefiles"      OFF)
option(TCLMOD        "Create Tcl modulefiles " OFF)
option(FLAT          "Flat install structure"  ON)
option(LIBCOMPS      "File to read components from" ${DEFAULT_LIBCOMPS})
option(DOWNLOAD_ONLY "Just download the components" OFF)
option(USE_LOCAL     "Use locally downloaded components" OFF)
OPTION(ENABLE_DOCS "Enable generation of doxygen-based documentation." OFF)

if(DOWNLOAD_ONLY AND USE_LOCAL)
  message(FATAL_ERROR "DOWNLOAD_ONLY AND USE_LOCAL CANNOT BOTH BE ON, ABORT!")
endif()

# Read list of components to install from:
if(NOT LIBCOMPS)
  set(LIBCOMPS_FILE ${DEFAULT_LIBCOMPS})
else()
  set(LIBCOMPS_FILE ${LIBCOMPS})
endif()
message(STATUS "Installing NCEPLIBS from ${LIBCOMPS_FILE}")
message(STATUS "Installing NCEPLIBS at ${CMAKE_INSTALL_PREFIX}")

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

function(trapLocalError sourceDir)
  if(NOT EXISTS ${sourceDir})
    message(FATAL_ERROR "Directory does not exist ${sourceDir}, ABORT!")
  endif()
endfunction()

function(getInstallDir FLAT lib ver installDir)
  if(FLAT)
    set(var ${lib}-${ver})
  else()
    set(var ${lib}/${lib}-${ver})
  endif()
  set(${installDir} ${var} PARENT_SCOPE)
endfunction()

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
  bacio sigio sfcio gfsio ip sp w3nco g2 g2tmpl nemsio nemsiogfs landsfcutil w3emc wrf_io bufr wgrib2)

# ip and ip2 cannot coexist in a flat structure because they share module names which overwrite each other
if(NOT FLAT)
  list(APPEND _comps ip2)
endif()

set(nceplibs ${_comps})

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

set(nemsio_depends bacio w3nco)
set(nemsiogfs_depends nemsio)
set(w3emc_depends nemsio sigio)
set(ip2_depends sp)

if(DOWNLOAD_ONLY)
  set(CONFIGURE_ONLY "echo")
  set(BUILD_ONLY     "echo")
  set(INSTALL_ONLY   "echo")
endif()

foreach(lib ${nceplibs})
  getTagVer("${LIBCOMPS_FILE}" "${lib}" GIT_TAG ver)
  getInstallDir(${FLAT} ${lib} ${ver} installDir)

  set(GIT_URL    "https://github.com/noaa-emc/nceplibs-${lib}")
  set(SOURCE_DIR "${CMAKE_SOURCE_DIR}/download/nceplibs-${lib}")

  if(USE_LOCAL)
    set(GIT_URL      "")
    set(GIT_TAG      "")
    trapLocalError(${SOURCE_DIR})
  endif()

  ExternalProject_Add(${lib}
    GIT_REPOSITORY "${GIT_URL}"
    GIT_TAG        "${GIT_TAG}"
    PREFIX         "${CMAKE_BINARY_DIR}/${lib}"
    SOURCE_DIR     "${SOURCE_DIR}"
    LIST_SEPARATOR |
    CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                   "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/${installDir}"
                   "-DENABLE_TESTS=${ENABLE_TESTS}"
                   "-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}"
                   "-DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}"
                   "-DOPENMP=${OPENMP}"
                   ${${lib}_CMAKE_ARGS}
    DEPENDS        ${${lib}_depends}
    CONFIGURE_COMMAND ${CONFIGURE_ONLY}
    BUILD_COMMAND     ${BUILD_ONLY}
    INSTALL_COMMAND   ${INSTALL_ONLY}
    )
endforeach()

if(BUILD_CRTM)
  getTagVer("${LIBCOMPS_FILE}" "crtm" GIT_TAG ver)
  getInstallDir(${FLAT} "crtm" ${ver} installDir)

  set(GIT_URL    "https://github.com/noaa-emc/emc_crtm")
  set(SOURCE_DIR "${CMAKE_SOURCE_DIR}/download/emc_crtm")

  if(USE_LOCAL)
    set(GIT_URL      "")
    set(GIT_TAG      "")
    trapLocalError(${SOURCE_DIR})
  endif()

  ExternalProject_Add(crtm
    GIT_REPOSITORY "${GIT_URL}"
    GIT_TAG        "${GIT_TAG}"
    PREFIX         "${CMAKE_BINARY_DIR}/crtm"
    SOURCE_DIR     "${SOURCE_DIR}"
    LIST_SEPARATOR |
    CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                   "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/${installDir}"
                   "-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}"
                   "-DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}"
    CONFIGURE_COMMAND ${CONFIGURE_ONLY}
    BUILD_COMMAND     ${BUILD_ONLY}
    INSTALL_COMMAND   ${INSTALL_ONLY}
    )
endif()

if(BUILD_POST)
  getTagVer("${LIBCOMPS_FILE}" "nceppost" GIT_TAG ver)
  getInstallDir(${FLAT} "nceppost" ${ver} installDir)

  set(GIT_URL    "https://github.com/noaa-emc/emc_post")
  set(SOURCE_DIR "${CMAKE_SOURCE_DIR}/download/emc_post")

  if(USE_LOCAL)
    set(GIT_URL      "")
    set(GIT_TAG      "")
    trapLocalError(${SOURCE_DIR})
  endif()

  ExternalProject_Add(nceppost
    GIT_REPOSITORY "${GIT_URL}"
    GIT_TAG        "${GIT_TAG}"
    GIT_SUBMODULES "CMakeModules"
    PREFIX         "${CMAKE_BINARY_DIR}/nceppost"
    SOURCE_DIR     "${SOURCE_DIR}"
    LIST_SEPARATOR |
    CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                   "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/${installDir}"
                   "-DOPENMP=${OPENMP}"
                   "-DBUILD_POSTEXEC=OFF"
                   "-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}"
                   "-DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}"
    DEPENDS        bacio w3nco w3emc g2 g2tmpl ip sp crtm
    CONFIGURE_COMMAND ${CONFIGURE_ONLY}
    BUILD_COMMAND     ${BUILD_ONLY}
    INSTALL_COMMAND   ${INSTALL_ONLY}
    )
endif()

if(DOWNLOAD_ONLY)
  add_custom_target(tarball
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMAND tar -czf nceplibs.tgz download)
    add_dependencies(tarball ${_comps})
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
  if(TCLMOD)
    add_custom_target(tcl
      COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/lua2tcl.py ${CMAKE_INSTALL_PREFIX}/modules)
    add_dependencies(tcl deploy)
  endif()
endif()

# Determine whether or not to generate documentation.
IF(ENABLE_DOCS)
  FIND_PACKAGE(Doxygen REQUIRED)
ENDIF()
ADD_SUBDIRECTORY(docs)  



