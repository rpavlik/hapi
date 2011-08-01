# - Find FalconAPI
# Find the native FALCONAPI headers and libraries.
#
#  FALCONAPI_INCLUDE_DIR -  where to find hdl.h, etc.
#  FALCONAPI_LIBRARIES    - List of libraries when using FalconAPI.
#  FALCONAPI_FOUND        - True if FalconAPI found.


# Look for the header file.
find_path(FALCONAPI_INCLUDE_DIR
	NAMES
	hdl/hdl.h
	PATHS
	$ENV{NOVINT_FALCON_SUPPORT}/include
	"C:/Program Files/Novint/Falcon/HDAL/include"
	"C:/Program Files/Novint/HDAL_SDK_2.1.3/include"
	$ENV{NOVINT_DEVICE_SUPPORT}/include
	DOC
	"Path in which the file hdl/hdl.h is located. File is part of HDAL SDK.")

mark_as_advanced(FALCONAPI_INCLUDE_DIR)

# Look for the library.
find_library(FALCONAPI_HDL_LIBRARY
	NAMES
	hdl
	PATHS
	$ENV{NOVINT_FALCON_SUPPORT}/lib
	"C:/Program Files/Novint/Falcon/HDAL/lib"
	"C:/Program Files/Novint/HDAL_SDK_2.1.3/lib"
	$ENV{NOVINT_DEVICE_SUPPORT}/lib
	DOC
	"Path to hdl library. Library is part of HDAL SDK.")
mark_as_advanced(FALCONAPI_HDL_LIBRARY)

# Copy the results to the output variables.
if(FALCONAPI_INCLUDE_DIR AND FALCONAPI_HDL_LIBRARY)
	set(FALCONAPI_FOUND 1)
	set(FALCONAPI_LIBRARIES ${FALCONAPI_HDL_LIBRARY})
	set(FALCONAPI_INCLUDE_DIR ${FALCONAPI_INCLUDE_DIR})
else()
	set(FALCONAPI_FOUND 0)
	set(FALCONAPI_LIBRARIES)
	set(FALCONAPI_INCLUDE_DIR)
endif()

# Report the results.
if(NOT FALCONAPI_FOUND)
	set(FALCONAPI_DIR_MESSAGE
		"The Novint Falcon API(HDAL SDK) was not found. Make sure to set FALCONAPI_HDL_LIBRARY and FALCONAPI_INCLUDE_DIR. If you do not have it you will not be able to use the Novint Falcon Haptics device.")
	if(FalconAPI_FIND_REQUIRED)
		message(FATAL_ERROR "${FALCONAPI_DIR_MESSAGE}")
	elseif(NOT FalconAPI_FIND_QUIETLY)
		message(STATUS "${FALCONAPI_DIR_MESSAGE}")
	endif()
endif()
