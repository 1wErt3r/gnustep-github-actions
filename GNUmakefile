# GNUmakefile
include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME = SDL2HelloWorld

# Source files for the project
SDL2HelloWorld_OBJC_FILES = \
    SDLWindow.m \
    SDLRenderer.m \
    TextRenderer.m \
    HelloWorldApp.m \
    sdl_main.m

# Specify Objective-C standard and enable ARC
SDL2HelloWorld_OBJCFLAGS += -std=gnu11 -fobjc-arc -DGNUSTEP_WITH_DLL

# Include directories for SDL2 and SDL2_ttf
# These are typically found via pkg-config
SDL2HelloWorld_OBJCFLAGS += $(shell pkg-config --cflags sdl2 SDL2_ttf)

# Libraries to link
# GNUstep base libraries are added by tool.make
# We need to add SDL2, SDL2main (for Windows), and SDL2_ttf
ADDITIONAL_LIBS = $(shell pkg-config --libs sdl2 SDL2_ttf) -lSDL2main

SDL2HelloWorld_LIBS = $(ADDITIONAL_LIBS)

# Include header search paths for your project (if any beyond current dir)
# Example: SDL2HelloWorld_HEADER_SEARCH_PATHS = ./includes

include $(GNUSTEP_MAKEFILES)/tool.make

# Add a message to show calculated flags and libs (for debugging)
$(info GNUSTEP_OBJCFLAGS: $(GNUSTEP_OBJCFLAGS))
$(info SDL2HelloWorld_OBJCFLAGS: $(SDL2HelloWorld_OBJCFLAGS))
$(info SDL2HelloWorld_LIBS: $(SDL2HelloWorld_LIBS))
$(info ADDITIONAL_LIBS: $(ADDITIONAL_LIBS))
