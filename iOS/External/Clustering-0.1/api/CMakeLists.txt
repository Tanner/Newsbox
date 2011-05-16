INCLUDE_DIRECTORIES(
	${WIKICLUST_SOURCE_DIR}
)

ADD_LIBRARY(clustering SHARED
	API.cpp
	API.h
	AlgorithmData.cpp
	AlgorithmData.h
	DescId.cpp
	DescId.h
	DocCluster.cpp
	DocCluster.h
	DocId.cpp
	DocId.h
	Parameters.cpp
	Parameters.h
	Results.cpp
	Results.h
)

TARGET_LINK_LIBRARIES(clustering
	algo
	index
	tools
)

INSTALL(FILES  API.h DocCluster.h DocId.h Parameters.h Results.h DescId.h DESTINATION include)
INSTALL(TARGETS clustering
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
)
