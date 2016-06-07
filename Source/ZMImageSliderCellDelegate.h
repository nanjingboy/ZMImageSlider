#import <UIKit/UIKit.h>

@protocol ZMImageSliderCellDelegate <NSObject>

- (void)imageSliderCellSingleTap:(UITapGestureRecognizer *)tap;

@end