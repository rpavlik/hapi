# - Find wxWidgets
# Find the native wxWidgets headers and libraries.
#
#  wxWidgets_INCLUDE_DIR -  where to find WxWidgets headers
#  wxWidgets_LIBRARIES    - List of libraries when using WxWidgets.
#  wxWidgets_FOUND        - True if WxWidgets found.

get_filename_component(module_file_path ${CMAKE_CURRENT_LIST_FILE} PATH)

if(CMAKE_CL_64)
	set(LIB "lib64")
else()
	set(LIB "lib32")
endif()


# Look for the header file.
find_path(wxWidgets_INCLUDE_DIR
	NAMES
	wx/wx.h
	PATHS
	$ENV{H3D_EXTERNAL_ROOT}/include
	$ENV{H3D_ROOT}/../External/include
	../../External/include
	${module_file_path}/../../../External/include
	DOC
	"Path in which the file wx/wx.h is located.")
mark_as_advanced(wxWidgets_INCLUDE_DIR)

# Look for the library.
if(MSVC70 OR MSVC71)
	find_library(wxWidgets_core_LIBRARY
		NAMES
		wxmsw28_core
		PATHS
		$ENV{H3D_EXTERNAL_ROOT}/${LIB}
		$ENV{H3D_ROOT}/../External/${LIB}
		../../External/${LIB}
		${module_file_path}/../../../External/${LIB}
		DOC
		"Path to wx core library.")

	find_library(wxWidgets_richtext_LIBRARY
		NAMES
		wxmsw28_richtext
		PATHS
		$ENV{H3D_EXTERNAL_ROOT}/${LIB}
		$ENV{H3D_ROOT}/../External/${LIB}
		../../External/${LIB}
		${module_file_path}/../../../External/${LIB}
		DOC
		"Path to wx richtext library.")

	find_library(wxWidgets_html_LIBRARY
		NAMES
		wxmsw28_html
		PATHS
		$ENV{H3D_EXTERNAL_ROOT}/${LIB}
		$ENV{H3D_ROOT}/../External/${LIB}
		../../External/${LIB}
		${module_file_path}/../../../External/${LIB}
		DOC
		"Path to wx html library.")

	find_library(wxWidgets_base_LIBRARY
		NAMES
		wxbase28
		PATHS
		$ENV{H3D_EXTERNAL_ROOT}/${LIB}
		$ENV{H3D_ROOT}/../External/${LIB}
		../../External/${LIB}
		${module_file_path}/../../../External/${LIB}
		DOC
		"Path to wx base library.")
	if(WXWINDOWS_USE_GL)
		find_library(wxWidgets_gl_LIBRARY
			NAMES
			wxmsw28_gl
			PATHS
			$ENV{H3D_EXTERNAL_ROOT}/${LIB}
			$ENV{H3D_ROOT}/../External/${LIB}
			../../External/${LIB}
			${module_file_path}/../../../External/${LIB}
			DOC
			"Path to wx gl library.")

		find_library(wxWidgets_adv_LIBRARY
			NAMES
			wxmsw28_adv
			PATHS
			$ENV{H3D_EXTERNAL_ROOT}/${LIB}
			$ENV{H3D_ROOT}/../External/${LIB}
			../../External/${LIB}
			${module_file_path}/../../../External/${LIB}
			DOC
			"Path to wx adv library.")
	endif()
