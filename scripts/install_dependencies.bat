@echo off
:: Script to install project dependencies on Windows
:: Requires Chocolatey package manager

echo Installing dependencies for Windows...

:: Check if Chocolatey is installed
where choco >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Chocolatey not found. Please install Chocolatey first:
    echo https://chocolatey.org/install
    exit /b 1
)

:: Install development tools
choco install cmake --yes
choco install llvm --yes
choco install cppcheck --yes
choco install doxygen.install --yes
choco install graphviz --yes
choco install ninja --yes

:: For Google Test, it's handled via CMake's FetchContent
:: See CMakeLists.txt

:: Project-specific dependencies
:: [Replace with your project dependencies]
:: choco install boost-msvc-14.2 --yes

echo Installation complete! Please check the output for any errors.