#import "ZMIMageSliderView.h"

@implementation ZMImageSliderView

- (NSMutableArray *)sliderCells {
    if (!_sliderCells) {
        _sliderCells = [[NSMutableArray alloc] init];
    }

    return _sliderCells;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.scrollsToTop = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingNone;
    }

    return _scrollView;
}

- (instancetype)initWithOptions:(NSInteger)currentIndex imageUrls:(NSArray *)imageUrls {
    self = [super init];
    if (self) {
        [self initialize:currentIndex imageUrls:imageUrls];
    }

    return self;
}

- (void)initialize:(NSInteger)currentIndex imageUrls:(NSArray *)imageUrls {
    self.isUpdatingCellFrames = NO;
    self.currentIndex = currentIndex;

    self.clipsToBounds = NO;

    for (NSString *imageUrl in imageUrls) {
        ZMImageSliderCell *sliderCell = [[ZMImageSliderCell alloc] initWithImageUrl:imageUrl];
        sliderCell.delegate = self;
        [self.sliderCells addObject:sliderCell];
        [self.scrollView addSubview:sliderCell];
    }

    [self addSubview:self.scrollView];

    [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:@"imageSliderView"];
}

- (void)switchImage:(NSInteger)index {
    ZMImageSliderCell *cell = [self.sliderCells objectAtIndex:index];

    if (self.delegate && [self.delegate respondsToSelector:@selector(imageSliderViewImageSwitch:count:imageUrl:)]) {
        [self.delegate imageSliderViewImageSwitch:index count:[self.sliderCells count] imageUrl:cell.imageUrl];
    }

    self.currentIndex = index;
    [cell loadImage];
}

- (void)updateCellFrames {
    NSInteger pageCount = [self.sliderCells count];
    CGRect sliderViewFrame = self.bounds;

    self.isUpdatingCellFrames = YES;
    self.scrollView.frame = sliderViewFrame;
    self.scrollView.contentSize = CGSizeMake(sliderViewFrame.size.width * pageCount, sliderViewFrame.size.height * pageCount);
    self.scrollView.contentOffset = CGPointMake(self.currentIndex * sliderViewFrame.size.width, 0);

    CGRect scrollViewBounds = self.scrollView.bounds;
    for (int index = 0; index < pageCount; index++) {
        ZMImageSliderCell *cell = [self.sliderCells objectAtIndex:index];
        cell.frame = CGRectMake(CGRectGetWidth(scrollViewBounds) * index,
                                CGRectGetMinY(scrollViewBounds),
                                CGRectGetWidth(scrollViewBounds),
                                CGRectGetHeight(scrollViewBounds));
    }

    [self switchImage:self.currentIndex];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isUpdatingCellFrames) {
        self.isUpdatingCellFrames = NO;
        return;
    }

    self.scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    NSInteger index = floor((self.scrollView.contentOffset.x - width / 2) / width) + 1;
    if (self.currentIndex != index) {
        [self switchImage:index];
    }
}

- (void)imageSliderCellSingleTap:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageSliderViewSingleTap:)]) {
        [self.delegate imageSliderViewSingleTap:tap];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"bounds"]) {
        [self updateCellFrames];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"bounds"];
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
    self.sliderCells = nil;
    self.delegate = nil;
}

@end