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

# Add the test to CTest
add_test(NAME ${PROJECT_NAME}_tests COMMAND ${PROJECT_NAME}_tests)

# Install rules for the test executable (optional)
install(TARGETS ${PROJECT_NAME}_tests DESTINATION bin)