# Set minimum required CMake version
cmake_minimum_required(VERSION 3.15)

# Extract project name from directory name
get_filename_component(PROJECT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
string(REPLACE " " "_" PROJECT_NAME ${PROJECT_NAME})

# Define project
project(
  ${PROJECT_NAME}
  VERSION 0.1.0
  DESCRIPTION "A general-purpose C++ project"
  LANGUAGES CXX
)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Define build type if not specified
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug)
endif()

# Output directories - use platform-specific output paths
if(WIN32)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
else()
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
endif()

# Compiler options
if(MSVC)
  # MSVC compiler options
  add_compile_options(/W4 /MP)
  # Disable specific warnings that are too strict
  add_compile_options(/wd4251 /wd4275)
  # Prevent warning about unsafe functions
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
  # Uncomment for optimization in Release mode
  # set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /O2")
else()
  # GCC/Clang compiler options
  add_compile_options(-Wall -Wextra -Wpedantic)
  # Uncomment for optimization in Release mode
  # set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3")
endif()

# Include directories with platform-specific path handling
include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# Define project name as a preprocessor macro
add_compile_definitions(PROJECT_NAME="${PROJECT_NAME}")

# Add subdirectories
add_subdirectory(src)

# Enable testing
enable_testing()

# Add test subdirectory
add_subdirectory(tests)

# Documentation with Doxygen
find_package(Doxygen)
if(DOXYGEN_FOUND)
  # Handle different path conventions
  if(WIN32)
    set(DOXYGEN_IN ${CMAKE_CURRENT_SOURCE_DIR}/docs/Doxyfile.in)
  else()
    set(DOXYGEN_IN ${CMAKE_CURRENT_SOURCE_DIR}/docs/Doxyfile.in)
  endif()
  
  set(DOXYGEN_OUT ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)

  if(EXISTS ${DOXYGEN_IN})
    # Configure the Doxyfile
    configure_file(${DOXYGEN_IN} ${DOXYGEN_OUT} @ONLY)

    # Add documentation target
    add_custom_target(docs
      COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYGEN_OUT}
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      COMMENT "Generating API documentation with Doxygen"
      VERBATIM
    )
  endif()
endif()

# Install targets - use platform-specific install paths
if(WIN32)
  install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
  )

  # Install headers
  install(DIRECTORY include/
    DESTINATION include
  )
else()
  install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
  )

  # Install headers
  install(DIRECTORY include/
    DESTINATION include
  )
endif()

# Custom target for clean build
add_custom_target(clean_build
  COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target clean
  COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR}
  COMMENT "Cleaning and rebuilding the project"
)

# Package configuration
include(CPack)
set(CPACK_PACKAGE_VENDOR "Your Name")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${PROJECT_NAME} - ${PROJECT_DESCRIPTION}")
set(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})
set(CPACK_PACKAGE_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${PROJECT_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${PROJECT_VERSION_PATCH})

# Platform-specific settings
if(WIN32)
  set(CPACK_GENERATOR "ZIP;NSIS")
elseif(APPLE)
  set(CPACK_GENERATOR "DragNDrop;TGZ")
else()
  set(CPACK_GENERATOR "TGZ;DEB")
endif()

add_subdirectory(src)
add_subdirectory(tests)