cmake_minimum_required(VERSION 2.6.0)

# Make include files in paths like /usr/local/include have preference before
# files in OSX frameworks.
set(CMAKE_FIND_FRAMEWORK "LAST")
project(HAPI)

set(DEFAULT_H3DUTIL_SOURCE_DIR "${HAPI_SOURCE_DIR}/../../H3DUtil")
if(NOT H3DUTIL_SOURCE_DIR)
	set(H3DUTIL_SOURCE_DIR "${DEFAULT_H3DUTIL_SOURCE_DIR}")
endif()

if(NOT EXISTS "${H3DUTIL_SOURCE_DIR}/build/CMakeLists.txt")
	set(H3DUTIL_SOURCE_DIR
		"${H3DUTIL_SOURCE_DIR}"
		CACHE
		PATH
		"H3DUtil source directory - should contain build/CMakeLists.txt file")
	message(FATAL_ERROR
		"Cannot find H3DUtil/build/CMakeLists.txt - please set H3DUTIL_SOURCE_DIR to the H3DUtil directory!")
endif()

set(H3DUTIL_LIBRARY H3DUtil CACHE INTERNAL "" FORCE)
set(H3DUTIL_DEBUG_LIBRARY H3DUtil CACHE INTERNAL "" FORCE)
set(H3DUTIL_INCLUDE_DIR
	"${H3DUTIL_SOURCE_DIR}/include"
	CACHE
	INTERNAL
	""
	FORCE)
set(HAPI_LIBRARY HAPI CACHE INTERNAL "" FORCE)
set(HAPI_DEBUG_LIBRARY HAPI CACHE INTERNAL "" FORCE)
set(HAPI_INCLUDE_DIR
	"${HAPI_SOURCE_DIR}/../include"
	CACHE
	INTERNAL
	""
	FORCE)

# include header directory.
file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/include/HAPI/")
set(HAPI_INCLUDE_DIRS
	"${CMAKE_CURRENT_SOURCE_DIR}/../include"
	"${CMAKE_CURRENT_BINARY_DIR}/include")

# Add a cache variable GENERATE_UNITY_BUILD to have the choice of selecting
# a unity build project. Default is NO.
if(NOT DEFINED GENERATE_UNITY_BUILD)
	set(GENERATE_UNITY_BUILD
		"NO"
		CACHE
		BOOL
		"Decides if a the generated project files should build through a unity build instead of a normal build. A unity builds packs all .cpp files into a UnityBuild.cpp file and then only include this in the project. This greatly reduces build times.")
	mark_as_advanced(GENERATE_UNITY_BUILD)
endif()


# Add a cache variable GENERATE_CPACK_PROJECT to have the choice of generating a project
# for packaging HAPI. Default is NO since most people will not use this.
if(NOT DEFINED GENERATE_CPACK_PROJECT)
	set(GENERATE_CPACK_PROJECT
		"NO"
		CACHE
		BOOL
		"Decides if a cpack project should be generated. The project in the first loaded CMakeLists will configure CPack.")
	mark_as_advanced(GENERATE_CPACK_PROJECT)
endif()

# Add a cache variable PREFER_STATIC_LIBRARIES to have the choice of generating a project
# linking against static libraries if they exist. Default is NO since most people will not use this.
if(NOT DEFINED PREFER_STATIC_LIBRARIES)
	set(PREFER_STATIC_LIBRARIES
		"NO"
		CACHE
		BOOL
		"Decides if CMake should prefer static libraries to dynamic libraries when both exist.")
	mark_as_advanced(PREFER_STATIC_LIBRARIES)
endif()

if(PREFER_STATIC_LIBRARIES)
	set(CMAKE_FIND_LIBRARY_SUFFIXES .a;${CMAKE_FIND_LIBRARY_SUFFIXES})
endif()


# include H3DUtil in the build
if(WIN32)
	# Should this part only be done for Windows? It is used to avoid placing everything directly in "build" catalogue if some other catalogue is chosen.
	string(REPLACE
		"HAPI"
		"H3DUtil"
		BINARY_DIR_FOR_H3DUTIL
		${CMAKE_CURRENT_BINARY_DIR})
	string(COMPARE
		EQUAL
		${BINARY_DIR_FOR_H3DUTIL}
		${CMAKE_CURRENT_BINARY_DIR}
		SPECIAL_BINARY_DIR)
	if(SPECIAL_BINARY_DIR)
		set(BINARY_DIR_FOR_H3DUTIL ${HAPI_SOURCE_DIR}/../../H3DUtil/build)
	endif()
	add_subdirectory(${H3DUTIL_SOURCE_DIR}/build ${BINARY_DIR_FOR_H3DUTIL})
else()
	add_subdirectory(${H3DUTIL_SOURCE_DIR}/build h3dutil-build)
endif()
list(APPEND HAPI_INCLUDE_DIRS ${H3DUTIL_INCLUDE_DIRS})
include_directories(${HAPI_INCLUDE_DIRS})

set(HAPI_MAJOR_VERSION 1)
set(HAPI_MINOR_VERSION 1)
set(HAPI_BUILD_VERSION 1)

# Set here already in case a special NSIS template needs to be used by cpack.
set(CMAKE_MODULE_PATH ${HAPI_SOURCE_DIR}/modules)

