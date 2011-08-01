# - Find GLUT on windows
#
#  GLUT_INCLUDE_DIR -  where to find GLUT headers
#  GLUT_LIBRARIES    - List of libraries when using GLUT.
#  GLUT_FOUND        - True if GLUT found.

get_filename_component(module_file_path ${CMAKE_CURRENT_LIST_FILE} PATH)

if(CMAKE_CL_64)
	set(LIB "lib64")
else()
	set(LIB "lib32")
endif()

# Look for the header file.
find_path(GLUT_INCLUDE_DIR
	NAMES
	GL/glut.h
	PATHS
	$ENV{H3D_EXTERNAL_ROOT}/include
	$ENV{H3D_ROOT}/../External/include
	../../External/include
	${module_file_path}/../../../External/include
	DOC
	"Path in which the file GL/glut.h is located.")
mark_as_advanced(GLUT_INCLUDE_DIR)

# Look for the library.
find_library(GLUT_LIBRARY
	NAMES
	freeglut
	glut32
	PATHS
	$ENV{H3D_EXTERNAL_ROOT}/${LIB}
	$ENV{H3D_ROOT}/../External/${LIB}
	../../External/${LIB}
	${module_file_path}/../../../External/${LIB}
	DOC
	"Path to glut32 library.")
mark_as_advanced(GLUT_LIBRARY)

# Copy the results to the output variables.
if(GLUT_INCLUDE_DIR AND GLUT_LIBRARY)
	set(GLUT_FOUND 1)
	if(WIN32 AND PREFER_FREEGLUT_STATIC_LIBRARIES)
		set(FREEGLUT_STATIC 1)
	endif()
	set(GLUT_LIBRARIES ${GLUT_LIBRARY})
	set(GLUT_INCLUDE_DIR ${GLUT_INCLUDE_DIR})
else()
	set(GLUT_FOUND 0)
	set(GLUT_LIBRARIES)
	set(GLUT_INCLUDE_DIR)
endif()

# Report the results.
if(NOT GLUT_FOUND)
	set(GLUT_DIR_MESSAGE
		"GLUT was not found. Make sure GLUT_LIBRARY and GLUT_INCLUDE_DIR are set to where you have your glut header and lib files.")
	if(GLUTWin_FIND_REQUIRED)
		message(FATAL_ERROR "${GLUT_DIR_MESSAGE}")
	elseif(NOT GLUTWin_FIND_QUIETLY)
		message(STATUS "${GLUT_DIR_MESSAGE}")
	endif()
endif()
