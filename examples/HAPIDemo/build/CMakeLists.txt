cmake_minimum_required(VERSION 2.6.0)
if(COMMAND cmake_policy)
	if(POLICY CMP0003)
		cmake_policy(SET CMP0003 NEW)
	endif()
endif()
# The name of our project is "HAPIDemo".  CMakeLists files in this project can
# refer to the root source directory of the project as ${HAPIDemo_SOURCE_DIR} and
# to the root binary directory of the project as ${HAPIDemo_BINARY_DIR}.
project(HAPIDemo)

# Create a library called "Hello" which include sourcefiles.
# The extension is already found.  Any number of sources could be listed here.

set(HAPIDemo_SRCS
	"${HAPIDemo_SOURCE_DIR}/../ForceFieldWidgetsPage.cpp"
	"${HAPIDemo_SOURCE_DIR}/../ForceFieldWidgetsPage.h"
	"${HAPIDemo_SOURCE_DIR}/../HAPIDemo.cpp"
	"${HAPIDemo_SOURCE_DIR}/../HAPIDemo.h"
	"${HAPIDemo_SOURCE_DIR}/../HapticShapeConstraintWidgetsPage.cpp"
	"${HAPIDemo_SOURCE_DIR}/../HapticShapeConstraintWidgetsPage.h"
	"${HAPIDemo_SOURCE_DIR}/../PositionFunctionWidgetsPage.cpp"
	"${HAPIDemo_SOURCE_DIR}/../PositionFunctionWidgetsPage.h"
	"${HAPIDemo_SOURCE_DIR}/../SpringWidgetsPage.cpp"
	"${HAPIDemo_SOURCE_DIR}/../SpringWidgetsPage.h"
	"${HAPIDemo_SOURCE_DIR}/../TimeFunctionWidgetsPage.cpp"
	"${HAPIDemo_SOURCE_DIR}/../TimeFunctionWidgetsPage.h"
	"${HAPIDemo_SOURCE_DIR}/../ViscosityWidgetsPage.cpp"
	"${HAPIDemo_SOURCE_DIR}/../ViscosityWidgetsPage.h")

include_directories(${HAPIDemo_SOURCE_DIR}/..)

set(requiredLibs)

set(CMAKE_MODULE_PATH "${HAPIDemo_SOURCE_DIR}/../../../build/modules")

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

if(WIN32)
	find_package(wxWidgetsWin)
	if(wxWidgets_FOUND)
		include_directories(${wxWidgets_INCLUDE_DIR})
		set(requiredLibs ${requiredLibs} ${wxWidgets_LIBRARIES})
	endif()
endif()

if(wxWidgets_FOUND)
else()
	set(wxWidgets_USE_LIBS base core)
	find_package(wxWidgets REQUIRED)
	if(wxWidgets_FOUND)
		include(${wxWidgets_USE_FILE})
		set(requiredLibs ${requiredLibs} ${wxWidgets_LIBRARIES})
	endif()
endif()

find_package(PTHREAD REQUIRED)
if(PTHREAD_FOUND AND WIN32)
	include_directories(${PTHREAD_INCLUDE_DIR})
	set(requiredLibs ${requiredLibs} ${PTHREAD_LIBRARIES})
endif()

add_executable(HAPIDemo WIN32 MACOSX_BUNDLE ${HAPIDemo_SRCS})

# make the name of debug libraries end in _d.
set_target_properties(HAPIDemo PROPERTIES DEBUG_POSTFIX "_d")

if(MSVC70 OR MSVC71)
	set_target_properties(HAPIDemo
		PROPERTIES
		LINK_FLAGS_DEBUG
		"/NODEFAULTLIB:msvcrt")
	# Treat wchar_t as built in type.
	set_target_properties(HAPIDemo
		PROPERTIES
		COMPILE_FLAGS
		"-DWXUSINGDLL /Zc:wchar_t /Od")
elseif(MSVC80)
	# Remove some warnings about deprecated functions.
	set(HAPIDemo_COMPILE_FLAGS
		"-DWXUSINGDLL -D_CRT_SECURE_NO_DEPRECATE /Od")

	# This might be useful for visual studio 2005 users that often recompile the api.
	if(NOT DEFINED USE_VC8_MP_FLAG)
		set(USE_VC8_MP_FLAG
			"NO"
			CACHE
			BOOL
			"In visual studio 8 the MP flag exists but is not documented. Maybe it is unsafe to use. If you want to use it then set this flag to yes.")
	endif()

	if(USE_VC8_MP_FLAG)
		set(HAPIDemo_COMPILE_FLAGS "${HAPIDemo_COMPILE_FLAGS} /MP")
	endif()

	set_target_properties(HAPIDemo
		PROPERTIES
		COMPILE_FLAGS
		"${HAPIDemo_COMPILE_FLAGS}")
	# Remove link errors
	set_target_properties(HAPIDemo
		PROPERTIES
		LINK_FLAGS_DEBUG
		"/NODEFAULTLIB:msvcrt")
elseif(MSVC90)
	# remove some warnings about deprecated functions and use threaded compiling.
	set_target_properties(HAPIDemo
		PROPERTIES
		COMPILE_FLAGS
		"-DWXUSINGDLL -D_CRT_SECURE_NO_DEPRECATE /MP /Od")
	# Remove link errors
	set_target_properties(HAPIDemo
		PROPERTIES
		LINK_FLAGS_DEBUG
		"/NODEFAULTLIB:msvcrt")
elseif(MSVC10)
	# remove some warnings about deprecated functions and use threaded compiling.
	set_target_properties(HAPIDemo
		PROPERTIES
		COMPILE_FLAGS
		"-DWXUSINGDLL -D_CRT_SECURE_NO_DEPRECATE /MP")
	# Remove link errors
	set_target_properties(HAPIDemo
		PROPERTIES
		LINK_FLAGS_DEBUG
		"/NODEFAULTLIB:msvcrt")
endif()

target_link_libraries(HAPIDemo ${requiredLibs} ${optionalLibs})

# set the install directory to the H3D directory on Windows
if(WIN32)
	if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
		set(CMAKE_INSTALL_PREFIX
			${HAPIDemo_SOURCE_DIR}/../..
			CACHE
			PATH
			"Install path prefix, prepended onto install directories."
			FORCE)
	endif()
endif()

install(TARGETS
	HAPIDemo
	LIBRARY
	DESTINATION
	lib
	RUNTIME
	DESTINATION
	bin)