# If cpack should be configured.
if(GENERATE_CPACK_PROJECT)
	set(CPACK_PACKAGE_DESCRIPTION_SUMMARY
		"HAPI. A cross platform, device independent haptics library.")
	set(CPACK_PACKAGE_VENDOR "SenseGraphics AB")
	set(CPACK_PACKAGE_CONTACT "support@sensegraphics.com")
	set(CPACK_PACKAGE_DESCRIPTION_FILE "${HAPI_SOURCE_DIR}/../ReadMe")
	set(CPACK_RESOURCE_FILE_LICENSE "${HAPI_SOURCE_DIR}/../LICENSE")
	set(CPACK_INSTALL_CMAKE_PROJECTS
		"${CMAKE_CURRENT_BINARY_DIR};HAPI;ALL;/")
	set(CPACK_PACKAGE_INSTALL_DIRECTORY "HAPI")

	# Our project depends on these debian packages for Linux.
	set(DEBIAN_PACKAGE_DEPENDS "libgl-dev, h3dutil(>=1.0.0)")

	# File patterns to ignore, common for all operating systems.
	set(HAPI_CPACK_IGNORE_PATTERNS
		/\\\\.svn/
		\\\\.obj$
		\\\\.ncb$
		\\\\.log$
		\\\\.suo$
		\\\\.zip$
		\\\\.dir/
		\\\\.user$
		\\\\.cv$
		"/Debug(.)*/"
		"/debug(.)*/"
		/Release
		/release
		/linux
		/build/win32/
		"/(build|examples)/vc(7|(8|9))"
		/osx/)

	set(CPACK_PACKAGE_VERSION_MAJOR ${HAPI_MAJOR_VERSION})
	set(CPACK_PACKAGE_VERSION_MINOR ${HAPI_MINOR_VERSION})
	set(CPACK_PACKAGE_VERSION_PATCH ${HAPI_BUILD_VERSION})

	if(WIN32 AND NOT UNIX)
		# Cached variable used by H3DAPIs GENERATE_CPACK_PROJECT to get the correct installation directories.
		set(HAPI_CPACK_INSTALLED_DIRECTORIES
			""
			CACHE
			INTERNAL
			"Installed directories of HAPI.")
		set(CPACK_PACKAGE_START_MENU_NAME "HAPI 1.1")

		set(HAPIExamples_cmake_install
			""
			CACHE
			PATH
			"Needs to be set if examples for HAPI is desired to be packed in the install. Set to location of cmake_install.cmake for the examples.")
		mark_as_advanced(HAPIExamples_cmake_install)
		if(HAPIExamples_cmake_install)
			set(CPACK_INSTALL_CMAKE_PROJECTS
				${CPACK_INSTALL_CMAKE_PROJECTS}
				"${HAPIExamples_cmake_install};Examples;ALL;/")
			find_package(wxWidgetsWin)
		endif()

		if(HAPIExamples_cmake_install OR HAPI_EXAMPLE_PROJECTS)
			set(CPACK_ADD_HAPIEXAMPLES_LINKS "ON")
		endif()

		if(NOT PREFER_STATIC_LIBRARIES)
			# Ignore static libraries.
			set(HAPI_CPACK_IGNORE_PATTERNS
				${HAPI_CPACK_IGNORE_PATTERNS}
				/freeglut_static\\\\.lib$
				/glew32_static\\\\.lib$
				"/FreeImage_static(_vc8)*(_vc9)*(_d)*\\\\.lib$")
		endif()

		# This might be cleaned up a bit after cleaning External.
		set(CPACK_IGNORE_FILES
			${HAPI_CPACK_IGNORE_PATTERNS}
			/fparser\\\\.lib$
			"/wxbase28_net(_vc8)*\\\\.lib$"
			"/wxbase28_odbc(_vc8)*\\\\.lib$"
			"/wxbase28_xml(_vc8)*\\\\.lib$"
			"/wxbase28_net(_vc8)*\\\\.lib$"
			"/wxexpat(_vc8)*\\\\.lib$"
			"/wxjpeg(_vc8)*\\\\.lib$"
			"/wxmsw28_aui(_vc8)*\\\\.lib$"
			"/wxmsw28_dbgrid(_vc8)*\\\\.lib$"
			"/wxmsw28_html(_vc8)*\\\\.lib$"
			"/wxmsw28_media(_vc8)*\\\\.lib$"
			"/wxmsw28_qa(_vc8)*\\\\.lib$"
			"/wxmsw28_richtext(_vc8)*\\\\.lib$"
			"/wxmsw28_xrc(_vc8)*\\\\.lib$"
			"/wxpng(_vc8)*\\\\.lib$"
			"/wxregex(_vc8)*\\\\.lib$"
			"/wxtiff(_vc8)*\\\\.lib$"
			"/wxzlib(_vc8)*\\\\.lib$"
			/pthreadGC2\\\\.dll$
			/pthreadGCE2\\\\.dll$
			"/pthreadVSE2\\\\.(dll|lib)$"
			/audiofile\\\\.dll$
			/cg\\\\.dll$
			/cgGL\\\\.dll$
			/ftgl_dynamic_MTD\\\\.dll$
			/libcurl\\\\.dll$
			/ogg\\\\.dll$
			/ogg_d\\\\.dll$
			/OpenAL32\\\\.dll$
			/vorbis\\\\.dll$
			/vorbisfile\\\\.dll$
			/wrap_oal\\\\.dll$
			/xerces-c_2_7\\\\.dll$
			/xerces-c_2_7D\\\\.dll$
			/xerces-c_2_8.dll\\\\.dll$
			/ALut\\\\.lib$
			/audiofile\\\\.lib$
			/cg\\\\.lib$
			/cgGL\\\\.lib$
			/freetype219MT\\\\.lib$
			/freetype235\\\\.lib$
			/ftgl_dynamic_MTD\\\\.lib$
			/ftgl_static_MTD\\\\.lib$
			/libaudiofile\\\\.lib$
			/libcurl\\\\.lib$
			/libcurl_static\\\\.lib$
			/ogg\\\\.lib$
			/ogg_static\\\\.lib$
			/OpenAL32\\\\.lib$
			/siapp\\\\.lib$
			/spwmath\\\\.lib$
			/strmbase\\\\.lib$
			/vorbis\\\\.lib$
			/vorbis_static\\\\.lib$
			/vorbisfile\\\\.lib$
			/vorbisfile_static\\\\.lib$
			/xerces-c_2\\\\.lib$
			/Xerces-c_static_2\\\\.lib$
			/include/3dconnexion/
			/include/AL/
			/include/Cg/
			/include/curl/
			/include/DirectShow/
			/include/fparser/
			/include/freetype/
			/include/FTGL/
			/include/libaudiofile/
			/include/ogg/
			/include/vorbis/
			/include/xercesc/
			/HapticAPI2
			/ftgl_static_MTD_d\\\\.lib$
			/ftgl_static_MTD_vc8\\\\.lib$
			/ftgl_static_MTD_vc8_d\\\\.lib$
			/ftgl_static_MTD_vc9\\\\.lib$
			/ftgl_static_MTD_vc9_d\\\\.lib$
			/Xerces-c_static_2_d\\\\.lib$
			/xerces-c_static_2_vc8\\\\.lib$
			/xerces-c_static_2_vc8_d\\\\.lib$
			/xerces-c_static_2_vc9\\\\.lib$
			/xerces-c_static_2_vc9_d\\\\.lib$
			/dcmdata\\\\.lib$
			/dcmimage\\\\.lib$
			/dcmimgle\\\\.lib$
			/ofstd\\\\.lib$
			/Definitions.h$
			"/DentalSimAPI\\\\.(lib)*(dll)*(h)*$"
			"/H3DAPI"
			"/H3DViewer"
			"/H3DLoad"
			"/H3D API")

		set(CPACK_INSTALLED_DIRECTORIES
			${CPACK_INSTALLED_DIRECTORIES}
			"${HAPI_SOURCE_DIR}/../../HAPI;HAPI"
			"${H3DUTIL_SOURCE_DIR};H3DUtil"
			"${HAPI_SOURCE_DIR}/../../doc2;doc"
			"${HAPI_SOURCE_DIR}/../../bin;bin"
			"${HAPI_SOURCE_DIR}/../../lib;lib")

		# Extra links to start menu if values are "ON"
		set(CPACK_ADD_HAPIDOC_LINKS "ON")

		# Extra install commands will be set to install vc8(9)_redists
		set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "\\n")

		# Add cache variable vc8(9)_redist which should be set to the install file
		# for microsoft visual studio redistributables, they can be found in the
		# installation folder for each visual studio installation.
		if(NOT DEFINED vc8_redist)
			set(vc8_redist
				CACHE
				FILEPATH
				"Set this to the exe installing microsoft visual studio redistributable for visual studio 8")
			mark_as_advanced(vc8_redist)
		endif()

		if(NOT DEFINED vc9_redist)
			set(vc9_redist
				CACHE
				FILEPATH
				"Set this to the exe installing microsoft visual studio redistributable for visual studio 9.")
			mark_as_advanced(vc9_redist)
		endif()

		if(vc8_redist)
			string(REPLACE "/" "\\\\" Temp_vc8_redist ${vc8_redist})
			get_filename_component(VC8_FILE_NAME ${vc8_redist} NAME)
			set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS
				${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
				" Set output Path\\n  SetOutPath \\\"$INSTDIR\\\\vc8\\\"\\n"
				" Code to install Visual studio redistributable\\n  File \\\"${Temp_vc8_redist}\\\"\\n"
				" Execute silent and wait\\n  ExecWait '\\\"$INSTDIR\\\\vc8\\\\${VC8_FILE_NAME}\\\"/q:a /c:\\\"msiexec /i vcredist.msi /qn\\\"' $0\\n"
				" Wait a bit for system to unlock file.\\n  Sleep 1000\\n"
				" Delete file\\n  Delete \\\"$INSTDIR\\\\vc8\\\\${VC8_FILE_NAME}\\\"\\n"
				" Reset output Path\\n  SetOutPath \\\"$INSTDIR\\\"\\n"
				" Remove folder\\n  RMDir /r \\\"$INSTDIR\\\\vc8\\\"\\n\\n")
		endif()

		if(vc9_redist)
			string(REPLACE "/" "\\\\" Temp_vc9_redist ${vc9_redist})
			get_filename_component(VC9_FILE_NAME ${vc9_redist} NAME)
			set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS
				${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
				" Set output Path\\n  SetOutPath \\\"$INSTDIR\\\\vc9\\\"\\n"
				" Code to install Visual studio redistributable\\n  File \\\"${Temp_vc9_redist}\\\"\\n"
				" Execute silent and wait\\n  ExecWait '\\\"$INSTDIR\\\\vc9\\\\${VC9_FILE_NAME}\\\"/q:a /c:\\\"msiexec /i vcredist.msi /qn /l*v %temp%\\\\vcredist_x86.log\\\"' $0\\n"
				" Wait a bit for system to unlock file.\\n  Sleep 1000\\n"
				" Delete file\\n  Delete \\\"$INSTDIR\\\\vc9\\\\${VC9_FILE_NAME}\\\"\\n"
				" Reset output Path\\n  SetOutPath \\\"$INSTDIR\\\"\\n"
				" Remove folder\\n  RMDir /r \\\"$INSTDIR\\\\vc9\\\"\\n\\n")
		endif()

		# Modify path since in the NSIS template.
		set(CPACK_NSIS_MODIFY_PATH "ON")
	else()
		set(HAPI_CPACK_IGNORE_PATTERNS ${HAPI_CPACK_IGNORE_PATTERNS} "~$")
		set(CPACK_SOURCE_IGNORE_FILES ${HAPI_CPACK_IGNORE_PATTERNS})
		set(CPACK_SOURCE_INSTALLED_DIRECTORIES
			"${HAPI_SOURCE_DIR}/../../HAPI;HAPI"
			"${H3DUTIL_SOURCE_DIR};H3DUtil")
	endif()
