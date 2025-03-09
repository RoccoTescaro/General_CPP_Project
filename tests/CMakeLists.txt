# Find or fetch Google Test
include(FetchContent)
FetchContent_Declare(
  googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG release-1.12.1
)

# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

# Collect all test source files
file(GLOB_RECURSE TEST_SOURCES "*.cpp")

# Create the test executable
add_executable(${PROJECT_NAME}_tests ${TEST_SOURCES})

# Link against the project library and Google Test
target_link_libraries(${PROJECT_NAME}_tests 
  PRIVATE
  ${PROJECT_NAME}_lib
  gtest
  gtest_main
)

# Add include directories
target_include_directories(${PROJECT_NAME}_tests
  PRIVATE
  ${CMAKE_SOURCE_DIR}/include
)

# Add the test to CTest
add_test(NAME ${PROJECT_NAME}_tests COMMAND ${PROJECT_NAME}_tests)

# Install rules for the test executable
install(TARGETS ${PROJECT_NAME}_tests DESTINATION bin)