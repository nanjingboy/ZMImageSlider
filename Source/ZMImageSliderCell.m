#import "UIView+Toast.h"
#import "UIImageView+WebCache.h"
#import "ZMImageSliderCell.h"
#import "ZMImageSliderUtility.h"

@implementation ZMImageSliderCell

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }

    return _imageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.clipsToBounds = YES;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.decelerationRate /= 2;
        _scrollView.bouncesZoom = YES;
    }

    return _scrollView;
}

- (instancetype)initWithImageUrl:(NSString *)imageUrl {
    self = [super init];
    if (self) {
        self.imageUrl = imageUrl;
        [self initialize];
    }

    return self;
}

- (void)initialize {
    [self.scrollView addSubview:self.imageView];
    [self addSubview:self.scrollView];

    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSliderCellDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTap];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSliderCellSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:singleTap];

    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:@"imageSliderCell"];
}

- (void)loadImage {
    if (self.imageView.image) {
        return;
    }

    [self makeToastActivity:CSToastPositionCenter];
    self.scrollView.frame = self.bounds;
    [self resetZoomScale];

    __weak __typeof(self)weakSelf = self;
    NSURL *url = [NSURL URLWithString:self.imageUrl];
    [self.imageView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

        [self hideToastActivity];
        if (!error && image) {
            weakSelf.imageView.image = image;
            [weakSelf drawImage];
        } else {
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.messageAlignment = NSTextAlignmentCenter;
            [weakSelf makeToast:[ZMImageSliderUtility localizedString:@"Failed to load the image"] duration:2 position:CSToastPositionCenter style:style];
        }
    }];
}

- (void)drawImage {
    CGRect scrollViewFrame = self.scrollView.frame;
    if (self.imageView.image) {
        CGSize imageSize = self.imageView.image.size;
        CGFloat ratio = scrollViewFrame.size.width / imageSize.width;
        self.imageView.frame = CGRectMake(0.0f, 0.0f, scrollViewFrame.size.width, imageSize.height * ratio);
        self.scrollView.contentSize = self.imageView.frame.size;
        self.imageView.center = [self centerOfScrollView:self.scrollView];
        self.scrollView.minimumZoomScale = 1.0f;
        self.scrollView.maximumZoomScale = scrollViewFrame.size.height / self.imageView.frame.size.height;
        self.scrollView.zoomScale = 1.0f;
    } else {
        scrollViewFrame.origin = CGPointZero;
        self.imageView.frame = scrollViewFrame;
        self.scrollView.contentSize = self.imageView.frame.size;
        [self resetZoomScale];
    }
    self.scrollView.contentOffset = CGPointZero;
}

- (void)resetZoomScale {
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = 1.0f;
}

- (CGPoint)centerOfScrollView:(UIScrollView *)scrollView {
    CGFloat offsetX;
    if (scrollView.bounds.size.width > scrollView.contentSize.width) {
        offsetX = (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5;
    } else {
        offsetX = 0.0f;
    }

    CGFloat offsetY;
    if (scrollView.bounds.size.height > scrollView.contentSize.height) {
        offsetY = (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5;
    } else {
        offsetY = 0.0f;
    }

    return CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                       scrollView.contentSize.height * 0.5 + offsetY);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    self.imageView.center = [self centerOfScrollView:scrollView];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [UIView animateWithDuration:0.25f animations:^{
        view.center = [self centerOfScrollView:scrollView];
    }];
}

- (void)imageSliderCellDoubleTap:(UITapGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:self];
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    } else {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
}

- (void)imageSliderCellSingleTap:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageSliderCellSingleTap:)]) {
        [self.delegate imageSliderCellSingleTap:tap];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        if (!CGRectEqualToRect(self.frame, CGRectZero)) {
            self.scrollView.frame = self.bounds;
            [self resetZoomScale];
            [self drawImage];
        }
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"frame"];
    [self.imageView removeFromSuperview];
    [self.scrollView removeFromSuperview];

    self.imageUrl = nil;
    self.imageView = nil;
    self.scrollView = nil;
    self.delegate = nil;
}

@end