#import "TextRenderer.h"
#include "assets/font.h"

@implementation TextRenderer

- (instancetype)initWithRenderer:(SDLRenderer *)renderer fontPath:(NSString *)fontPath fontSize:(NSInteger)fontSize {
    self = [super init];
    if (self) {
        _renderer = renderer;
        _fontPath = [fontPath copy];
        _fontSize = fontSize;
        _font = NULL;
    }
    return self;
}

- (void)dealloc {
    [self unloadFont];
}

- (BOOL)loadFont {
    // Load font from embedded memory instead of file
    SDL_RWops* fontBuffer = SDL_RWFromConstMem(
        HarmonyOS_Sans_SC_Regular_ttf,
        sizeof(HarmonyOS_Sans_SC_Regular_ttf)
    );
    
    if (!fontBuffer) {
        NSLog(@"Failed to create font buffer: %s", SDL_GetError());
        return NO;
    }
    
    _font = TTF_OpenFontRW(fontBuffer, 1, (int)_fontSize);
    
    if (_font == NULL) {
        NSLog(@"Failed to load embedded font: %s", TTF_GetError());
        return NO;
    }
    
    return YES;
}

- (void)unloadFont {
    if (_font != NULL) {
        TTF_CloseFont(_font);
        _font = NULL;
    }
}

- (BOOL)isReady {
    return _font != NULL && [_renderer isValid];
}

- (void)renderText:(NSString *)text 
                 x:(NSInteger)x 
                 y:(NSInteger)y 
               red:(Uint8)red 
             green:(Uint8)green 
              blue:(Uint8)blue 
             alpha:(Uint8)alpha {
    
    if (![self isReady]) {
        return;
    }
    
    SDL_Color color = {red, green, blue, alpha};
    SDL_Surface *textSurface = TTF_RenderText_Solid(_font, [text UTF8String], color);
    
    if (textSurface == NULL) {
        NSLog(@"Failed to render text surface: %s", TTF_GetError());
        return;
    }
    
    SDL_Texture *textTexture = SDL_CreateTextureFromSurface(_renderer.renderer, textSurface);
    SDL_FreeSurface(textSurface);
    
    if (textTexture == NULL) {
        NSLog(@"Failed to create texture from text surface: %s", SDL_GetError());
        return;
    }
    
    int textWidth, textHeight;
    SDL_QueryTexture(textTexture, NULL, NULL, &textWidth, &textHeight);
    
    SDL_Rect destRect = {(int)x, (int)y, textWidth, textHeight};
    SDL_RenderCopy(_renderer.renderer, textTexture, NULL, &destRect);
    
    SDL_DestroyTexture(textTexture);
}

@end
