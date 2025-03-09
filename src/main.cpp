/**
 * @file main.cpp
 * @brief Main entry point for the application
 * @author Your Name
 * @date Created on YYYY-MM-DD
 */

#include <iostream>
#include <string>
#include <vector>

/**
 * @brief Main entry point for the application
 * @param argc Number of command line arguments
 * @param argv Array of command line arguments
 * @return Exit status code
 */
int main(int argc, char* argv[]) {
  // Project name will be derived from the project folder
  std::string project_name = "project";

#ifdef PROJECT_NAME
  project_name = PROJECT_NAME;
#endif

  std::cout << "Welcome to " << project_name << "!" << std::endl;
  std::cout << "This is a general C++ project template for VSCode."
            << std::endl;

  // Process command line arguments if any
  if (argc > 1) {
    std::cout << "Command line arguments:" << std::endl;
    for (int i = 1; i < argc; ++i) {
      std::cout << "  " << i << ": " << argv[i] << std::endl;
    }
  }

  return 0;
}