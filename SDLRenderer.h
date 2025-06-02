#import <Foundation/Foundation.h>
#import <SDL2/SDL.h>
#import "SDLWindow.h"

@interface SDLRenderer : NSObject

@property (nonatomic, readonly) SDL_Renderer *renderer;
@property (nonatomic, weak, readonly) SDLWindow *window;

- (instancetype)initWithWindow:(SDLWindow *)window;
- (BOOL)create;
- (void)destroy;
- (BOOL)isValid;

- (void)clear;
- (void)present;
- (void)setDrawColor:(Uint8)red green:(Uint8)green blue:(Uint8)blue alpha:(Uint8)alpha;

@end