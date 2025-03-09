#!/bin/bash
# Script to install project dependencies
# Automatically detects OS and package manager

set -e  # Exit on error

# Check for admin/sudo rights
check_admin() {
  if [ "$(id -u)" != "0" ]; then
    echo "This script must be run with sudo or as root."
    exit 1
  fi
}

# Function to detect OS
detect_os() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Detect Linux distribution
    if [ -f /etc/os-release ]; then
      . /etc/os-release
      OS="linux"
      DISTRO="$ID"
    else
      OS="linux"
      DISTRO="unknown"
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    DISTRO="macos"
  elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    OS="windows"
    DISTRO="windows"
  else
    echo "Unsupported OS: $OSTYPE"
    exit 1
  fi
  
  echo "Detected OS: $OS ($DISTRO)"
}

# Function to detect package manager
detect_package_manager() {
  if [[ "$OS" == "linux" ]]; then
    if command -v apt-get &> /dev/null; then
      PKG_MANAGER="apt"
    elif command -v dnf &> /dev/null; then
      PKG_MANAGER="dnf"
    elif command -v yum &> /dev/null; then
      PKG_MANAGER="yum"
    elif command -v pacman &> /dev/null; then
      PKG_MANAGER="pacman"
    elif command -v zypper &> /dev/null; then
      PKG_MANAGER="zypper"
    else
      echo "No supported package manager found. Please install dependencies manually."
      exit 1
    fi
  elif [[ "$OS" == "macos" ]]; then
    if command -v brew &> /dev/null; then
      PKG_MANAGER="brew"
    else
      echo "Homebrew not found. Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      PKG_MANAGER="brew"
    fi
  elif [[ "$OS" == "windows" ]]; then
    if command -v choco &> /dev/null; then
      PKG_MANAGER="choco"
    else
      echo "Chocolatey not found. Please install Chocolatey first:"
      echo "https://chocolatey.org/install"
      exit 1
    fi
  fi
  
  echo "Using package manager: $PKG_MANAGER"
}

# Function to install common development tools
install_common_tools() {
  echo "Installing common development tools..."
  
  case $PKG_MANAGER in
    apt)
      sudo apt-get update
      sudo apt-get install -y git build-essential cmake ninja-build
      sudo apt-get install -y clang clang-format clang-tidy cppcheck
      sudo apt-get install -y doxygen graphviz
      # Install Google Test
      sudo apt-get install -y libgtest-dev
      cd /usr/src/gtest || exit
      sudo cmake .
      sudo make
      sudo cp lib/*.a /usr/lib
      cd - || exit
      ;;
    dnf|yum)
      sudo $PKG_MANAGER update -y
      sudo $PKG_MANAGER group install -y "Development Tools"
      sudo $PKG_MANAGER install -y git cmake ninja-build
      sudo $PKG_MANAGER install -y clang clang-tools-extra cppcheck
      sudo $PKG_MANAGER install -y doxygen graphviz
      sudo $PKG_MANAGER install -y gtest-devel
      ;;
    pacman)
      sudo pacman -Syu --noconfirm
      sudo pacman -S --noconfirm base-devel git cmake ninja
      sudo pacman -S --noconfirm clang clang-tools-extra cppcheck
      sudo pacman -S --noconfirm doxygen graphviz
      sudo pacman -S --noconfirm gtest
      ;;
    zypper)
      sudo zypper refresh
      sudo zypper install -y git cmake ninja
      sudo zypper install -y clang clang-tools cppcheck
      sudo zypper install -y doxygen graphviz
      sudo zypper install -y gtest-devel
      ;;
    brew)
      brew update
      brew install git cmake ninja
      brew install llvm  # Includes clang, clang-format, clang-tidy
      brew install cppcheck
      brew install doxygen graphviz
      brew install googletest
      ;;
    choco)
      choco install git --yes
      choco install cmake --yes
      choco install ninja --yes
      choco install llvm --yes  # Includes clang, clang-format, clang-tidy
      choco install cppcheck --yes
      choco install doxygen.install --yes
      choco install graphviz --yes
      # Google Test is handled via CMake's FetchContent (see CMakeLists.txt)
      ;;
  esac
}

# Execute installation process
detect_os
detect_package_manager
install_common_tools

# Install additional project-specific dependencies
# [Add your project-specific dependencies here]

echo "Installation complete! Please check the output for any errors."