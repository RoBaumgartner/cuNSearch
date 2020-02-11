cmake_minimum_required(VERSION 3.12)
#Requires cmake 3.12 for first class cuda support with visual studio

project(cuNSearch LANGUAGES CXX CUDA)
# Visual studio solution directories.
set_property(GLOBAL PROPERTY USE_FOLDERS on)


option(CUNSEARCH_USE_DOUBLE_PRECISION "Use double precision." ON)

if(CUNSEARCH_USE_DOUBLE_PRECISION)
	message(STATUS "cuNSearch::Real = double")
else()
	message(STATUS "cuNSearch::Real = float")
endif(CUNSEARCH_USE_DOUBLE_PRECISION)

if(CUNSEARCH_USE_DOUBLE_PRECISION)
	add_compile_options(-DCUNSEARCH_USE_DOUBLE_PRECISION)
endif(CUNSEARCH_USE_DOUBLE_PRECISION)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
SET(CMAKE_DEBUG_POSTFIX "_d")

option(CUNSEARCH_INSTALL_CUH "Install .cuh headers as well as .h headers." OFF)

set (INCLUDE_HEADERS
	include/PointSet.h
	include/ActivationTable.h
	include/Common.h
	include/cuNSearch.h
)

set (CUH_INCLUDE_HEADERS
	Utils/cuda_helper.cuh
	src/GridInfo.cuh
	src/PointSetImplementation.cuh
	src/Types.cuh
)

set (HEADER_FILES
	src/cuNSearchDeviceData.cuh
	src/NotImplementedException.h
	src/cuNSearchKernels.cuh
	src/helper_linearIndex.cuh
	src/helper_mortonCode.cuh
	Utils/Timing.h
	Utils/IDFactory.h
)

set (SOURCE_FILES
	src/PointSet.cu
	src/PointSetImplementation.cu
	src/cuNSearch.cu
	src/cuNSearchDeviceData.cu
	src/cuNSearchKernels.cu
	Utils/cuda_helper.cu
	Utils/Timing.cpp
	Utils/IDFactory.cpp
)

add_library(cuNSearch STATIC
	${INCLUDE_HEADERS}
	${CUH_INCLUDE_HEADERS}
	${HEADER_FILES}
	${SOURCE_FILES}
)

target_include_directories(cuNSearch PUBLIC
	"include"
	"Utils"
	${CUDA_INCLUDE_DIRS}
)
target_link_libraries(cuNSearch PUBLIC ${CUDA_LIBRARIES})
target_compile_definitions(cuNSearch PUBLIC $<$<CONFIG:DEBUG>:DEBUG>)

install(FILES ${INCLUDE_HEADERS}
	DESTINATION include/)
if (CUNSEARCH_INSTALL_CUH)
	install(FILES ${CUH_INCLUDE_HEADERS}
		DESTINATION include/)
endif()

install(TARGETS cuNSearch
	RUNTIME DESTINATION bin
	LIBRARY DESTINATION lib
	ARCHIVE DESTINATION lib
	)

option(BUILD_DEMO "Build example of how to use this library."
		ON)
if(BUILD_DEMO)
	add_subdirectory(demo)
endif(BUILD_DEMO)


unset(USE_DOUBLE_PRECISION CACHE)
