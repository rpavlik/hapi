if(WIN32)
	cmake_minimum_required(VERSION 2.6.0)
endif()
project(HAPIExamples)

# Should this part only be done for Windows? It is used to avoid placing everything directly in "build" catalogue if some other catalogue is chosen.
add_subdirectory(${HAPIExamples_SOURCE_DIR}/../HAPIDemo/build HAPIDemo)

add_subdirectory(${HAPIExamples_SOURCE_DIR}/../SpringExample/build
	SpringExample)

add_subdirectory(${HAPIExamples_SOURCE_DIR}/../SurfaceExample/build
	SurfaceExample)

add_subdirectory(${HAPIExamples_SOURCE_DIR}/../FeedbackBufferCollectorExample/build
	FeedbackBufferCollectorExample)

add_subdirectory(${HAPIExamples_SOURCE_DIR}/../ThreadExamples/build
	ThreadExamples)

if(WIN32)
	set(CMAKE_MODULE_PATH ${HAPIExamples_SOURCE_DIR}/../../build/modules)
	find_package(DirectX)
	if(DirectX_FOUND)
		add_subdirectory(${HAPIExamples_SOURCE_DIR}/../DirectXExample/build
			DirectXExample)
	else()
		message(STATUS
			"DirectX headers and libraries were not found. DirectXExample will not be generated.")
	endif()
endif()

# set the install directory to the H3D directory on Windows
if(WIN32)
	set(CMAKE_INSTALL_PREFIX ${HAPIExamples_SOURCE_DIR})
endif()
