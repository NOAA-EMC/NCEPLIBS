cmake_minimum_required(VERSION 3.15)

file(STRINGS "VERSION" pVersion)

project(
  NCEPLIBS
  VERSION ${pVersion}
  LANGUAGES C Fortran)

include(ExternalProject)
include(GNUInstallDirs)

if(NOT CMAKE_BUILD_TYPE MATCHES "^(Tarball|Portable|Debug|Release|RelWithDebInfo|MinSizeRel)$")
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
option(TCLMOD       "Create Tcl modulefiles " OFF)
option(FLAT         "Flat install structure"  ON)
option(LIBCOMPS     "File to read components from" ${DEFAULT_LIBCOMPS})

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
  bacio sigio sfcio gfsio ip sp w3nco g2 g2tmpl nemsio nemsiogfs landsfcutil w3emc wrf_io bufr)
  
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
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/src) 
  # This is a portable version with pre-cloned repos
  set(gitloc ${CMAKE_CURRENT_SOURCE_DIR}/src)
else()
  set(gitloc "https://github.com/noaa-emc" )
endif()  
if(CMAKE_BUILD_TYPE STREQUAL "Tarball")
  find_package(Git QUIET)
  message("creating portable tarball")
  set(gitloc "https://github.com/noaa-emc" )
  set(prefix ${CMAKE_CURRENT_SOURCE_DIR}/src)
  file(MAKE_DIRECTORY ${prefix})
  list(APPEND nceplibs 
      wgrib2 ip2 )
  foreach(lib ${nceplibs})
    if(NOT EXISTS ${prefix}/nceplibs-${lib})
      getTagVer("${LIBCOMPS_FILE}" "${lib}" tag ver)
      set(git_args  clone -c advice.detachedHead=false --recurse-submodules --branch ${tag} ${gitloc}/nceplibs-${lib} )
      message("gitargs are ${git_args}")
      execute_process(COMMAND ${GIT_EXECUTABLE} ${git_args}
                      WORKING_DIRECTORY ${prefix}
                      RESULT_VARIABLE GIT_RESULT)
      if(NOT GIT_RESULT EQUAL "0")
          message(FATAL_ERROR "git clone failed with ${GIT_RESULT}")
      endif()
    endif()
  endforeach()
  list(APPEND _emc post crtm)
    getTagVer("${LIBCOMPS_FILE}" "nceppost" tag ver)
    foreach(lib ${_emc})
      if(NOT EXISTS ${prefix}/emc_${lib})
        if(${lib} STREQUAL "post")
          getTagVer("${LIBCOMPS_FILE}" "nceppost" tag ver)
        else()
          getTagVer("${LIBCOMPS_FILE}" "${lib}" tag ver)
        endif()
        set(git_args  clone  -c advice.detachedHead=false --recurse-submodules ${gitloc}/emc_${lib}.git )
        message("gitargs are ${git_args}")
        execute_process(COMMAND ${GIT_EXECUTABLE} ${git_args}
                    WORKING_DIRECTORY ${prefix}
                    RESULT_VARIABLE GIT_RESULT)
        if(NOT GIT_RESULT EQUAL "0")
            message(FATAL_ERROR "git clone failed with ${GIT_RESULT}")
        endif()
      endif()
    endforeach()
  get_filename_component(barename ${CMAKE_CURRENT_SOURCE_DIR} NAME)
  set(tar_args cfz nceplibs.release-v2.tar.gz ${barename} )
  execute_process(COMMAND tar ${tar_args} 
                    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/..
                    RESULT_VARIABLE TAR_RESULT)
  if(NOT TAR_RESULT EQUAL "0")
        message(FATAL_ERROR "tar failed with ${TAR_RESULT}")
  endif()
