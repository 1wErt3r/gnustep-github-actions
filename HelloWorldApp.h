#import <Foundation/Foundation.h>
#import "SDLWindow.h"
#import "SDLRenderer.h"
#import "TextRenderer.h"

@interface HelloWorldApp : NSObject

@property (nonatomic, strong) SDLWindow *window;
@property (nonatomic, strong) SDLRenderer *renderer;
@property (nonatomic, strong) TextRenderer *textRenderer;
@property (nonatomic, assign) BOOL isRunning;

- (instancetype)initWithTitle:(NSString *)title width:(NSInteger)width height:(NSInteger)height;
- (BOOL)initialize;
- (void)cleanup;
- (void)run;
- (void)handleEvents;
- (void)update;
- (void)render;

@end