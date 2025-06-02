#import "HelloWorldApp.h"

@implementation HelloWorldApp

- (instancetype)initWithTitle:(NSString *)title width:(NSInteger)width height:(NSInteger)height {
    self = [super init];
    if (self) {
        _window = [[SDLWindow alloc] initWithTitle:title width:width height:height];
        _renderer = [[SDLRenderer alloc] initWithWindow:_window];
        _isRunning = NO;
    }
    return self;
}

- (void)dealloc {
    [self cleanup];
}

- (BOOL)initialize {
    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        NSLog(@"Failed to initialize SDL: %s", SDL_GetError());
        return NO;
    }
    
    if (TTF_Init() == -1) {
        NSLog(@"Failed to initialize SDL_ttf: %s", TTF_GetError());
        SDL_Quit();
        return NO;
    }
    
    if (![_window create]) {
        [self cleanup];
        return NO;
    }
    
    if (![_renderer create]) {
        [self cleanup];
        return NO;
    }
    
    NSString *fontPath = @"/System/Library/Fonts/Arial.ttf";
    if (![[NSFileManager defaultManager] fileExistsAtPath:fontPath]) {
        fontPath = @"/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf";
        if (![[NSFileManager defaultManager] fileExistsAtPath:fontPath]) {
            fontPath = @"/Windows/Fonts/arial.ttf";
            if (![[NSFileManager defaultManager] fileExistsAtPath:fontPath]) {
                NSLog(@"No suitable font found, using fallback");
                fontPath = nil;
            }
        }
    }
    
    if (fontPath) {
        _textRenderer = [[TextRenderer alloc] initWithRenderer:_renderer fontPath:fontPath fontSize:24];
        if (![_textRenderer loadFont]) {
            NSLog(@"Warning: Could not load font, text will not be displayed");
        }
    }
    
    return YES;
}

- (void)cleanup {
    _textRenderer = nil;
    _renderer = nil;
    _window = nil;
    
    TTF_Quit();
    SDL_Quit();
}

- (void)run {
    if (![self initialize]) {
        return;
    }
    
    _isRunning = YES;
    NSLog(@"Starting Hello World SDL2 application...");
    
    while (_isRunning) {
        [self handleEvents];
        [self update];
        [self render];
        
        SDL_Delay(16);
    }
    
    [self cleanup];
    NSLog(@"Application terminated.");
}

- (void)handleEvents {
    SDL_Event event;
    
    while (SDL_PollEvent(&event)) {
        switch (event.type) {
            case SDL_QUIT:
                _isRunning = NO;
                break;
            case SDL_KEYDOWN:
                if (event.key.keysym.sym == SDLK_ESCAPE) {
                    _isRunning = NO;
                }
                break;
            default:
                break;
        }
    }
}

- (void)update {
}

- (void)render {
    [_renderer setDrawColor:30 green:30 blue:60 alpha:255];
    [_renderer clear];
    
    if (_textRenderer && [_textRenderer isReady]) {
        [_textRenderer renderText:@"Hello, World!" 
                                x:50 
                                y:50 
                              red:255 
                            green:255 
                             blue:255 
                            alpha:255];
        
        [_textRenderer renderText:@"SDL2 + Objective-C + GNUstep" 
                                x:50 
                                y:100 
                              red:200 
                            green:200 
                             blue:255 
                            alpha:255];
        
        [_textRenderer renderText:@"Press ESC to exit" 
                                x:50 
                                y:150 
                              red:150 
                            green:255 
                             blue:150 
                            alpha:255];
    } else {
        NSLog(@"Text renderer not ready - displaying without text");
    }
    
    [_renderer present];
}

@end