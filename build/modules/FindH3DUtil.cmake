# - Find H3DUtil
# Find the native H3DUTIL headers and libraries.
#
#  H3DUTIL_INCLUDE_DIR -  where to find H3DUtil.h, etc.
#  H3DUTIL_LIBRARIES    - List of libraries when using H3DUtil.
#  H3DUTIL_FOUND        - True if H3DUtil found.

get_filename_component(module_file_path ${CMAKE_CURRENT_LIST_FILE} PATH)

# Look for the header file.
find_path(H3DUTIL_INCLUDE_DIR
	NAMES
	H3DUtil/H3DUtil.h
	PATHS
	$ENV{H3D_ROOT}/../H3DUtil/include
	../../H3DUtil/include
	${module_file_path}/../../../H3DUtil/include
	DOC
	"Path in which the file H3DUtil/H3DUtil.h is located.")
mark_as_advanced(H3DUTIL_INCLUDE_DIR)

# Look for the library.
if(MSVC70 OR MSVC71)
	set(H3DUTIL_NAME H3DUtil_vc7)
elseif(MSVC80)
	set(H3DUTIL_NAME H3DUtil_vc8)
elseif(MSVC90)
	set(H3DUTIL_NAME H3DUtil_vc9)
elseif(MSVC10)
	set(H3DUTIL_NAME H3DUtil_vc10)
else()
	set(H3DUTIL_NAME H3DUtil)
endif()

find_library(H3DUTIL_LIBRARY
	NAMES
	${H3DUTIL_NAME}
	PATHS
	$ENV{H3D_ROOT}/../lib
	../../lib
	${module_file_path}/../../../lib
	DOC
	"Path to ${H3DUTIL_NAME} library.")

find_library(H3DUTIL_DEBUG_LIBRARY
	NAMES
	${H3DUTIL_NAME}_d
	PATHS
	$ENV{H3D_ROOT}/../lib
	../../lib
	${module_file_path}/../../../lib
	DOC
	"Path to ${H3DUTIL_NAME}_d library.")

mark_as_advanced(H3DUTIL_LIBRARY)
mark_as_advanced(H3DUTIL_DEBUG_LIBRARY)

if(H3DUTIL_LIBRARY OR H3DUTIL_DEBUG_LIBRARY)
	set(HAVE_H3DUTIL_LIBRARY 1)
else()
	set(HAVE_H3DUTIL_LIBRARY 0)
endif()

# Copy the results to the output variables.
if(H3DUTIL_INCLUDE_DIR AND HAVE_H3DUTIL_LIBRARY)

	#pthread is required for using the H3DUtil library
	find_package(PTHREAD REQUIRED)
	if(PTHREAD_FOUND)
		set(H3DUTIL_INCLUDE_DIR ${H3DUTIL_INCLUDE_DIR} ${PTHREAD_INCLUDE_DIR})
		set(H3DUTIL_LIBRARIES ${PTHREAD_LIBRARIES})
	endif()

	set(H3DUTIL_FOUND 1)
	if(H3DUTIL_LIBRARY)
		set(H3DUTIL_LIBRARIES optimized ${H3DUTIL_LIBRARY})
	else()
		set(H3DUTIL_LIBRARIES optimized ${H3DUTIL_NAME})
		message(STATUS
			"H3DUtil release libraries not found. Release build might not work.")
	endif()

	if(H3DUTIL_DEBUG_LIBRARY)
		set(H3DUTIL_LIBRARIES
			${H3DUTIL_LIBRARIES}
			debug
			${H3DUTIL_DEBUG_LIBRARY})
	else()
		set(H3DUTIL_LIBRARIES ${H3DUTIL_LIBRARIES} debug ${H3DUTIL_NAME}_d)
		message(STATUS
			"H3DUtil debug libraries not found. Debug build might not work.")
	endif()

	set(H3DUTIL_INCLUDE_DIR ${H3DUTIL_INCLUDE_DIR})
	set(H3DUTIL_LIBRARIES ${H3DUTIL_LIBRARIES} ${PTHREAD_LIBRARIES})

else()
	set(H3DUTIL_FOUND 0)
	set(H3DUTIL_LIBRARIES)
	set(H3DUTIL_INCLUDE_DIR)
endif()

# Report the results.
if(NOT H3DUTIL_FOUND)
	set(H3DUTIL_DIR_MESSAGE
		"H3DUTIL was not found. Make sure H3DUTIL_LIBRARY ( and/or H3DUTIL_DEBUG_LIBRARY ) and H3DUTIL_INCLUDE_DIR are set.")
	if(H3DUtil_FIND_REQUIRED)
		message(FATAL_ERROR "${H3DUTIL_DIR_MESSAGE}")
	elseif(NOT H3DUtil_FIND_QUIETLY)
		message(STATUS "${H3DUTIL_DIR_MESSAGE}")
	endif()
endif()