endif()

set(HAPI_FULL_VERSION
	${HAPI_MAJOR_VERSION}.${HAPI_MINOR_VERSION}.${HAPI_BUILD_VERSION})

# add all optional libraries to this variable, only needed for HAPI project.
set(HAPI_optionalLibs)

# add all required libraries to this variable, one for each project
set(HAPI_requiredLibs)
set(Chai3D_requiredLibs)
set(OpenHaptics_requiredLibs)

find_package(PTHREAD REQUIRED)
if(PTHREAD_FOUND)
	include_directories(${PTHREAD_INCLUDE_DIR})
	set(HAPI_requiredLibs ${HAPI_requiredLibs} ${PTHREAD_LIBRARIES})
endif()

find_package(OpenHaptics)
if(OPENHAPTICS_FOUND)
	set(HAVE_OPENHAPTICS 1)
	include_directories(${OPENHAPTICS_INCLUDE_DIR}
		../OpenHapticsRenderer/include)
	set(HAPI_optionalLibs ${HAPI_optionalLibs} ${OPENHAPTICS_LIBRARIES})
	set(OpenHaptics_requiredLibs
		${OpenHaptics_requiredLibs}
		${OPENHAPTICS_LIBRARIES})
elseif(NOT WIN32)
	include_directories(../OpenHapticsRenderer/include)
