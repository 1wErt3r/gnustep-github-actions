#import <Foundation/Foundation.h>
#ifdef __APPLE__
#import <SDL.h>
#import <SDL_ttf.h>
#else
#import <SDL2/SDL.h>
#import <SDL2/SDL_ttf.h>
#endif
#import "SDLRenderer.h"

@interface TextRenderer : NSObject

@property (nonatomic, weak, readonly) SDLRenderer *renderer;
@property (nonatomic, readonly) TTF_Font *font;
@property (nonatomic, readonly) NSString *fontPath;
@property (nonatomic, readonly) NSInteger fontSize;

- (instancetype)initWithRenderer:(SDLRenderer *)renderer fontPath:(NSString *)fontPath fontSize:(NSInteger)fontSize;
- (BOOL)loadFont;
- (void)unloadFont;
- (BOOL)isReady;

- (void)renderText:(NSString *)text 
                 x:(NSInteger)x 
                 y:(NSInteger)y 
               red:(Uint8)red 
             green:(Uint8)green 
              blue:(Uint8)blue 
             alpha:(Uint8)alpha;

@end