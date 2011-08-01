# - Find ENTACTAPI
# Find the native ENTACTAPI headers and libraries.
#
#  ENTACTAPI_INCLUDE_DIR -  where to find ENTACTAPI headers
#  ENTACTAPI_LIBRARIES    - List of libraries when using ENTACTAPI.
#  ENTACTAPI_FOUND        - True if ENTACTAPI found.

get_filename_component(module_file_path ${CMAKE_CURRENT_LIST_FILE} PATH)

if(CMAKE_CL_64)
	set(LIB "lib64")
else()
	set(LIB "lib32")
endif()

# Look for the header file.
find_path(ENTACTAPI_INCLUDE_DIR
	NAMES
	EntactAPI.h
	PATHS
	$ENV{H3D_EXTERNAL_ROOT}/include
	$ENV{H3D_ROOT}/../External/include
	../../External/include
	${module_file_path}/../../../External/include
	DOC
	"Path in which the file EntactAPI.h is located.")
mark_as_advanced(ENTACTAPI_INCLUDE_DIR)


# Look for the library.
if(WIN32)
	find_library(ENTACTAPI_LIBRARY
		NAMES
		EntactAPI
		PATHS
		$ENV{H3D_EXTERNAL_ROOT}/${LIB}
		$ENV{H3D_ROOT}/../External/${LIB}
		../../External/${LIB}
		${module_file_path}/../../../External/${LIB}
		DOC
		"Path to EntactAPI.lib library.")
else()
	find_library(ENTACTAPI_LIBRARY
		NAMES
		entact
		PATHS
		$ENV{H3D_EXTERNAL_ROOT}/${LIB}
		$ENV{H3D_ROOT}/../External/${LIB}
		../../External/${LIB}
		${module_file_path}/../../../External/${LIB}
		DOC
		"Path to EntactAPI library.")

endif()
mark_as_advanced(ENTACTAPI_LIBRARY)


# Copy the results to the output variables.
if(ENTACTAPI_INCLUDE_DIR AND ENTACTAPI_LIBRARY)
	set(ENTACTAPI_FOUND 1)
	set(ENTACTAPI_LIBRARIES ${ENTACTAPI_LIBRARY})
	set(ENTACTAPI_INCLUDE_DIR ${ENTACTAPI_INCLUDE_DIR})
else()
	set(ENTACTAPI_FOUND 0)
	set(ENTACTAPI_LIBRARIES)
	set(ENTACTAPI_INCLUDE_DIR)
endif()

# Report the results.
if(NOT ENTACTAPI_FOUND)
	set(ENTACTAPI_DIR_MESSAGE
		"Entact API was not found. Make sure to set ENTACTAPI_LIBRARY")
	set(ENTACTAPI_DIR_MESSAGE
		"${ENTACTAPI_DIR_MESSAGE} and ENTACTAPI_INCLUDE_DIR. If you do not have EntactAPI library you will not be able to use the Entact haptics device.")
	if(ENTACTAPI_FIND_REQUIRED)
		message(FATAL_ERROR "${ENTACTAPI_DIR_MESSAGE}")
	elseif(NOT ENTACTAPI_FIND_QUIETLY)
		message(STATUS "${ENTACTAPI_DIR_MESSAGE}")
	endif()
endif()