endif()

find_package(Chai3D)
if(CHAI3D_FOUND)
	set(HAVE_CHAI3D 1)
	include_directories(${CHAI3D_INCLUDE_DIR} ../Chai3DRenderer/include)
	set(Chai3D_requiredLibs ${Chai3D_requiredLibs} ${CHAI3D_LIBRARIES})

	if(NOT ${CHAI3D_VERSION} VERSION_LESS "2.0.0")
		# No need to make a better comparasion than version 2.0.0 since the
		# way we get the version number might be unreliable since the version
		# number is not updated in every file for previous releases of chai3d.
		# Note that this might also break in the future if chai3d changes their
		# version handling, then FindChai3D.cmake needs to be updated.
		set(CHAI3D_VERSION_2_0 "YES")
		# Needed because glut is needed if chai3D is version 2.0.0 or above
		if(WIN32)
			find_package(GLUTWin)
		else()
			find_package(GLUT)
		endif()

		if(GLUT_FOUND)
			include_directories(${GLUT_INCLUDE_DIR})
			set(Chai3D_requiredLibs ${Chai3D_requiredLibs} ${GLUT_LIBRARIES})
		endif()
	endif()
elseif(NOT WIN32)
	include_directories(../Chai3DRenderer/include)
endif()

find_package(DHD)
if(DHD_FOUND)
	set(HAVE_DHDAPI 1)
	include_directories(${DHD_INCLUDE_DIR})
	set(HAPI_optionalLibs ${HAPI_optionalLibs} ${DHD_LIBRARIES})
endif()

find_package(VirtuoseAPI)
if(VIRTUOSE_FOUND)
	set(HAVE_VIRTUOSEAPI 1)
	include_directories(${VIRTUOSE_INCLUDE_DIR})
	set(HAPI_optionalLibs ${HAPI_optionalLibs} ${VIRTUOSE_LIBRARIES})
endif()

find_package(EntactAPI)
if(ENTACTAPI_FOUND)
	set(HAVE_ENTACTAPI 1)
	include_directories(${ENTACTAPI_INCLUDE_DIR})
	set(HAPI_optionalLibs ${HAPI_optionalLibs} ${ENTACTAPI_LIBRARIES})
	message(STATUS ${optionalLibs})
endif()

find_package(FalconAPI)
if(FALCONAPI_FOUND)
	set(HAVE_FALCONAPI 1)
	include_directories(${FALCONAPI_INCLUDE_DIR})
	set(HAPI_optionalLibs ${HAPI_optionalLibs} ${FALCONAPI_LIBRARIES})
endif()

