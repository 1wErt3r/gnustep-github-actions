# GNUstep GitHub Actions Example

A cross-platform Objective-C demonstration project showcasing GNUstep compatibility with automated GitHub Actions CI/CD pipelines for Linux, macOS, and Windows.

## Overview

This repository demonstrates how to build and run Objective-C applications using:
- **Native Foundation framework** on macOS
- **GNUstep** on Linux and Windows
- **GitHub Actions** for continuous integration across all platforms

The example includes a simple "Hello World" application that demonstrates various Foundation framework features including arrays, dictionaries, date handling, and string manipulation.

## Features

- Cross-platform Objective-C code with ARC (Automatic Reference Counting)
- Automated CI/CD with GitHub Actions
- GNUstep Make build system support
- Platform-specific build configurations
- Comprehensive Foundation framework usage examples
- Build artifacts uploaded for each platform

## Project Structure

```
gnustep-github-actions/
├── .github/
│   └── workflows/
│       ├── build-gnustep-ubuntu.yml    # Linux build workflow
│       ├── build-objc-macos.yml        # macOS build workflow
│       └── build-gnustep-windows.yml   # Windows build workflow
├── hello.h                             # Header file for HelloWorld class
├── hello.m                             # Implementation demonstrating Foundation features
├── GNUmakefile                         # GNUstep Make build configuration
├── LICENSE                             # GPLv3 License
└── README.md                           # This file
```

## Requirements

### macOS
- Xcode Command Line Tools or full Xcode installation
- Native Foundation framework (included with macOS)

### Linux (Ubuntu/Debian)
- clang compiler
- GNUstep development packages:
  - libobjc2
  - gnustep-make
  - gnustep-base

### Windows
- MSYS2 environment
- MinGW-w64 packages:
  - mingw-w64-x86_64-clang
  - mingw-w64-x86_64-gnustep-base
  - mingw-w64-x86_64-gnustep-make

## Building Locally

### macOS

```bash
# Using clang directly
clang -framework Foundation hello.m -o hello
./hello

# Using GNUmakefile (if GNUstep Make is installed)
make
./obj/HelloWorld
```

### Linux

```bash
# Install dependencies
sudo apt-get update
sudo apt-get install -y clang gnustep-devel

# Source GNUstep environment
. /usr/share/GNUstep/Makefiles/GNUstep.sh

# Build with GNUmakefile
make
./obj/HelloWorld

# Or compile directly
clang `gnustep-config --objc-flags` hello.m -o hello `gnustep-config --base-libs`
./hello
```

### Windows (MSYS2)

```bash
# In MSYS2 MinGW64 terminal
# Install dependencies
pacman -S mingw-w64-x86_64-clang mingw-w64-x86_64-gnustep-base mingw-w64-x86_64-gnustep-make

# Source GNUstep environment
. /mingw64/share/GNUstep/Makefiles/GNUstep.sh

# Build
make
./obj/HelloWorld.exe
```

## GitHub Actions Workflows

The project includes three GitHub Actions workflows that automatically build the project on push:

### Linux Workflow (`build-gnustep-ubuntu.yml`)
- Builds and installs libobjc2 from source
- Configures GNUstep Make with ARC support
- Builds GNUstep Base library
- Compiles and runs the example application
- Tests both direct compilation and GNUmakefile builds

### macOS Workflow (`build-objc-macos.yml`)
- Uses native macOS Foundation framework
- Builds with clang directly
- Creates distributable package with shell script runner
- Uploads build artifacts

### Windows Workflow (`build-gnustep-windows.yml`)
- Uses MSYS2 environment with pre-built GNUstep packages
- Handles Windows-specific DLL dependencies
- Creates package with batch file runner
- Tests execution in both MSYS2 and native Windows environments

## Example Output

When run successfully, the application outputs:

```
Hello, World from GNUstep!
Testing GNUstep Foundation features:
Current date: 2024-01-01 12:00:00 +0000
Message: GNUstep is working!
Array count: 3
Dictionary: {
    key = value;
    number = 42;
}
Mutable array contents: (
    "Item 0",
    "Item 1", 
    "Item 2",
    "Item 3",
    "Item 4"
)
Joined message: GNUstep on multiple platforms
```

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.