else()
	find_library(wxWidgets_core_LIBRARY
		NAMES
		wxmsw28_core
		PATHS
		$ENV{H3D_EXTERNAL_ROOT}/${LIB}
		$ENV{H3D_ROOT}/../External/${LIB}
		../../External/${LIB}
		${module_file_path}/../../../External/${LIB}
		DOC
		"Path to wx core library.")

	find_library(wxWidgets_richtext_LIBRARY
		NAMES
		wxmsw28_richtext
		PATHS
		$ENV{H3D_EXTERNAL_ROOT}/${LIB}
		$ENV{H3D_ROOT}/../External/${LIB}
		../../External/${LIB}
		${module_file_path}/../../../External/${LIB}
		DOC
		"Path to wx richtext library.")

	find_library(wxWidgets_html_LIBRARY
		NAMES
		wxmsw28_html
		PATHS
		$ENV{H3D_EXTERNAL_ROOT}/${LIB}
		$ENV{H3D_ROOT}/../External/${LIB}
		../../External/${LIB}
		${module_file_path}/../../../External/${LIB}
		DOC
		"Path to wx html library.")

	find_library(wxWidgets_base_LIBRARY
		NAMES
		wxbase28
		PATHS
		$ENV{H3D_EXTERNAL_ROOT}/${LIB}
		$ENV{H3D_ROOT}/../External/${LIB}
		../../External/${LIB}
		${module_file_path}/../../../External/${LIB}
		DOC
		"Path to wx base library.")
	if(WXWINDOWS_USE_GL)
		find_library(wxWidgets_gl_LIBRARY
			NAMES
			wxmsw28_gl
			PATHS
			$ENV{H3D_EXTERNAL_ROOT}/${LIB}
			$ENV{H3D_ROOT}/../External/${LIB}
			../../External/${LIB}
			${module_file_path}/../../../External/${LIB}
			DOC
			"Path to wx gl library.")

		find_library(wxWidgets_adv_LIBRARY
			NAMES
			wxmsw28_adv
			PATHS
			$ENV{H3D_EXTERNAL_ROOT}/${LIB}
			$ENV{H3D_ROOT}/../External/${LIB}
			../../External/${LIB}
			${module_file_path}/../../../External/${LIB}
			DOC
			"Path to wx adv library.")
	endif()
endif()
mark_as_advanced(wxWidgets_base_LIBRARY)
mark_as_advanced(wxWidgets_core_LIBRARY)
mark_as_advanced(wxWidgets_html_LIBRARY)
mark_as_advanced(wxWidgets_richtext_LIBRARY)
if(WXWINDOWS_USE_GL)
	mark_as_advanced(wxWidgets_gl_LIBRARY)
	mark_as_advanced(wxWidgets_adv_LIBRARY)
endif()

# Copy the results to the output variables.
if(wxWidgets_INCLUDE_DIR
	AND
	wxWidgets_core_LIBRARY
	AND
	wxWidgets_base_LIBRARY)
	if(WXWINDOWS_USE_GL)
		if(wxWidgets_gl_LIBRARY AND wxWidgets_adv_LIBRARY)
			set(wxWidgets_FOUND 1)
			set(wxWidgets_LIBRARIES
				${wxWidgets_core_LIBRARY}
				${wxWidgets_richtext_LIBRARY}
				${wxWidgets_html_LIBRARY}
				${wxWidgets_base_LIBRARY}
				${wxWidgets_gl_LIBRARY}
				${wxWidgets_adv_LIBRARY}
				comctl32
				Rpcrt4)
			set(wxWidgets_INCLUDE_DIR ${wxWidgets_INCLUDE_DIR})
		else()
			set(wxWidgets_FOUND 0)
			set(wxWidgets_LIBRARIES)
			set(wxWidgets_INCLUDE_DIR)
		endif()
	else()
		set(wxWidgets_FOUND 1)
		set(wxWidgets_LIBRARIES
			${wxWidgets_core_LIBRARY}
			${wxWidgets_richtext_LIBRARY}
			${wxWidgets_html_LIBRARY}
			${wxWidgets_base_LIBRARY}
			comctl32
			Rpcrt4)
		set(wxWidgets_INCLUDE_DIR ${wxWidgets_INCLUDE_DIR})
	endif()
else()
	set(wxWidgets_FOUND 0)
	set(wxWidgets_LIBRARIES)
	set(wxWidgets_INCLUDE_DIR)
endif()

# Report the results.
if(NOT wxWidgets_FOUND)
	set(wxWidgets_DIR_MESSAGE
		"WxWidgets was not found. Make sure wxWidgets_core_LIBRARY, wxWidgets_base_LIBRARY")
	if(WXWINDOWS_USE_GL)
		set(wxWidgets_DIR_MESSAGE
			"${wxWidgets_DIR_MESSAGE}, wxWidgets_gl_LIBRARY, wxWidgets_adv_LIBRARY")
	endif()
	set(wxWidgets_DIR_MESSAGE
		"${wxWidgets_DIR_MESSAGE} and wxWidgets_INCLUDE_DIR are set.")
	if(wxWidgets_FIND_REQUIRED)
		message(FATAL_ERROR "${wxWidgets_DIR_MESSAGE}")
	elseif(NOT wxWidgets_FIND_QUIETLY)
		message(STATUS "${wxWidgets_DIR_MESSAGE}")
	endif()
endif()
