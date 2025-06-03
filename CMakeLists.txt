cmake_minimum_required(VERSION 3.16)

#--------------------------------------------------------------------
# 1.  Force Clang everywhere that is not macOS (which already uses it)
#--------------------------------------------------------------------
if(NOT APPLE)
    find_program(CLANG_EXECUTABLE clang REQUIRED)
    set(CMAKE_C_COMPILER        ${CLANG_EXECUTABLE})
    set(CMAKE_CXX_COMPILER      clang++)
    set(CMAKE_OBJC_COMPILER     ${CLANG_EXECUTABLE})
endif()

project(SDL2HelloWorld LANGUAGES C OBJC)

#--------------------------------------------------------------------
# 2.  Common compiler settings
#--------------------------------------------------------------------
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Enable ARC and tell Clang to use the modern GNUstep runtime.
# libobjc2 ≥ v2.2.0 identifies itself as “gnustep-2.1”; 2.0 also works.
set(CMAKE_OBJC_FLAGS "${CMAKE_OBJC_FLAGS} -fobjc-arc -fobjc-runtime=gnustep-2.1")

#--------------------------------------------------------------------
# 3.  Source & header lists
#--------------------------------------------------------------------
set(SOURCES
    SDLWindow.m
    SDLRenderer.m
    TextRenderer.m
    HelloWorldApp.m
    sdl_main.m
)

set(HEADERS
    SDLWindow.h
    SDLRenderer.h
    TextRenderer.h
    HelloWorldApp.h
    assets/font.h           # generated bitmap-font header
)

#--------------------------------------------------------------------
# 4.  Platform-specific blocks
#--------------------------------------------------------------------
if(APPLE)
    # -------- macOS: native Foundation + Homebrew SDL2 --------
    find_library(FOUNDATION_FRAMEWORK Foundation)

    find_package(PkgConfig REQUIRED)
    pkg_check_modules(SDL2      REQUIRED sdl2)
    pkg_check_modules(SDL2_TTF  REQUIRED SDL2_ttf)

    add_executable(${PROJECT_NAME} MACOSX_BUNDLE ${SOURCES} ${HEADERS})

    set_target_properties(${PROJECT_NAME} PROPERTIES
        MACOSX_BUNDLE_GUI_IDENTIFIER "org.gnustep.SDL2HelloWorld"
        MACOSX_BUNDLE_BUNDLE_NAME    "SDL2 Hello World"
        MACOSX_BUNDLE_BUNDLE_VERSION "1.0"
        MACOSX_BUNDLE_SHORT_VERSION_STRING "1.0"
        XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC YES
    )

    target_compile_options(${PROJECT_NAME} PRIVATE
        -fobjc-arc
        ${SDL2_CFLAGS_OTHER}
        ${SDL2_TTF_CFLAGS_OTHER}
    )
    target_include_directories(${PROJECT_NAME} PRIVATE
        ${SDL2_INCLUDE_DIRS}
        ${SDL2_TTF_INCLUDE_DIRS}
    )
    target_link_directories(${PROJECT_NAME} PRIVATE
        ${SDL2_LIBRARY_DIRS}
        ${SDL2_TTF_LIBRARY_DIRS}
    )
    target_link_libraries(${PROJECT_NAME}
        ${FOUNDATION_FRAMEWORK}
    )
    target_link_options(${PROJECT_NAME} PRIVATE
        ${SDL2_LDFLAGS}
        ${SDL2_TTF_LDFLAGS}
    )

elseif(WIN32 OR MINGW)
    # -------- Windows / MSYS2-MinGW64: libobjc2 + GNUstep --------
    find_program(GNUSTEP_CONFIG gnustep-config REQUIRED)

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

    find_package(PkgConfig REQUIRED)
    pkg_check_modules(SDL2      REQUIRED sdl2)
    pkg_check_modules(SDL2_TTF  REQUIRED SDL2_ttf)

    # SDL2main is required on Windows
    find_library(SDL2MAIN_LIBRARY SDL2main
        HINTS /mingw64/lib /usr/lib ${CMAKE_INSTALL_PREFIX}/lib
        REQUIRED
    )

    add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS})

    # --- compile flags -------------------------------------------------------
    separate_arguments(GNUSTEP_OBJC_FLAGS_LIST UNIX_COMMAND "${GNUSTEP_OBJC_FLAGS}")
    target_compile_options(${PROJECT_NAME} PRIVATE
        ${GNUSTEP_OBJC_FLAGS_LIST}
        -fobjc-arc
    )

    target_include_directories(${PROJECT_NAME} PRIVATE
        ${SDL2_INCLUDE_DIRS}
        ${SDL2_TTF_INCLUDE_DIRS}
    )

    # --- link flags / libraries ---------------------------------------------
    separate_arguments(GNUSTEP_BASE_LIBS_LIST UNIX_COMMAND "${GNUSTEP_BASE_LIBS}")

    target_link_libraries(${PROJECT_NAME}
        ${SDL2MAIN_LIBRARY}
        ${SDL2_LIBRARIES}
        ${SDL2_TTF_LIBRARIES}
        objc                         # <-- pulls in libobjc2
        ${GNUSTEP_BASE_LIBS_LIST}
    )

else()
    # -------- Linux / other Unix with GNUstep --------
    find_program(GNUSTEP_CONFIG gnustep-config REQUIRED)

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

    find_package(PkgConfig REQUIRED)
    pkg_check_modules(SDL2      REQUIRED sdl2)
    pkg_check_modules(SDL2_TTF  REQUIRED SDL2_ttf)

    add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS})

    separate_arguments(GNUSTEP_OBJC_FLAGS_LIST UNIX_COMMAND "${GNUSTEP_OBJC_FLAGS}")
    target_compile_options(${PROJECT_NAME} PRIVATE
        ${GNUSTEP_OBJC_FLAGS_LIST}
        -fobjc-arc
    )

    target_include_directories(${PROJECT_NAME} PRIVATE
        ${SDL2_INCLUDE_DIRS}
        ${SDL2_TTF_INCLUDE_DIRS}
    )

    separate_arguments(GNUSTEP_BASE_LIBS_LIST UNIX_COMMAND "${GNUSTEP_BASE_LIBS}")

    target_link_libraries(${PROJECT_NAME}
        ${SDL2_LIBRARIES}
        ${SDL2_TTF_LIBRARIES}
        ${GNUSTEP_BASE_LIBS_LIST}
    )

    target_link_options(${PROJECT_NAME} PRIVATE
        ${SDL2_LDFLAGS}
        ${SDL2_TTF_LDFLAGS}
    )
endif()

#--------------------------------------------------------------------
# 5.  Output & install rules
#--------------------------------------------------------------------
set_target_properties(${PROJECT_NAME} PROPERTIES
    OUTPUT_NAME "SDL2HelloWorld"
)

install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin        # Windows / Linux
    BUNDLE  DESTINATION .          # macOS .app
)
