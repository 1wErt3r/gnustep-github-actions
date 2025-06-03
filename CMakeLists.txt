cmake_minimum_required(VERSION 3.16)

# Prefer clang for Objective-C compilation on Linux

find_program(CLANG_EXECUTABLE clang)
if(CLANG_EXECUTABLE)
  set(CMAKE_C_COMPILER ${CLANG_EXECUTABLE})
  set(CMAKE_OBJC_COMPILER ${CLANG_EXECUTABLE})
endif()


project(SDL2HelloWorld LANGUAGES C OBJC)

# Set C standard
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Source files
set(SOURCES
  SDLWindow.m
  SDLRenderer.m
  TextRenderer.m
  HelloWorldApp.m
  sdl_main.m
)

# Header files
set(HEADERS
  SDLWindow.h
  SDLRenderer.h
  TextRenderer.h
  HelloWorldApp.h
  assets/font.h
)

# Platform-specific configuration
if(APPLE)
  # macOS - Use native Foundation framework
  find_library(FOUNDATION_FRAMEWORK Foundation)
  
  # Find SDL2 and SDL2_ttf (typically from Homebrew)
  find_package(PkgConfig REQUIRED)
  pkg_check_modules(SDL2 REQUIRED sdl2)
  pkg_check_modules(SDL2_TTF REQUIRED SDL2_ttf)
  
  # Debug output for macOS
  message(STATUS "SDL2_LIBRARY_DIRS: ${SDL2_LIBRARY_DIRS}")
  message(STATUS "SDL2_LIBRARIES: ${SDL2_LIBRARIES}")
  message(STATUS "SDL2_LDFLAGS: ${SDL2_LDFLAGS}")
  
  # Create executable
  add_executable(${PROJECT_NAME} MACOSX_BUNDLE ${SOURCES} ${HEADERS})
  
  # Set bundle properties
  set_target_properties(${PROJECT_NAME} PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER "org.gnustep.SDL2HelloWorld"
    MACOSX_BUNDLE_BUNDLE_NAME "SDL2 Hello World"
    MACOSX_BUNDLE_BUNDLE_VERSION "1.0"
    MACOSX_BUNDLE_SHORT_VERSION_STRING "1.0"
    XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC YES
  )
  
  # Enable ARC and add SDL2 compile flags
  target_compile_options(${PROJECT_NAME} PRIVATE 
    -fobjc-arc
    ${SDL2_CFLAGS_OTHER}
    ${SDL2_TTF_CFLAGS_OTHER}
  )
  
  # Include directories
  target_include_directories(${PROJECT_NAME} PRIVATE
    ${SDL2_INCLUDE_DIRS}
    ${SDL2_TTF_INCLUDE_DIRS}
  )
  
  # Link directories (important for Homebrew on macOS)
  target_link_directories(${PROJECT_NAME} PRIVATE
    ${SDL2_LIBRARY_DIRS}
    ${SDL2_TTF_LIBRARY_DIRS}
  )
  
  # Link libraries - use LDFLAGS which includes -L flags
  target_link_libraries(${PROJECT_NAME}
    ${FOUNDATION_FRAMEWORK}
  )
  
  # Add SDL2 link flags properly
  target_link_options(${PROJECT_NAME} PRIVATE
    ${SDL2_LDFLAGS}
    ${SDL2_TTF_LDFLAGS}
  )
  