find_package(NiFalconAPI)
if(NIFALCONAPI_FOUND)
	set(HAVE_NIFALCONAPI 1)
	include_directories(${NIFALCONAPI_INCLUDE_DIR})
	set(HAPI_optionalLibs ${HAPI_optionalLibs} ${NIFALCONAPI_LIBRARIES})
endif()

find_package(Haptik)
if(HAPTIK_FOUND)
	set(HAVE_HAPTIK_LIBRARY 1)
	include_directories(${HAPTIK_INCLUDE_DIR})
	set(HAPI_optionalLibs ${HAPI_optionalLibs} ${HAPTIK_LIBRARIES})
endif()

find_package(SimballMedical)
if(SIMBALLMEDICAL_FOUND)
	set(HAVE_SIMBALLMEDICAL_API 1)
	include_directories(${SIMBALLMEDICAL_INCLUDE_DIR})
	set(HAPI_optionalLibs ${HAPI_optionalLibs} ${SIMBALLMEDICAL_LIBRARIES})
endif()

find_package(MLHI)
if(MLHI_FOUND)
	set(HAVE_MLHI 1)
	include_directories(${MLHI_INCLUDE_DIR})
	set(HAPI_optionalLibs ${HAPI_optionalLibs} ${MLHI_LIBRARIES})
endif()

find_package(OpenGL REQUIRED)
if(OPENGL_FOUND)
	set(HAVE_OPENGL 1)
	include_directories(${OPENGL_INCLUDE_DIR})
	set(HAPI_requiredLibs ${HAPI_requiredLibs} ${OPENGL_LIBRARIES})
endif()

# The current implementation only have support for Haptic Master on Windows.
# No use in looking for the libs/dlls on the system since the dlls for
# haptic master are run-time loaded.
if(WIN32)
	set(HAVE_HAPTIC_MASTER_API 1)
endif()

# add all sources, they are added to variables called HAPI_SRCS,
# OH_SRCS and CHAI_SRCS defined in the included file. Header files are added
# to variables named HAPI_HEADERS, OH_HEADERS and CHAIR_HEADERS.
include(${HAPI_SOURCE_DIR}/HAPISourceFiles.txt)

if(GENERATE_UNITY_BUILD)
	# Generate a unity build, by creating the UnityBuild.cpp and only including the required
	# source files.

	set(HAPI_SRCS "${HAPI_SOURCE_DIR}/../src/UnityBuild.cpp")

	set(UNITYBUILD_INCLUDES "")

	foreach(filename ${HAPI_SOURCE_FILES})
		set(UNITYBUILD_INCLUDES
			"${UNITYBUILD_INCLUDES}\n #include \"${filename}\"")
	endforeach()

	configure_file(${HAPI_SOURCE_DIR}/UnityBuild.cmake
		${HAPI_SOURCE_DIR}/../src/UnityBuild.cpp)

endif()

# add the HAPI.rc resource file if Visual Studio
if(MSVC)
	set(HAPI_SRCS ${HAPI_SRCS} ${CMAKE_CURRENT_BINARY_DIR}/HAPI.rc)
endif()

# If cpack project should be generated and windows is the system on which to generate
# a number of extra directories needs to be added. They are added to an internal cached
# variable which can be used by other cmakelists that use HAPI as subdirectory (e.g. H3DAPI).
if(GENERATE_CPACK_PROJECT)

	if(WIN32)
		if(PTHREAD_FOUND)
			set(HAPI_CPACK_INSTALLED_DIRECTORIES
				${HAPI_CPACK_INSTALLED_DIRECTORIES}
				"${PTHREAD_INCLUDE_DIR}/../../include;External/include"
				CACHE
				INTERNAL
				"Installed directories of HAPI.")
		endif()

		set(HAPI_CPACK_INSTALLED_DIRECTORIES
			${HAPI_CPACK_INSTALLED_DIRECTORIES}
			"${HAPI_SOURCE_DIR}/../../External/bin;External/bin"
			CACHE
			INTERNAL
			"Installed directories of HAPI.")
		set(HAPI_CPACK_INSTALLED_DIRECTORIES
			${HAPI_CPACK_INSTALLED_DIRECTORIES}
			"${HAPI_SOURCE_DIR}/../../External/lib;External/lib"
			CACHE
			INTERNAL
			"Installed directories of HAPI.")
		set(CPACK_INSTALLED_DIRECTORIES
			${CPACK_INSTALLED_DIRECTORIES}
			${HAPI_CPACK_INSTALLED_DIRECTORIES})
	endif()

	include(CPack)
	include(UseDebian)
	if(DEBIAN_FOUND)
		add_debian_targets(HAPI)
	endif()

endif()

