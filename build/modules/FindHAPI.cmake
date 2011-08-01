# - Find HAPI
# Find the native HAPI headers and libraries.
#
#  HAPI_INCLUDE_DIR -  where to find HAPI.h, etc.
#  HAPI_LIBRARIES    - List of libraries when using HAPI.
#  HAPI_FOUND        - True if HAPI found.

get_filename_component(module_file_path ${CMAKE_CURRENT_LIST_FILE} PATH)

# Look for the header file.
find_path(HAPI_INCLUDE_DIR
	NAMES
	HAPI/HAPI.h
	PATHS
	$ENV{H3D_ROOT}/../HAPI/include
	../../HAPI/include
	${module_file_path}/../../../HAPI/include
	DOC
	"Path in which the file HAPI/HAPI.h is located.")
mark_as_advanced(HAPI_INCLUDE_DIR)


# Look for the library.
if(MSVC70 OR MSVC71)
	set(HAPI_NAME HAPI_vc7)
elseif(MSVC80)
	set(HAPI_NAME HAPI_vc8)
elseif(MSVC90)
	set(HAPI_NAME HAPI_vc9)
elseif(MSVC10)
	set(HAPI_NAME HAPI_vc10)
else()
	set(HAPI_NAME HAPI)
endif()

find_library(HAPI_LIBRARY
	NAMES
	${HAPI_NAME}
	PATHS
	$ENV{H3D_ROOT}/../lib
	../../lib
	${module_file_path}/../../../lib
	DOC
	"Path to ${HAPI_NAME} library.")

find_library(HAPI_DEBUG_LIBRARY
	NAMES
	${HAPI_NAME}_d
	PATHS
	$ENV{H3D_ROOT}/../lib
	../../lib
	${module_file_path}/../../../lib
	DOC
	"Path to ${HAPI_NAME}_d library.")
mark_as_advanced(HAPI_LIBRARY)
mark_as_advanced(HAPI_DEBUG_LIBRARY)

if(HAPI_LIBRARY OR HAPI_DEBUG_LIBRARY)
	set(HAVE_HAPI_LIBRARY 1)
else()
	set(HAVE_HAPI_LIBRARY 0)
endif()

# Copy the results to the output variables.
if(HAPI_INCLUDE_DIR AND HAVE_HAPI_LIBRARY)
	set(HAPI_FOUND 1)
	if(HAPI_LIBRARY)
		set(HAPI_LIBRARIES ${HAPI_LIBRARIES} optimized ${HAPI_LIBRARY})
	else()
		set(HAPI_LIBRARIES ${HAPI_LIBRARIES} optimized ${HAPI_NAME})
		message(STATUS
			"HAPI release libraries not found. Release build might not work.")
	endif()

	if(HAPI_DEBUG_LIBRARY)
		set(HAPI_LIBRARIES ${HAPI_LIBRARIES} debug ${HAPI_DEBUG_LIBRARY})
	else()
		set(HAPI_LIBRARIES ${HAPI_LIBRARIES} debug ${HAPI_NAME}_d)
		message(STATUS
			"HAPI debug libraries not found. Debug build might not work.")
	endif()

	set(HAPI_INCLUDE_DIR ${HAPI_INCLUDE_DIR})
	set(HAPI_LIBRARIES ${HAPI_LIBRARIES})
else()
	set(HAPI_FOUND 0)
	set(HAPI_LIBRARIES)
	set(HAPI_INCLUDE_DIR)
endif()

# Report the results.
if(NOT HAPI_FOUND)
	set(HAPI_DIR_MESSAGE
		"HAPI was not found. Make sure HAPI_LIBRARY ( and/or HAPI_DEBUG_LIBRARY ) and HAPI_INCLUDE_DIR are set.")
	if(HAPI_FIND_REQUIRED)
		message(FATAL_ERROR "${HAPI_DIR_MESSAGE}")
	elseif(NOT HAPI_FIND_QUIETLY)
		message(STATUS "${HAPI_DIR_MESSAGE}")
	endif()
endif()
