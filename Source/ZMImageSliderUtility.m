#import "ZMImageSliderUtility.h"

@implementation ZMImageSliderUtility

+ (NSString *)localizedString:(NSString *)key {
    NSURL *bundleUrl = [[NSBundle bundleForClass:[self class]] URLForResource:@"ZMImageSlider" withExtension:@"bundle"];
    NSBundle *bundle = [[NSBundle alloc] initWithURL:bundleUrl];
    return [bundle localizedStringForKey:key value:key table:@"ZMImageSlider"];
}

@end