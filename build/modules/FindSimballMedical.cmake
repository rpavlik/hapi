# - Find SimballMedical
# Find the native SimballMedical headers and libraries.
#
#  SIMBALLMEDICAL_INCLUDE_DIR -  where to find SimballMedicalHID.h, etc.
#  SIMBALLMEDICAL_LIBRARIES    - List of libraries when using SimballMedical.
#  SIMBALLMEDICAL_FOUND        - True if SimballMedical found.

get_filename_component(module_file_path ${CMAKE_CURRENT_LIST_FILE} PATH)

if(CMAKE_CL_64)
	set(LIB "lib64")
else()
	set(LIB "lib32")
endif()

# Look for the header file.
find_path(SIMBALLMEDICAL_INCLUDE_DIR
	NAMES
	Simball/SimballMedicalHID.h
	PATHS
	$ENV{H3D_EXTERNAL_ROOT}/include
	$ENV{H3D_ROOT}/../External/include
	../../External/include
	${module_file_path}/../../../External/include
	DOC
	"Path in which the file Simball/SimballMedicalHID.h is located.")
mark_as_advanced(SIMBALLMEDICAL_INCLUDE_DIR)

# Look for the library.
find_library(SIMBALLMEDICAL_LIBRARY
	NAMES
	SimballMedicalHID
	PATHS
	$ENV{H3D_EXTERNAL_ROOT}/${LIB}
	$ENV{H3D_ROOT}/../External/${LIB}
	../../External/${LIB}
	${module_file_path}/../../../External/${LIB}
	DOC
	"Path to SimballMedicalHID library.")
mark_as_advanced(SIMBALLMEDICAL_LIBRARY)

# Copy the results to the output variables.
if(SIMBALLMEDICAL_INCLUDE_DIR AND SIMBALLMEDICAL_LIBRARY)
	set(SIMBALLMEDICAL_FOUND 1)
	set(SIMBALLMEDICAL_LIBRARIES ${SIMBALLMEDICAL_LIBRARY})
	set(SIMBALLMEDICAL_INCLUDE_DIR ${SIMBALLMEDICAL_INCLUDE_DIR})
else()
	set(SIMBALLMEDICAL_FOUND 0)
	set(SIMBALLMEDICAL_LIBRARIES)
	set(SIMBALLMEDICAL_INCLUDE_DIR)
endif()

# Report the results.
if(NOT SIMBALLMEDICAL_FOUND)
	set(SIMBALLMEDICAL_DIR_MESSAGE
		"The SimballMedical API was not found. Make sure to set SIMBALLMEDICAL_LIBRARY and SIMBALLMEDICAL_INCLUDE_DIR. If you do not have the SimballMedicalHID library you will not be able to use the Simball device.")
	if(SimballMedical_FIND_REQUIRED)
		message(FATAL_ERROR "${SIMBALLMEDICAL_DIR_MESSAGE}")
	elseif(NOT SimballMedical_FIND_QUIETLY)
		message(STATUS "${SIMBALLMEDICAL_DIR_MESSAGE}")
	endif()
endif()
