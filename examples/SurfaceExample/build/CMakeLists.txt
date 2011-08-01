cmake_minimum_required(VERSION 2.6.0)
# The name of our project is "SurfaceExample".  CMakeLists files in this project can
# refer to the root source directory of the project as ${SurfaceExample_SOURCE_DIR} and
# to the root binary directory of the project as ${SurfaceExample_BINARY_DIR}.
project(SurfaceExample)

# Create a library called "SurfaceExample" which includes the source file "SurfaceExample.cpp".
# The extension is already found.  Any number of sources could be listed here.

set(SurfaceExample_SRCS
	"${SurfaceExample_SOURCE_DIR}/../SurfaceDemo.cpp")

include_directories(${SurfaceExample_SOURCE_DIR}/..)

set(requiredLibs)

set(CMAKE_MODULE_PATH
	${SurfaceExample_SOURCE_DIR}/../../../build/modules)

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

add_executable(SurfaceExample ${SurfaceExample_SRCS})

# make the name of debug libraries end in _d.
set_target_properties(SurfaceExample PROPERTIES DEBUG_POSTFIX "_d")

target_link_libraries(SurfaceExample ${requiredLibs} ${optionalLibs})

# set the install directory to the H3D directory on Windows
if(WIN32)
	if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
		set(CMAKE_INSTALL_PREFIX
			${SurfaceExample_SOURCE_DIR}/../..
			CACHE
			PATH
			"Install path prefix, prepended onto install directories."
			FORCE)
	endif()
endif()

install(TARGETS
	SurfaceExample
	LIBRARY
	DESTINATION
	lib
	RUNTIME
	DESTINATION
	bin)

