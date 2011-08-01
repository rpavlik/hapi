cmake_minimum_required(VERSION 2.6.0)
if(COMMAND cmake_policy)
	if(POLICY CMP0003)
		cmake_policy(SET CMP0003 NEW)
	endif()
endif()
# The name of our project is "DirectXExample".  CMakeLists files in this project can
# refer to the root source directory of the project as ${DirectXExample_SOURCE_DIR} and
# to the root binary directory of the project as ${DirectXExample_BINARY_DIR}.
project(DirectXExample)

# Create a library called "DirectXExample" which includes the source files.
# The extension is already found.  Any number of sources could be listed here.

set(DirectXExample_SRCS "${DirectXExample_SOURCE_DIR}/../src/main.cpp")

include_directories(${DirectXExample_SOURCE_DIR}/../src)

set(requiredLibs)

set(CMAKE_MODULE_PATH
	${DirectXExample_SOURCE_DIR}/../../../build/modules)

#H3DUtil
find_package(H3DUtil REQUIRED)

if(H3DUTIL_FOUND)
	include_directories(${H3DUTIL_INCLUDE_DIR})
	set(requiredLibs ${requiredLibs} ${H3DUTIL_LIBRARIES})
endif()

#HAPI
find_package(HAPI REQUIRED)

if(HAPI_FOUND)
	include_directories(${HAPI_INCLUDE_DIR})
	set(requiredLibs ${requiredLibs} ${HAPI_LIBRARIES})
endif()

find_package(DirectX REQUIRED)
if(DirectX_FOUND)
	include_directories(${DirectX_INCLUDE_DIR})
	set(requiredLibs ${requiredLibs} ${DirectX_LIBRARIES})
endif()

add_executable(DirectXExample WIN32 ${DirectXExample_SRCS})

# make the name of debug libraries end in _d.
set_target_properties(DirectXExample PROPERTIES DEBUG_POSTFIX "_d")

target_link_libraries(DirectXExample ${requiredLibs})

# set the install directory to the H3D directory on Windows
if(WIN32)
	if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
		set(CMAKE_INSTALL_PREFIX
			${DirectXExample_SOURCE_DIR}/../..
			CACHE
			PATH
			"Install path prefix, prepended onto install directories."
			FORCE)
	endif()
endif()

install(TARGETS
	DirectXExample
	LIBRARY
	DESTINATION
	lib
	RUNTIME
	DESTINATION
	bin)
