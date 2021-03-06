################################################################################
# Copyright (C) 2016 Advanced Micro Devices, Inc. All rights reserved.
################################################################################

# Natively available on including Ubuntu 14.04, OpenSUSE 13.2, CentOS 6.6
cmake_minimum_required( VERSION 2.8.12 )

# if( NOT CMAKE_TOOLCHAIN_FILE )
#   message( FATAL_ERROR "This project expects to know what compilers it should use through CMAKE_TOOLCHAIN_FILE" )
# endif( )

# This project may compile dependencies for clients
project( rocfft-clients CXX C )

list( APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake )

include( build-options )
include ( build-bitness )

# This captures all of the dependencies cmake builds itself
set( rocfft_clients_dependencies )

# If the user does not explicitely specify BOOST_ROOT, build our
# own on the fly
if( NOT DEFINED BOOST_ROOT )
  include( external-boost )
  list( APPEND rocfft_clients_dependencies boost )
endif( )

if( NOT DEFINED GTEST_ROOT )
  include( external-gtest )
  list( APPEND rocfft_clients_dependencies googletest )
endif( )

if( NOT DEFINED FFTW_ROOT )
  include( external-fftw )
  list( APPEND rocfft_clients_dependencies fftw )
endif( )

list( APPEND CMAKE_PREFIX_PATH ${HIP_ROOT})

# WARNING: do not surround CMAKE_PREFIX_PATH with quotes, it breaks
# Replace all occurances of ; with ^^, which we elect to use a path seperator
string(REGEX REPLACE ";" "^^" CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH}" )
string(REGEX REPLACE ";" "^^" CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" )
string(REGEX REPLACE ";" "^^" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}" )
string(REGEX REPLACE ";" "^^" CMAKE_C_FLAGS "${CMAKE_C_FLAGS}" )

set( CLIENTS_CMAKE_ARGS
	-DCMAKE_TOOLCHAIN_FILE=${DEVICE_TOOLCHAIN_FILE}
  -DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
  -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
  -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
  -DPLATFORM_NAME=${PLATFORM_NAME}
	)

if( NOT CMAKE_CONFIGURATION_TYPES )
	list( APPEND CLIENTS_CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} )
endif( )

if( BUILD_CLIENTS_SAMPLES OR BUILD_CLIENTS_BENCHMARKS OR BUILD_CLIENTS_TESTS OR BUILD_CLIENTS_RIDER )
  include( ExternalProject )
endif( )

if( BUILD_CLIENTS_SAMPLES )
  set( SAMPLES_CMAKE_ARGS
        ${CLIENTS_CMAKE_ARGS}
        -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}^^${FFTW_ROOT}
        -DHIP_SRC_ROOT=${HIP_SRC_ROOT}
  	)

  ExternalProject_Add( samples
    DEPENDS ${rocfft_clients_dependencies}
    SOURCE_DIR ${PROJECT_SOURCE_DIR}/samples
    BINARY_DIR samples-build
    CMAKE_ARGS ${SAMPLES_CMAKE_ARGS}
    LIST_SEPARATOR ^^
    INSTALL_COMMAND ""
  )
endif( )

if( BUILD_CLIENTS_RIDER )
  set( RIDER_CMAKE_ARGS
        ${CLIENTS_CMAKE_ARGS}
        -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}^^${FFTW_ROOT}^^${BOOST_ROOT}
        -DHIP_SRC_ROOT=${HIP_SRC_ROOT}
  	)

  ExternalProject_Add( rider
    DEPENDS ${rocfft_clients_dependencies}
    SOURCE_DIR ${PROJECT_SOURCE_DIR}/rider
    BINARY_DIR rider-build
    CMAKE_ARGS ${RIDER_CMAKE_ARGS}
    LIST_SEPARATOR ^^
    INSTALL_COMMAND ""
  )
endif( )

if( BUILD_CLIENTS_SELFTEST )
  set( SELFTEST_CMAKE_ARGS
        ${CLIENTS_CMAKE_ARGS}
        -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}^^${BOOST_ROOT}^^${GTEST_ROOT}
        -DHIP_SRC_ROOT=${HIP_SRC_ROOT}
  	)

  ExternalProject_Add( selftest
    DEPENDS ${rocfft_clients_dependencies}
    SOURCE_DIR ${PROJECT_SOURCE_DIR}/selftest
    BINARY_DIR selftest-build
    CMAKE_ARGS ${SELFTEST_CMAKE_ARGS}
    LIST_SEPARATOR ^^
    INSTALL_COMMAND ""
  )
endif( )

if( BUILD_CLIENTS_BENCHMARKS )
    set( BENCH_CMAKE_ARGS
          ${CLIENTS_CMAKE_ARGS}
          -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}^^${BOOST_ROOT}
          -DHIP_SRC_ROOT=${HIP_SRC_ROOT}
      )

  ExternalProject_Add( benchmarks
    DEPENDS ${rocfft_clients_dependencies}
    SOURCE_DIR ${PROJECT_SOURCE_DIR}/benchmarks
    BINARY_DIR benchmarks-build
    CMAKE_ARGS ${BENCH_CMAKE_ARGS}
    LIST_SEPARATOR ^^
    INSTALL_COMMAND ""
  )
endif( )

if( BUILD_CLIENTS_TESTS )
  set( TESTS_CMAKE_ARGS
        ${CLIENTS_CMAKE_ARGS}
        -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}^^${BOOST_ROOT}^^${GTEST_ROOT}^^${FFTW_ROOT}
        -DHIP_SRC_ROOT=${HIP_SRC_ROOT}
  	)

  ExternalProject_Add( tests
    DEPENDS ${rocfft_clients_dependencies} googletest
    SOURCE_DIR ${PROJECT_SOURCE_DIR}/tests
    BINARY_DIR tests-build
    CMAKE_ARGS ${TESTS_CMAKE_ARGS}
    LIST_SEPARATOR ^^
    INSTALL_COMMAND ""
  )
endif( )
