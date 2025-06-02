#import <Foundation/Foundation.h>
#import <SDL2/SDL.h>

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