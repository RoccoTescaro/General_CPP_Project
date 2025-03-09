#!/bin/bash
# Script to install project dependencies
# Supports: Ubuntu/Debian, macOS (with Homebrew), Windows (with Chocolatey)

set -e  # Exit on error

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
    OS="windows"
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

# Install general dependencies
install_linux_deps() {
    echo "Installing dependencies for Linux..."
    sudo apt-get update
    sudo apt-get install -y build-essential cmake
    sudo apt-get install -y clang clang-format clang-tidy cppcheck
    sudo apt-get install -y doxygen graphviz
    
    # Install Google Test
    sudo apt-get install -y libgtest-dev
    pushd /usr/src/gtest
    sudo cmake .
    sudo make
    sudo cp lib/*.a /usr/lib
    popd
    
    # Project-specific dependencies
    # [Replace with your project dependencies]
    # sudo apt-get install -y libboost-all-dev libeigen3-dev
}

install_macos_deps() {
    echo "Installing dependencies for macOS..."
    
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    brew update
    brew install cmake
    brew install llvm  # Includes clang, clang-format, clang-tidy
    brew install cppcheck
    brew install doxygen graphviz
    brew install googletest
    
    # Project-specific dependencies
    # [Replace with your project dependencies]
    # brew install boost eigen opencv nlohmann-json
}

install_windows_deps() {
    echo "Installing dependencies for Windows..."
    
    # Check if Chocolatey is installed
    if ! command -v choco &> /dev/null; then
        echo "Chocolatey not found. Please install Chocolatey first:"
        echo "https://chocolatey.org/install"
        exit 1
    fi
    
    choco install cmake --yes
    choco install llvm --yes  # Includes clang, clang-format, clang-tidy
    choco install cppcheck --yes
    choco install doxygen.install --yes
    choco install graphviz --yes
    
    # For Google Test, it's easier to use CMake's FetchContent
    # See CMakeLists.txt
    
    # Project-specific dependencies
    # [Replace with your project dependencies]
    # choco install boost-msvc-14.2 --yes
}

# Install OS-specific dependencies
case $OS in
    linux)
        install_linux_deps
        ;;
    macos)
        install_macos_deps
        ;;
    windows)
        install_windows_deps
        ;;
esac

echo "Installation complete! Please check the output for any errors."