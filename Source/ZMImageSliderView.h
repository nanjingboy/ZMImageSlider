#import <UIKit/UIKit.h>
#import "ZMImageSliderCell.h"
#import "ZMImageSliderViewDelegate.h"

@interface ZMImageSliderView : UIView<UIScrollViewDelegate, ZMImageSliderCellDelegate>

@property(assign) BOOL isUpdatingCellFrames;

@property(assign) NSInteger currentIndex;
@property(strong, nonatomic) NSMutableArray *sliderCells;
@property(strong, nonatomic) UIScrollView *scrollView;

@property(weak, nonatomic) id<ZMImageSliderViewDelegate> delegate;

- (instancetype)initWithOptions:(NSInteger)currentIndex imageUrls:(NSArray *)imageUrls;

@end