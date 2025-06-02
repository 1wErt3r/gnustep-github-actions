#import "SDLRenderer.h"

@implementation SDLRenderer

- (instancetype)initWithWindow:(SDLWindow *)window {
    self = [super init];
    if (self) {
        _window = window;
        _renderer = NULL;
    }
    return self;
}

- (void)dealloc {
    [self destroy];
}

- (BOOL)create {
    if (_renderer != NULL) {
        return YES;
    }
    
    if (![_window isValid]) {
        NSLog(@"Cannot create renderer: window is not valid");
        return NO;
    }
    
    _renderer = SDL_CreateRenderer(_window.window, -1, SDL_RENDERER_ACCELERATED);
    
    if (_renderer == NULL) {
        NSLog(@"Failed to create renderer: %s", SDL_GetError());
        return NO;
    }
    
    return YES;
}

- (void)destroy {
    if (_renderer != NULL) {
        SDL_DestroyRenderer(_renderer);
        _renderer = NULL;
    }
}

- (BOOL)isValid {
    return _renderer != NULL;
}

- (void)clear {
    if ([self isValid]) {
        SDL_RenderClear(_renderer);
    }
}

- (void)present {
    if ([self isValid]) {
        SDL_RenderPresent(_renderer);
    }
}

- (void)setDrawColor:(Uint8)red green:(Uint8)green blue:(Uint8)blue alpha:(Uint8)alpha {
    if ([self isValid]) {
        SDL_SetRenderDrawColor(_renderer, red, green, blue, alpha);
    }
}

@end