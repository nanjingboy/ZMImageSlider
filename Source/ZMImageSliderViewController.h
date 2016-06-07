#import <UIKit/UIKit.h>
#import "ZMImageSliderView.h"

@interface ZMImageSliderViewController : UIViewController<ZMImageSliderViewDelegate>

@property(strong, nonatomic) ZMImageSliderView *imageSliderView;
@property(strong, nonatomic) UILabel *displayLabel;

- (instancetype)initWithOptions:(NSInteger)currentIndex imageUrls:(NSArray *)imageUrls;

- (void)setImageSliderViewConstraints;
- (void)setDisplayLabelConstraints;

- (void)imageSliderViewSingleTap:(UITapGestureRecognizer *)tap;
- (void)imageSliderViewImageSwitch:(NSInteger)index count:(NSInteger)count imageUrl:(NSString *)imageUrl;

@end