elseif(WIN32 OR MINGW)
  # Windows - Use GNUstep
  
  # Ensure we're using clang on Windows
  if(NOT CMAKE_C_COMPILER_ID STREQUAL "Clang")
    message(WARNING "Compiler is not Clang. Objective-C support may be limited.")
  endif()
  
  # Find GNUstep
  find_program(GNUSTEP_CONFIG gnustep-config)
  if(NOT GNUSTEP_CONFIG)
    message(FATAL_ERROR "gnustep-config not found. Please install GNUstep.")
  endif()
  
  # Get GNUstep flags
  execute_process(
    COMMAND ${GNUSTEP_CONFIG} --objc-flags
    OUTPUT_VARIABLE GNUSTEP_OBJC_FLAGS
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  execute_process(
    COMMAND ${GNUSTEP_CONFIG} --base-libs
    OUTPUT_VARIABLE GNUSTEP_BASE_LIBS
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  
  # Find SDL2 and SDL2_ttf using pkg-config on MSYS2
  find_package(PkgConfig REQUIRED)
  pkg_check_modules(SDL2 REQUIRED sdl2)
  pkg_check_modules(SDL2_TTF REQUIRED SDL2_ttf)
  
  # Also find SDL2main which is required on Windows
  find_library(SDL2MAIN_LIBRARY SDL2main
    HINTS /mingw64/lib /usr/lib
    REQUIRED
  )
  
  # Create executable
  add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS})
  
  # Parse GNUstep flags and apply them properly
  separate_arguments(GNUSTEP_OBJC_FLAGS_LIST UNIX_COMMAND "${GNUSTEP_OBJC_FLAGS}")
  # Explicitly add GNUstep 2.0 runtime and ARC
  target_compile_options(${PROJECT_NAME} PRIVATE ${GNUSTEP_OBJC_FLAGS_LIST} -fobjc-runtime=gnustep-2.0 -fobjc-arc)
  
  # Include directories
  target_include_directories(${PROJECT_NAME} PRIVATE
    ${SDL2_INCLUDE_DIRS}
    ${SDL2_TTF_INCLUDE_DIRS}
  )
  
  # Parse GNUstep base libs
  separate_arguments(GNUSTEP_BASE_LIBS_LIST UNIX_COMMAND "${GNUSTEP_BASE_LIBS}")
  
  # Link libraries - GNUstep base libraries MUST come first
    target_link_libraries(${PROJECT_NAME}
        ${SDL2MAIN_LIBRARY}
        ${SDL2_LIBRARIES}
        ${SDL2_TTF_LIBRARIES}
        objc
        ${GNUSTEP_BASE_LIBS_LIST}
    )
  
else()
  # Linux/Unix - Use GNUstep
  
  # Find GNUstep
  find_program(GNUSTEP_CONFIG gnustep-config)
  if(NOT GNUSTEP_CONFIG)
    message(FATAL_ERROR "gnustep-config not found. Please install GNUstep.")
  endif()
  
  # Get GNUstep flags
  execute_process(
    COMMAND ${GNUSTEP_CONFIG} --objc-flags
    OUTPUT_VARIABLE GNUSTEP_OBJC_FLAGS
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  execute_process(
    COMMAND ${GNUSTEP_CONFIG} --base-libs
    OUTPUT_VARIABLE GNUSTEP_BASE_LIBS
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  
  # Find SDL2 and SDL2_ttf using pkg-config
  find_package(PkgConfig REQUIRED)
  pkg_check_modules(SDL2 REQUIRED sdl2)
  pkg_check_modules(SDL2_TTF REQUIRED SDL2_ttf)
  
  # Create executable
  add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS})
  
  # Parse GNUstep flags and apply them properly
  separate_arguments(GNUSTEP_OBJC_FLAGS_LIST UNIX_COMMAND "${GNUSTEP_OBJC_FLAGS}")
  target_compile_options(${PROJECT_NAME} PRIVATE ${GNUSTEP_OBJC_FLAGS_LIST} -fobjc-arc)
  
  # Include directories
  target_include_directories(${PROJECT_NAME} PRIVATE
    ${SDL2_INCLUDE_DIRS}
    ${SDL2_TTF_INCLUDE_DIRS}
  )
  
  # Parse GNUstep base libs
  separate_arguments(GNUSTEP_BASE_LIBS_LIST UNIX_COMMAND "${GNUSTEP_BASE_LIBS}")
  
  # Link libraries
  target_link_libraries(${PROJECT_NAME}
    ${GNUSTEP_BASE_LIBS_LIST}   # GNUstep libraries first
    ${SDL2_LIBRARIES}
    ${SDL2_TTF_LIBRARIES}
  )
  
  # Add SDL link flags
  target_link_options(${PROJECT_NAME} PRIVATE
    ${SDL2_LDFLAGS}
    ${SDL2_TTF_LDFLAGS}
  )
endif()

# Set output name
set_target_properties(${PROJECT_NAME} PROPERTIES
  OUTPUT_NAME "SDL2HelloWorld"
)

# Installation rules
install(TARGETS ${PROJECT_NAME}
  BUNDLE DESTINATION .
  RUNTIME DESTINATION bin
)
