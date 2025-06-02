#import <Foundation/Foundation.h>
#ifdef __APPLE__
#import <SDL.h>
#else
#import <SDL2/SDL.h>
#endif

@interface SDLWindow : NSObject

@property (nonatomic, readonly) SDL_Window *window;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSInteger width;
@property (nonatomic, readonly) NSInteger height;

- (instancetype)initWithTitle:(NSString *)title width:(NSInteger)width height:(NSInteger)height;
- (BOOL)create;
- (void)destroy;
- (BOOL)isValid;

@end