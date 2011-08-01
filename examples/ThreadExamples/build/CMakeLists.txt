cmake_minimum_required(VERSION 2.6.0)
# This will set up three projects. These three projects are examples
# from the manual.
project (ThreadExamples)

set(SimpleThreadPrint_SRCS
	"${ThreadExamples_SOURCE_DIR}/../SimpleThreadPrint/SimpleThreadPrint.cpp")
set(SimpleThreadPrintLock_SRCS
	"${ThreadExamples_SOURCE_DIR}/../SimpleThreadPrintLock/SimpleThreadPrintLock.cpp")
set(PeriodicThreadCallbacks_SRCS
	"${ThreadExamples_SOURCE_DIR}/../PeriodicThreadCallbacks/PeriodicThreadCallbacks.cpp")

set(requiredLibs)

set(CMAKE_MODULE_PATH
	${ThreadExamples_SOURCE_DIR}/../../../build/modules)

#H3DUtil
find_package(H3DUtil REQUIRED)

if(H3DUTIL_FOUND)
	include_directories(${H3DUTIL_INCLUDE_DIR})
	set(requiredLibs ${requiredLibs} ${H3DUTIL_LIBRARIES})
endif()

find_package(PTHREAD REQUIRED)
if(PTHREAD_FOUND)
	include_directories(${PTHREAD_INCLUDE_DIR})
	set(requiredLibs ${requiredLibs} ${PTHREAD_LIBRARIES})
endif()

add_executable(SimpleThreadPrint ${SimpleThreadPrint_SRCS})
add_executable(SimpleThreadPrintLock ${SimpleThreadPrintLock_SRCS})
add_executable(PeriodicThreadCallbacks ${PeriodicThreadCallbacks_SRCS})

# make the name of debug libraries end in _d.
set_target_properties(SimpleThreadPrint PROPERTIES DEBUG_POSTFIX "_d")
set_target_properties(SimpleThreadPrintLock
	PROPERTIES
	DEBUG_POSTFIX
	"_d")
set_target_properties(PeriodicThreadCallbacks
	PROPERTIES
	DEBUG_POSTFIX
	"_d")

target_link_libraries(SimpleThreadPrint ${requiredLibs})
target_link_libraries(SimpleThreadPrintLock ${requiredLibs})
target_link_libraries(PeriodicThreadCallbacks ${requiredLibs})

# set the install directory to the H3D directory on Windows
if(WIN32)
	if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
		set(CMAKE_INSTALL_PREFIX
			${ThreadExamples_SOURCE_DIR}/../..
			CACHE
			PATH
			"Install path prefix, prepended onto install directories."
			FORCE)
	endif()
endif()

install(TARGETS
	SimpleThreadPrint
	LIBRARY
	DESTINATION
	lib
	RUNTIME
	DESTINATION
	bin)

install(TARGETS
	SimpleThreadPrintLock
	LIBRARY
	DESTINATION
	lib
	RUNTIME
	DESTINATION
	bin)

install(TARGETS
	PeriodicThreadCallbacks
	LIBRARY
	DESTINATION
	lib
	RUNTIME
	DESTINATION
	bin)

