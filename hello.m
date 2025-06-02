#import "hello.h"

@implementation HelloWorld

- (void)sayHello {
    NSLog(@"Hello, World from GNUstep!");
}

- (void)demonstrateFeatures {
    NSLog(@"Testing GNUstep Foundation features:");
    
    // Test date functionality
    NSDate *now = [NSDate date];
    NSLog(@"Current date: %@", now);
    
    // Test string manipulation
    NSString *message = @"GNUstep is working!";
    NSLog(@"Message: %@", message);
    
    // Test arrays
    NSArray *array = @[@"One", @"Two", @"Three"];
    NSLog(@"Array count: %lu", (unsigned long)[array count]);
    
    // Test dictionaries
    NSDictionary *dict = @{@"key": @"value", @"number": @42};
    NSLog(@"Dictionary: %@", dict);
    
    // Test mutable arrays
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        [mutableArray addObject:[NSString stringWithFormat:@"Item %d", i]];
    }
    NSLog(@"Mutable array contents: %@", mutableArray);
    
    // Test string components
    NSArray *items = @[@"GNUstep", @"on", @"multiple", @"platforms"];
    NSString *joinedMessage = [items componentsJoinedByString:@" "];
    NSLog(@"Joined message: %@", joinedMessage);
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        HelloWorld *hello = [[HelloWorld alloc] init];
        [hello sayHello];
        [hello demonstrateFeatures];
    }
    return 0;
}