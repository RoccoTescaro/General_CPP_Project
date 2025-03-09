@echo off
:: Script to install project dependencies on Windows
:: Automatically detects and uses available package manager

echo Detecting package manager...

:: Check for Chocolatey
where choco >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Chocolatey found. Using Chocolatey for installation.
    goto :use_chocolatey
) else (
    echo Chocolatey not found.
    echo Would you like to install Chocolatey? [Y/N]
    set /p install_choice=
    if /i "%install_choice%"=="Y" (
        goto :install_chocolatey
    ) else (
        echo Please install dependencies manually.
        exit /b 1
    )
)

:install_chocolatey
echo Installing Chocolatey...
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
if %ERRORLEVEL% neq 0 (
    echo Failed to install Chocolatey. Please install manually.
    exit /b 1
)
echo Chocolatey installed successfully.

:use_chocolatey
echo Installing development tools...

:: Install basic development tools
choco install git --yes
choco install cmake --yes
choco install ninja --yes
choco install llvm --yes
choco install cppcheck --yes
choco install doxygen.install --yes
choco install graphviz --yes

:: Project-specific dependencies
:: [Replace with your project dependencies]
:: choco install boost-msvc-14.2 --yes

echo Installation complete! Please check the output for any errors.
exit /b 0