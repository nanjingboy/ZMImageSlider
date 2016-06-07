#import <UIKit/UIKit.h>

@protocol ZMImageSliderViewDelegate <NSObject>

- (void)imageSliderViewSingleTap:(UITapGestureRecognizer *)tap;
- (void)imageSliderViewImageSwitch:(NSInteger)index count:(NSInteger)count imageUrl:(NSString *)imageUrl;

@end