#import "SDLWindow.h"

@implementation SDLWindow

- (instancetype)initWithTitle:(NSString *)title width:(NSInteger)width height:(NSInteger)height {
    self = [super init];
    if (self) {
        _title = [title copy];
        _width = width;
        _height = height;
        _window = NULL;
    }
    return self;
}

- (void)dealloc {
    [self destroy];
}

- (BOOL)create {
    if (_window != NULL) {
        return YES;
    }
    
    _window = SDL_CreateWindow([_title UTF8String],
                              SDL_WINDOWPOS_CENTERED,
                              SDL_WINDOWPOS_CENTERED,
                              (int)_width,
                              (int)_height,
                              SDL_WINDOW_SHOWN);
    
    if (_window == NULL) {
        NSLog(@"Failed to create window: %s", SDL_GetError());
        return NO;
    }
    
    return YES;
}

- (void)destroy {
    if (_window != NULL) {
        SDL_DestroyWindow(_window);
        _window = NULL;
    }
}

- (BOOL)isValid {
    return _window != NULL;
}

@end