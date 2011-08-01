# - Find DHD
# Find the native DHD headers and libraries.
#
#  DHD_INCLUDE_DIR -  where to find DHD headers
#  DHD_LIBRARIES    - List of libraries when using DHD.
#  DHD_FOUND        - True if DHD found.

get_filename_component(module_file_path ${CMAKE_CURRENT_LIST_FILE} PATH)

if(CMAKE_CL_64)
	set(LIB "lib64")
else()
	set(LIB "lib32")
endif()

# Look for the header file.
find_path(DHD_INCLUDE_DIR
	NAMES
	dhdc.h
	PATHS
	$ENV{H3D_EXTERNAL_ROOT}/include
	$ENV{H3D_EXTERNAL_ROOT}/include/DHD-API
	$ENV{H3D_ROOT}/../External/include
	$ENV{H3D_ROOT}/../External/include/DHD-API
	../../External/include
	../../External/include/DHD-API
	${module_file_path}/../../../External/include
	${module_file_path}/../../../External/include/DHD-API
	DOC
	"Path in which the file dhdc.h is located.")
mark_as_advanced(DHD_INCLUDE_DIR)


# Look for the library.
if(WIN32)
	find_library(DHD_LIBRARY
		NAMES
		dhdms
		dhdms64
		PATHS
		$ENV{H3D_EXTERNAL_ROOT}/${LIB}
		$ENV{H3D_ROOT}/../External/${LIB}
		../../External/${LIB}
		${module_file_path}/../../../External/${LIB}
		DOC
		"Path to dhdms library.")
else()
	find_library(DHD_LIBRARY
		NAMES
		dhd
		PATHS
		$ENV{H3D_EXTERNAL_ROOT}/${LIB}
		$ENV{H3D_ROOT}/../External/${LIB}
		../../External/${LIB}
		${module_file_path}/../../../External/${LIB}
		DOC
		"Path to dhd library.")

	if(UNIX)
		find_library(DHD_USB_LIBRARY NAMES usb DOC "Path to usb library.")
		find_library(DHD_PCISCAN_LIBRARY
			NAMES
			pciscan
			DOC
			"Path to pciscan library.")
		mark_as_advanced(DHD_USB_LIBRARY)
		mark_as_advanced(DHD_PCISCAN_LIBRARY)
	endif()
endif()
mark_as_advanced(DHD_LIBRARY)


# Copy the results to the output variables.
if(DHD_INCLUDE_DIR AND DHD_LIBRARY)
	set(DHD_FOUND 1)
	set(DHD_LIBRARIES ${DHD_LIBRARY})
	set(DHD_INCLUDE_DIR ${DHD_INCLUDE_DIR})
	if(UNIX)
		if(DHD_USB_LIBRARY AND DHD_PCISCAN_LIBRARY)
			set(DHD_LIBRARIES
				${DHD_LIBRARIES}
				${DHD_USB_LIBRARY}
				${DHD_PCISCAN_LIBRARY})
		else()
			set(DHD_FOUND 0)
			set(DHD_LIBRARIES)
			set(DHD_INCLUDE_DIR)
		endif()
	endif()
else()
	set(DHD_FOUND 0)
	set(DHD_LIBRARIES)
	set(DHD_INCLUDE_DIR)
endif()

# Report the results.
if(NOT DHD_FOUND)
	set(DHD_DIR_MESSAGE "DHD was not found. Make sure to set DHD_LIBRARY")
	if(UNIX)
		set(DHD_DIR_MESSAGE
			"${DHD_DIR_MESSAGE}, DHD_USB_LIBRARY, DHD_PCISCAN_LIBRARY")
	endif()
	set(DHD_DIR_MESSAGE
		"${DHD_DIR_MESSAGE} and DHD_INCLUDE_DIR. If you do not have DHD library you will not be able to use the Omega or Delta haptics devices from ForceDimension.")
	if(DHD_FIND_REQUIRED)
		message(FATAL_ERROR "${DHD_DIR_MESSAGE}")
	elseif(NOT DHD_FIND_QUIETLY)
		message(STATUS "${DHD_DIR_MESSAGE}")
	endif()
endif()
