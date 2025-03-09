# Collect all source files in the src directory
file(GLOB_RECURSE SOURCES "*.cpp")

# Create a library from the source files
# This makes it easier to link the same code to both the main executable and tests
add_library(${PROJECT_NAME}_lib STATIC ${SOURCES})

# Set include directories for the library
target_include_directories(${PROJECT_NAME}_lib PUBLIC 
  ${CMAKE_SOURCE_DIR}/include
)

# Set compile options for the library
target_compile_features(${PROJECT_NAME}_lib PUBLIC cxx_std_17)

# Add executable that uses the library
add_executable(${PROJECT_NAME} main.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE ${PROJECT_NAME}_lib)

# Install rules for the executable
install(TARGETS ${PROJECT_NAME} DESTINATION bin)