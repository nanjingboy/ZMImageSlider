#import <UIKit/UIKit.h>
#import "ZMImageSliderCellDelegate.h"

@interface ZMImageSliderCell : UIView<UIScrollViewDelegate, ZMImageSliderCellDelegate>

@property(copy, nonatomic) NSString *imageUrl;
@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) UIScrollView *scrollView;

@property(weak, nonatomic) id<ZMImageSliderCellDelegate> delegate;

- (instancetype)initWithImageUrl:(NSString *)imageUrl;
- (void)loadImage;

@end