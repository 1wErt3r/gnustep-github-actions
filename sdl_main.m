#import <Foundation/Foundation.h>
#import "HelloWorldApp.h"

#ifdef _WIN32
int SDL_main(int argc, char * argv[]) {
#else
int main(int argc, const char * argv[]) {
#endif
    @autoreleasepool {
        NSLog(@"Starting SDL2 Hello World Application");
        
        HelloWorldApp *app = [[HelloWorldApp alloc] initWithTitle:@"SDL2 Hello World - Objective-C"
                                                           width:800
                                                          height:600];
        
        [app run];
        
        NSLog(@"Application finished");
    }
    return 0;
}