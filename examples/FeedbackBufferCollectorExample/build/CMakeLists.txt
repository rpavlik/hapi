cmake_minimum_required(VERSION 2.6.0)

# The name of our project is "FeedbackBufferCollector".  CMakeLists files in this project can
# refer to the root source directory of the project as ${FeedbackBufferCollector_SOURCE_DIR} and
# to the root binary directory of the project as ${FeedbackBufferCollector_BINARY_DIR}.
project(FeedbackBufferCollector)

# Create a library called "FeedbackBufferCollector" which includes the source files.
# The extension is already found.  Any number of sources could be listed here.

set(FeedbackBufferCollector_SRCS
	"${FeedbackBufferCollector_SOURCE_DIR}/../FeedbackBufferCollectorExample.cpp")

include_directories(${FeedbackBufferCollector_SOURCE_DIR}/..)

set(requiredLibs)

set(CMAKE_MODULE_PATH
	${FeedbackBufferCollector_SOURCE_DIR}/../../../build/modules)
if(COMMAND cmake_policy)
	if(POLICY CMP0011)
		cmake_policy(SET CMP0011 NEW)
	endif()
endif()
include(StripAndAddLibraryDirectories)

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

find_package(PTHREAD REQUIRED)
if(PTHREAD_FOUND AND WIN32)
	include_directories(${PTHREAD_INCLUDE_DIR})
	set(requiredLibs ${requiredLibs} ${PTHREAD_LIBRARIES})
endif()

find_package(OpenGL REQUIRED)
if(OPENGL_FOUND)
	set(HAVE_OPENGL 1)
	include_directories(${OPENGL_INCLUDE_DIR})
	set(requiredLibs ${requiredLibs} ${OPENGL_LIBRARIES})
endif()

if(WIN32)
	find_package(GLUTWin REQUIRED)
	if(GLUT_FOUND)
		include_directories(${GLUT_INCLUDE_DIR})
		strip_and_add_library_directories(${GLUT_LIBRARIES})
	endif()
endif()

if(GLUT_FOUND)
else()
	find_package(GLUT REQUIRED)
	if(GLUT_FOUND)
		include_directories(${GLUT_INCLUDE_DIR})
		set(requiredLibs ${requiredLibs} ${GLUT_LIBRARIES})
	endif()
endif()

add_executable(FeedbackBufferCollector ${FeedbackBufferCollector_SRCS})

# make the name of debug libraries end in _d.
set_target_properties(FeedbackBufferCollector
	PROPERTIES
	DEBUG_POSTFIX
	"_d")

target_link_libraries(FeedbackBufferCollector ${requiredLibs})

# set the install directory to the H3D directory on Windows
if(WIN32)
	if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
		set(CMAKE_INSTALL_PREFIX
			${FeedbackBufferCollector_SOURCE_DIR}/../..
			CACHE
			PATH
			"Install path prefix, prepended onto install directories."
			FORCE)
	endif()
endif()

install(TARGETS
	FeedbackBufferCollector
	LIBRARY
	DESTINATION
	lib
	RUNTIME
	DESTINATION
	bin)