if(WIN32)

	# OpenHapticsRenderer and Chai3DRenderer are compiled as separate dlls
	# on Windows
	add_library(HAPI SHARED ${HAPI_SRCS} ${HAPI_HEADERS})
	if(OPENHAPTICS_FOUND)
		if(MSVC)
			set(OH_SRCS
				${OH_SRCS}
				${CMAKE_CURRENT_BINARY_DIR}/OpenHapticsRenderer.rc)
		endif()
		add_library(OpenHapticsRenderer SHARED ${OH_SRCS} ${OH_HEADERS})
	endif()

	if(CHAI3D_FOUND)
		if(MSVC)
			set(CHAI_SRCS
				${CHAI_SRCS}
				${CMAKE_CURRENT_BINARY_DIR}/Chai3DRenderer.rc)
		endif()
		add_library(Chai3DRenderer SHARED ${CHAI_SRCS} ${CHAI_HEADERS})
	endif()

	if(MSVC)
		# make sure that HAPI.rc contains the correct svn-version
		execute_process(COMMAND
			${HAPI_SOURCE_DIR}/FindSVNVersion
			${HAPI_SOURCE_DIR}/../src/.svn/entries
			OUTPUT_VARIABLE
			HAPI_SVN_VERSION)

		# autogenerate resource files depending on the version
		configure_file(HAPI.rc.cmake ${CMAKE_CURRENT_BINARY_DIR}/HAPI.rc)

		# Add option to disable UpdateResourceFile call, ON by default if this is an svn checkout.
		# OFF if this is not an svn checkout.
		if(HAPI_SVN_VERSION EQUAL 0)
			option(CallUpdateResourceFile
				"If ON then a pre build command is added to call UpdateResourceFile. This is ON if HAPI is a subversion checkout, OFF if it is not."
				OFF)
		else()
			option(CallUpdateResourceFile
				"If ON then a pre build command is added to call UpdateResourceFile. This is ON if HAPI is a subversion checkout, OFF if it is not."
				ON)
		endif()

		if(CallUpdateResourceFile)
			add_custom_command(TARGET
				HAPI
				PRE_BUILD
				COMMAND
				${HAPI_SOURCE_DIR}/UpdateResourceFile
				ARGS
				HAPI
				${CMAKE_CURRENT_BINARY_DIR}/HAPI.rc
				${HAPI_SOURCE_DIR}/HAPI.rc.cmake
				${HAPI_MAJOR_VERSION}
				${HAPI_MINOR_VERSION}
				${HAPI_BUILD_VERSION}
				${HAPI_SOURCE_DIR}/../src/.svn/entries)
		endif()

		# make sure that HAPI.rc, OpenHapticsRenderer.rc and Chai3DRenderer.rc contains the correct svn-version
		# and autogenerate the resource files.
		if(OPENHAPTICS_FOUND)
			configure_file(OpenHapticsRenderer.rc.cmake
				${CMAKE_CURRENT_BINARY_DIR}/OpenHapticsRenderer.rc)

			if(CallUpdateResourceFile)
				add_custom_command(TARGET
					OpenHapticsRenderer
					PRE_BUILD
					COMMAND
					${HAPI_SOURCE_DIR}/UpdateResourceFile
					ARGS
					HAPI
					${CMAKE_CURRENT_BINARY_DIR}/OpenHapticsRenderer.rc
					${HAPI_SOURCE_DIR}/OpenHapticsRenderer.rc.cmake
					${HAPI_MAJOR_VERSION}
					${HAPI_MINOR_VERSION}
					${HAPI_BUILD_VERSION}
					${HAPI_SOURCE_DIR}/../src/.svn/entries)
			endif()
		endif()

		if(CHAI3D_FOUND)
			configure_file(Chai3DRenderer.rc.cmake
				${CMAKE_CURRENT_BINARY_DIR}/Chai3DRenderer.rc)

			if(CallUpdateResourceFile)
				add_custom_command(TARGET
					Chai3DRenderer
					PRE_BUILD
					COMMAND
					${HAPI_SOURCE_DIR}/UpdateResourceFile
					ARGS
					HAPI
					${CMAKE_CURRENT_BINARY_DIR}/Chai3DRenderer.rc
					${HAPI_SOURCE_DIR}/Chai3DRenderer.rc.cmake
					${HAPI_MAJOR_VERSION}
					${HAPI_MINOR_VERSION}
					${HAPI_BUILD_VERSION}
					${HAPI_SOURCE_DIR}/../src/.svn/entries)
			endif()
		endif()
	endif()

	# set the install directory to the H3D directory on Windows
	if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
		set(CMAKE_INSTALL_PREFIX
			${HAPI_SOURCE_DIR}/../..
			CACHE
			PATH
			"Install path prefix, prepended onto install directories."
			FORCE)
	endif()

	# is this only for msvc or for all windows compilers?
	set(HAPI_requiredLibs ${HAPI_requiredLibs} winmm.lib DelayImp.lib)
else()
	add_library(HAPI
		SHARED
		${HAPI_SRCS}
		${OH_SRCS}
		${CHAI_SRCS}
		${HAPI_HEADERS}
		${OH_HEADERS}
		${CHAI_HEADERS})
endif()

# Needed to link correctly on MSVC70 and MSVC71 because the dependency is not enough
# to generate correct project files with this version of CMake.
if(NOT WIN32)
	set(HAPI_requiredLibs
		${HAPI_requiredLibs}
		optimized
		H3DUtil
		debug
		H3DUtil_d)
elseif(MSVC70
	OR
	MSVC71
	OR
	${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}
	GREATER
	2.7)
	set(HAPI_requiredLibs ${HAPI_requiredLibs} H3DUtil)
endif()


# make sure symbols are exported.
set(HAPI_COMPILE_FLAGS "-DHAPI_EXPORTS")

# add the libraries needed for linking
target_link_libraries(HAPI ${HAPI_requiredLibs} ${HAPI_optionalLibs})

# make the name of debug libraries end in _d.
set_target_properties(HAPI PROPERTIES DEBUG_POSTFIX "_d")