else()
  
  foreach(lib ${nceplibs})
    getTagVer("${LIBCOMPS_FILE}" "${lib}" tag ver)
    getInstallDir(${FLAT} ${lib} ${ver} installDir)
    if(${CMAKE_BUILD_TYPE STREQUAL "Portable") 
      ExternalProject_Add(${lib}
      URL            "${gitloc}/nceplibs-${lib}"
      PREFIX         "${CMAKE_BINARY_DIR}/${lib}"
      LIST_SEPARATOR |
      CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                     "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/${installDir}"
                     "-DENABLE_TESTS=${ENABLE_TESTS}"
                     "-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}"
                     "-DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}"
                     "-DOPENMP=${OPENMP}"
      DEPENDS        ${${lib}_depends}
      )
    else()
      ExternalProject_Add(${lib}
      GIT_REPOSITORY "${gitloc}/nceplibs-${lib}"
      GIT_TAG        "${tag}"
      PREFIX         "${CMAKE_BINARY_DIR}/${lib}"
      LIST_SEPARATOR |
      CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                     "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/${installDir}"
                     "-DENABLE_TESTS=${ENABLE_TESTS}"
                     "-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}"
                     "-DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}"
                     "-DOPENMP=${OPENMP}"
      DEPENDS        ${${lib}_depends}
      )
    endif()
  endforeach()
  
  if(NOT FLAT)
    set(USE_IPOLATES 3)
    set(USE_SPECTRAL ON)
    set(wgrib2_depends ip2 sp)
  else()
    set(USE_IPOLATES 0)
    set(USE_SPECTRAL OFF)
    set(wgrib2_depends "")
  endif()
  
  getTagVer("${LIBCOMPS_FILE}" "wgrib2" tag ver)
  getInstallDir(${FLAT} wgrib2 ${ver} installDir)
  if(${CMAKE_BUILD_TYPE STREQUAL "Portable") 
    ExternalProject_Add(wgrib2
    URL "${gitloc}/nceplibs-wgrib2"
    PREFIX "${CMAKE_BINARY_DIR}/wgrib2"
    LIST_SEPARATOR | 
    CMAKE_ARGS "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
               "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/${installDir}"
               "-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}"
               "-DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}"
               "-DOPENMP=${OPENMP}"
               "-DUSE_IPOLATES=${USE_IPOLATES}"
               "-DUSE_SPECTRAL=${USE_SPECTRAL}"
    DEPENDS    ${wgrib2_depends}
    )
  else()
    ExternalProject_Add(wgrib2
    GIT_REPOSITORY "${gitloc}/nceplibs-wgrib2"
    GIT_TAG "${tag}"
    PREFIX "${CMAKE_BINARY_DIR}/wgrib2"
    LIST_SEPARATOR | 
    CMAKE_ARGS "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
               "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/${installDir}"
               "-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}"
               "-DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}"
               "-DOPENMP=${OPENMP}"
               "-DUSE_IPOLATES=${USE_IPOLATES}"
               "-DUSE_SPECTRAL=${USE_SPECTRAL}"
    DEPENDS    ${wgrib2_depends}
    )
  endif()          
  
  if(BUILD_CRTM)
    getTagVer("${LIBCOMPS_FILE}" "crtm" tag ver)
    getInstallDir(${FLAT} "crtm" ${ver} installDir)
  
    if(${CMAKE_BUILD_TYPE STREQUAL "Portable") 
      ExternalProject_Add(crtm
      URL "${gitloc}/emc_crtm"
      PREFIX         "${CMAKE_BINARY_DIR}/crtm"
      LIST_SEPARATOR |
      CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                     "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/${installDir}"
                     "-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}"
                     "-DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}"
      )
    else()
      ExternalProject_Add(crtm
      GIT_REPOSITORY "${gitloc}/emc_crtm"
      GIT_TAG        "${tag}"
      PREFIX         "${CMAKE_BINARY_DIR}/crtm"
      LIST_SEPARATOR |
      CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                     "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/${installDir}"
                     "-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}"
                     "-DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}"
      )
    endif()
  endif()
  
  if(BUILD_POST)
    getTagVer("${LIBCOMPS_FILE}" "nceppost" tag ver)
    getInstallDir(${FLAT} "nceppost" ${ver} installDir)
  
    if(${CMAKE_BUILD_TYPE STREQUAL "Portable") 
      ExternalProject_Add(nceppost
      URL "${gitloc}/emc_post"
      GIT_SUBMODULES "CMakeModules"
      PREFIX         "${CMAKE_BINARY_DIR}/nceppost"
      LIST_SEPARATOR |
      CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                     "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/${installDir}"
                     "-DOPENMP=${OPENMP}"
                     "-DBUILD_POSTEXEC=OFF"
                     "-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}"
                     "-DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}"
      DEPENDS        bacio w3nco w3emc g2 g2tmpl ip sp crtm
      )
    else()
      ExternalProject_Add(nceppost
      GIT_REPOSITORY "${gitloc}/emc_post"
      GIT_TAG        "${tag}"
      GIT_SUBMODULES "CMakeModules"
      PREFIX         "${CMAKE_BINARY_DIR}/nceppost"
      LIST_SEPARATOR |
      CMAKE_ARGS     "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}"
                    "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/${installDir}"
                     "-DOPENMP=${OPENMP}"
                     "-DBUILD_POSTEXEC=OFF"
                     "-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}"
                     "-DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}"
      DEPENDS        bacio w3nco w3emc g2 g2tmpl ip sp crtm
      )
    endif()
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
endif()
