# - Find OpenHaptics
# Find the native OPENHAPTICS headers and libraries.
#
#  OPENHAPTICS_INCLUDE_DIR -  where to find OpenHaptics.h, etc.
#  OPENHAPTICS_LIBRARIES    - List of libraries when using OpenHaptics.
#  OPENHAPTICS_FOUND        - True if OpenHaptics found.


# Look for the header file.
find_path(OPENHAPTICS_INCLUDE_DIR
	NAMES
	HL/hl.h
	HD/hd.h
	HDU/hdu.h
	PATHS
	$ENV{3DTOUCH_BASE}/include
	"/Program Files/SensAble/3DTouch/include"
	DOC
	"Path in which the files HL/hl.h, HD/hd.h and HDU/hdu.h are located.")
mark_as_advanced(OPENHAPTICS_INCLUDE_DIR)

if(CMAKE_CL_64)
	set(LIB "x64")
else()
	set(LIB "win32")
endif()

# TODO: Add conditional checking for x64 system
# Look for the library.
find_library(OPENHAPTICS_HL_LIBRARY
	NAMES
	HL
	PATHS
	$ENV{3DTOUCH_BASE}/lib
	$ENV{3DTOUCH_BASE}/lib/${LIB}
	"/Program Files/SensAble/3DTouch/lib"
	"/Program Files/SensAble/3DTouch/lib/${LIB}"
	DOC
	"Path to hl library.")	# OpenHaptics 2.0
# OpenHaptics 3.0
# OpenHaptics 2.0
# OpenHaptics 3.0

mark_as_advanced(OPENHAPTICS_HL_LIBRARY)

find_library(OPENHAPTICS_HD_LIBRARY
	NAMES
	HD
	PATHS
	$ENV{3DTOUCH_BASE}/lib
	$ENV{3DTOUCH_BASE}/lib/${LIB}
	"/Program Files/SensAble/3DTouch/lib"
	"/Program Files/SensAble/3DTouch/lib/${LIB}"
	DOC
	"Path to hd library.")	# OpenHaptics 2.0
# OpenHaptics 3.0
mark_as_advanced(OPENHAPTICS_HD_LIBRARY)

find_library(OPENHAPTICS_HDU_LIBRARY
	NAMES
	HDU
	PATHS
	$ENV{3DTOUCH_BASE}/utilities/lib
	$ENV{3DTOUCH_BASE}/utilities/lib/${LIB}/Release
	"/Program Files/SensAble/3DTouch/utilities/lib"
	"/Program Files/SensAble/3DTouch/utilities/lib/${LIB}/Release"
	DOC
	"Path to hdu library.")	# OpenHaptics 2.0
# OpenHaptics 3.0
# OpenHaptics 2.0
# OpenHaptics 3.0
mark_as_advanced(OPENHAPTICS_HDU_LIBRARY)

# Copy the results to the output variables.
if(OPENHAPTICS_INCLUDE_DIR
	AND
	OPENHAPTICS_HD_LIBRARY
	AND
	OPENHAPTICS_HL_LIBRARY
	AND
	OPENHAPTICS_HDU_LIBRARY)
	set(OPENHAPTICS_FOUND 1)
	set(OPENHAPTICS_LIBRARIES
		${OPENHAPTICS_HD_LIBRARY}
		${OPENHAPTICS_HL_LIBRARY}
		${OPENHAPTICS_HDU_LIBRARY})
	set(OPENHAPTICS_INCLUDE_DIR ${OPENHAPTICS_INCLUDE_DIR})
else()
	set(OPENHAPTICS_FOUND 0)
	set(OPENHAPTICS_LIBRARIES)
	set(OPENHAPTICS_INCLUDE_DIR)
endif()

# Report the results.
if(NOT OPENHAPTICS_FOUND)
	set(OPENHAPTICS_DIR_MESSAGE
		"OPENHAPTICS [hapi] was not found. Make sure to set OPENHAPTICS_HL_LIBRARY, OPENHAPTICS_HD_LIBRARY, OPENHAPTICS_HDU_LIBRARY and OPENHAPTICS_INCLUDE_DIR. If you do not have it you will not be able to use haptics devices from SensAble Technologies such as the Phantom.")
	if(OpenHaptics_FIND_REQUIRED)
		message(FATAL_ERROR "${OPENHAPTICS_DIR_MESSAGE}")
	elseif(NOT OpenHaptics_FIND_QUIETLY)
		message(STATUS "${OPENHAPTICS_DIR_MESSAGE}")
	endif()
endif()