# set the version of the library
set_target_properties(HAPI PROPERTIES VERSION ${HAPI_FULL_VERSION})

if(WIN32)

	# change the name depending on compiler to be able to tell them apart
	# since they are not compatible with each other.
	if(MSVC70 OR MSVC71)
		set_target_properties(HAPI PROPERTIES OUTPUT_NAME HAPI_vc7)
		set(HAPI_COMPILE_FLAGS "${HAPI_COMPILE_FLAGS} /Zc:wchar_t")
	elseif(MSVC80)
		set_target_properties(HAPI PROPERTIES OUTPUT_NAME HAPI_vc8)

		# This might be useful for visual studio 2005 users that often recompile the api.
		if(NOT DEFINED USE_VC8_MP_FLAG)
			set(USE_VC8_MP_FLAG
				"NO"
				CACHE
				BOOL
				"In visual studio 8 the MP flag exists but is not documented. Maybe it is unsafe to use. If you want to use it then set this flag to yes.")
		endif()

		if(USE_VC8_MP_FLAG)
			set(HAPI_COMPILE_FLAGS "${HAPI_COMPILE_FLAGS} /MP")
		endif()
	elseif(MSVC90)
		set_target_properties(HAPI PROPERTIES OUTPUT_NAME HAPI_vc9)
		set(HAPI_COMPILE_FLAGS "${HAPI_COMPILE_FLAGS} /MP")
	elseif(MSVC10)
		set_target_properties(HAPI PROPERTIES OUTPUT_NAME HAPI_vc10)
		set(HAPI_COMPILE_FLAGS "${HAPI_COMPILE_FLAGS} /MP")
	endif()

	# Set properties for OpenHapticsRenderer if the project is created.
	if(OPENHAPTICS_FOUND)
		target_link_libraries(OpenHapticsRenderer
			${OpenHaptics_requiredLibs}
			${OpenHaptics_requiredLibs}
			HAPI)
		# make sure symbols are exported.
		set(OpenHapticsRenderer_COMPILE_FLAGS "-DOPENHAPTICSRENDERER_EXPORTS")

		# make the name of debug libraries end in _d.
		set_target_properties(OpenHapticsRenderer
			PROPERTIES
			DEBUG_POSTFIX
			"_d")
		# set the version of the library
		set_target_properties(OpenHapticsRenderer
			PROPERTIES
			VERSION
			${HAPI_FULL_VERSION})

		# change the name depending on compiler to be able to tell them apart
		# since they are not compatible with each other.
		if(MSVC70 OR MSVC71)
			set_target_properties(OpenHapticsRenderer
				PROPERTIES
				OUTPUT_NAME
				OpenHapticsRenderer_vc7)
		elseif(MSVC80)
			set_target_properties(OpenHapticsRenderer
				PROPERTIES
				OUTPUT_NAME
				OpenHapticsRenderer_vc8)
		elseif(MSVC90)
			set_target_properties(OpenHapticsRenderer
				PROPERTIES
				OUTPUT_NAME
				OpenHapticsRenderer_vc9)
			set(OpenHapticsRenderer_COMPILE_FLAGS
				"${OpenHapticsRenderer_COMPILE_FLAGS} /MP -D_CRT_SECURE_NO_DEPRECATE")
		elseif(MSVC10)
			set_target_properties(OpenHapticsRenderer
				PROPERTIES
				OUTPUT_NAME
				OpenHapticsRenderer_vc10)
			set(OpenHapticsRenderer_COMPILE_FLAGS
				"${OpenHapticsRenderer_COMPILE_FLAGS} /MP -D_CRT_SECURE_NO_DEPRECATE")
		endif()

		# Set compile flags
		set_target_properties(OpenHapticsRenderer
			PROPERTIES
			COMPILE_FLAGS
			"${OpenHapticsRenderer_COMPILE_FLAGS}")

		# Set link flags
		set_target_properties(OpenHapticsRenderer
			HAPI
			PROPERTIES
			LINK_FLAGS
			"/DELAYLOAD:\"HD.dll\"")

		# When using OpenHaptics HAPI also need to delayload HD.dll.
		set(HAPI_LINK_FLAGS "${HAPI_LINK_FLAGS} /DELAYLOAD:\"HD.dll\"")
	endif()

	# Set properties for Chai3DRenderer if the project is created.
	if(CHAI3D_FOUND)
		target_link_libraries(Chai3DRenderer
			${Chai3D_requiredLibs}
			${Chai3D_requiredLibs}
			HAPI)
		# make sure symbols are exported.
		set_target_properties(Chai3DRenderer
			PROPERTIES
			COMPILE_FLAGS
			"-DCHAI3DRENDERER_EXPORTS")
		# make the name of debug libraries end in _d.
		set_target_properties(Chai3DRenderer PROPERTIES DEBUG_POSTFIX "_d")
		# set the version of the library
		set_target_properties(Chai3DRenderer
			PROPERTIES
			VERSION
			${HAPI_FULL_VERSION})

		# change the name depending on compiler to be able to tell them apart
		# since they are not compatible with each other.
		if(MSVC70 OR MSVC71)
			set_target_properties(Chai3DRenderer
				PROPERTIES
				OUTPUT_NAME
				Chai3DRenderer_vc7)
		elseif(MSVC80)
			set_target_properties(Chai3DRenderer
				PROPERTIES
				OUTPUT_NAME
				Chai3DRenderer_vc8)
		elseif(MSVC90)
			set_target_properties(Chai3DRenderer
				PROPERTIES
				OUTPUT_NAME
				Chai3DRenderer_vc9)
		elseif(MSVC10)
			set_target_properties(Chai3DRenderer
				PROPERTIES
				OUTPUT_NAME
				Chai3DRenderer_vc10)
		endif()

		# Set link flags
		set_target_properties(Chai3DRenderer
			PROPERTIES
			LINK_FLAGS_DEBUG
			"/NODEFAULTLIB:msvcrt")
	endif()

	# Set link flags for HAPI
	set_target_properties(HAPI
		PROPERTIES
		LINK_FLAGS
		"${HAPI_LINK_FLAGS}
  /DELAYLOAD:\"dhd.dll\" 
  /DELAYLOAD:\"hdl.dll\"
  /DELAYLOAD:\"Haptik.Library.dll\"
  /DELAYLOAD:\"SimballMedicalHID.dll\" 
  /DELAYLOAD:\"VirtuoseDLL.dll\"")
