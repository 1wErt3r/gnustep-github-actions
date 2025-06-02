#import <Foundation/Foundation.h>
#import "HelloWorldApp.h"

int main(int argc, const char * argv[]) {
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