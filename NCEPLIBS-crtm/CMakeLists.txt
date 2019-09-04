cmake_minimum_required(VERSION 2.6)
project(crtm)
set(VERSION v2.2.3)
set(crtm ${CMAKE_PROJECT_NAME}_${VERSION})
enable_language (Fortran)
if (NOT CMAKE_BUILD_TYPE)
    set (CMAKE_BUILD_TYPE RELEASE CACHE STRING
        "Choose the type of build, options are: PRODUCTION Debug Release."
        FORCE)
endif()
if(CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
  message("setting intel true")
  set(IntelComp true )
elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU*")
  set(GNUComp true )
elseif(CMAKE_CXX_COMPILER_ID MATCHES "pgc*")
  set(PGIComp true )
endif()
STRING(COMPARE EQUAL ${CMAKE_BUILD_TYPE} "RelWithDebInfo" BUILD_RELEASE)
if(NOT BUILD_RELEASE)
  STRING(COMPARE EQUAL ${CMAKE_BUILD_TYPE} "RELEASE" BUILD_RELEASE)
endif()
STRING(COMPARE EQUAL ${CMAKE_BUILD_TYPE} "PRODUCTION" BUILD_PRODUCTION)
STRING(COMPARE EQUAL ${CMAKE_BUILD_TYPE} "DEGUG" BUILD_DEBUG)
if( (BUILD_RELEASE) OR (BUILD_PRODUCTION) )
  if(IntelComp)
    message("setting intel flags")
    set(CMAKE_C_FLAGS "-O3 -DUNDERSCORE -DLINUX " CACHE INTERNAL "" )
    set (CRTM_Fortran_FLAGS " -O3 -convert big_endian -free -assume byterecl -fp-model source -traceback ${HOST_FLAG}" CACHE INTERNAL "" )
  elseif(GNUComp)
  elseif(PGIComp)
  else()
    message("unkown compiler!")
    exit()
  endif()
endif()

set(CRTM_DIR ${CMAKE_CURRENT_SOURCE_DIR})
message("hey crtmdir is ${CRTM_DIR}")
file(GLOB CRTM_FPP_SRC ${CRTM_DIR}/*.fpp)
set(CRTM_PP_SRC "")
FOREACH( fppfile ${CRTM_FPP_SRC} )
    get_filename_component(SRC_WITHOUT_EXT ${fppfile} NAME_WE)
    set(F_SRC_FILE "${SRC_WITHOUT_EXT}.F")
   ADD_CUSTOM_COMMAND(
     OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/${F_SRC_FILE}
     PRE_BUILD
     COMMAND ${CMAKE_COMMAND} -E copy ${fppfile} ${CMAKE_CURRENT_SOURCE_DIR}/${F_SRC_FILE}
     DEPENDS ${fppfile}
   )
   list(APPEND CRTM_PP_SRC "${F_SRC_FILE}")
endforeach()
ADD_CUSTOM_TARGET(copy ALL DEPENDS ${CRTM_PP_SRC} )
file(GLOB CRTM_SRC ${CRTM_DIR}/*.f90 )
set_source_files_properties( ${CRTM_PP_SRC} COMPILE_FLAGS ${CRTM_Fortran_FLAGS} )
set_source_files_properties( ${CRTM_SRC} COMPILE_FLAGS ${CRTM_Fortran_FLAGS} )
  
set(CMAKE_Fortran_FLAGS_RELEASE "")
add_library( ${crtm} STATIC ${CRTM_SRC} ${CRTM_PP_SRC} )
set(CMAKE_INCLUDE_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/include")
set_target_properties( ${crtm} PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_INCLUDE_OUTPUT_DIRECTORY} )
include_directories( ${CRTM_DIR} )

set(CMAKE_INCLUDE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/include")
set_target_properties(${crtm} PROPERTIES Fortran_MODULE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/include")
target_include_directories(${crtm} PUBLIC "${CMAKE_CURRENTT_BINARY_DIR}/include")

install(TARGETS ${crtm}
        RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
        LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
        ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib) 
install(DIRECTORY ${CMAKE_INCLUDE_OUTPUT_DIRECTORY}/ DESTINATION include )