endif()

# set compile flags for HAPI project
set_target_properties(HAPI
	PROPERTIES
	COMPILE_FLAGS
	"${HAPI_COMPILE_FLAGS}")

# autogenerate HAPI.h depending on the libraries available.
file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/include/HAPI/")
configure_file(${HAPI_SOURCE_DIR}/../include/HAPI/HAPI.cmake
	"${CMAKE_CURRENT_BINARY_DIR}/include/HAPI/HAPI.h")

# Where to install HAPI
install(TARGETS
	HAPI
	LIBRARY
	DESTINATION
	lib
	RUNTIME
	DESTINATION
	bin
	ARCHIVE
	DESTINATION
	lib)

# HAPI is dependent on H3DUtil
add_dependencies(HAPI H3DUtil)

if(WIN32)
	if(OPENHAPTICS_FOUND)
		# Where to install OpenHapticsRenderer
		install(TARGETS
			OpenHapticsRenderer
			LIBRARY
			DESTINATION
			lib
			RUNTIME
			DESTINATION
			bin
			ARCHIVE
			DESTINATION
			lib)

		# OpenHapticsRenderer is dependent on HAPI and H3DUtil
		add_dependencies(OpenHapticsRenderer HAPI)
		add_dependencies(OpenHapticsRenderer H3DUtil)
	endif()

	if(CHAI3D_FOUND)
		# Where to install Chai3DRenderer
		install(TARGETS
			Chai3DRenderer
			LIBRARY
			DESTINATION
			lib
			RUNTIME
			DESTINATION
			bin
			ARCHIVE
			DESTINATION
			lib)

		# Chai3DRenderer is dependent on HAPI and H3DUtil
		add_dependencies(Chai3DRenderer HAPI)
		add_dependencies(Chai3DRenderer H3DUtil)
	endif()
else()
	# Install header files on non-windows system (e.g. Unix).
	install(FILES
		${HAPI_HEADERS}
		${OH_HEADERS}
		${CHAI_HEADERS}
		DESTINATION
		include/HAPI)
endif()


if(NOT DEFINED HAPI_EXAMPLE_PROJECTS)
	set(HAPI_EXAMPLE_PROJECTS
		"NO"
		CACHE
		BOOL
		"If set to YES the example projects distributed with HAPI will be included in the build.")
endif()

if(HAPI_EXAMPLE_PROJECTS)
	# This is done to avoid placing everything directly in "build" catalogue if some other catalogue is chosen.
	# The version of the next line avoids: 'Policy CMP0013 is not set: Duplicate binary directories are not allowed.'
	string(REGEX
		REPLACE
		"HAPI(/build)?"
		"HAPI/examples/build"
		HAPI_EXAMPLES_BINARY_DIR
		${CMAKE_CURRENT_BINARY_DIR})
	add_subdirectory(${HAPI_SOURCE_DIR}/../examples/build examples)

	if(TARGET DirectXExample)
		add_dependencies(DirectXExample HAPI)
	endif()

	if(TARGET FeedbackBufferCollector)
		add_dependencies(FeedbackBufferCollector HAPI)
	endif()

	if(TARGET HAPIDemo)
		add_dependencies(HAPIDemo HAPI)
	endif()

	if(TARGET SpringExample)
		add_dependencies(SpringExample HAPI)
	endif()

	if(TARGET SurfaceExample)
		add_dependencies(SurfaceExample HAPI)
	endif()

	if(TARGET H3DUtil)
		if(TARGET SimpleThreadPrint)
			add_dependencies(SimpleThreadPrint H3DUtil)
		endif()
		if(TARGET SimpleThreadPrintLock)
			add_dependencies(SimpleThreadPrintLock H3DUtil)
		endif()
		if(TARGET PeriodicThreadCallbacks)
			add_dependencies(PeriodicThreadCallbacks H3DUtil)
		endif()
	else()
		if(TARGET SimpleThreadPrint)
			add_dependencies(SimpleThreadPrint HAPI)
		endif()
		if(TARGET SimpleThreadPrintLock)
			add_dependencies(SimpleThreadPrintLock HAPI)
		endif()
		if(TARGET PeriodicThreadCallbacks)
			add_dependencies(PeriodicThreadCallbacks HAPI)
		endif()
	endif()
endif()

