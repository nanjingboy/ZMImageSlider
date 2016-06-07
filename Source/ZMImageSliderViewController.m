#import "ZMImageSliderViewController.h"

@implementation ZMImageSliderViewController

- (UILabel *)displayLabel {
    if (!_displayLabel) {
        _displayLabel = [[UILabel alloc] init];
        _displayLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _displayLabel.backgroundColor = [UIColor clearColor];
        _displayLabel.textColor = [UIColor whiteColor];
        _displayLabel.opaque = NO;
    }

    return _displayLabel;
}

- (instancetype)initWithOptions:(NSInteger)currentIndex imageUrls:(NSArray *)imageUrls {
    self = [super init];
    if (self) {
        _imageSliderView = [[ZMImageSliderView alloc] initWithOptions:currentIndex imageUrls:imageUrls];
        _imageSliderView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageSliderView.delegate = self;
        [self imageSliderViewImageSwitch:currentIndex count:[imageUrls count] imageUrl:[imageUrls objectAtIndex:currentIndex]];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor blackColor];

    [self.view addSubview:self.imageSliderView];
    [self setImageSliderViewConstraints];

    [self.view addSubview:self.displayLabel];
    [self setDisplayLabelConstraints];
}

- (void)setImageSliderViewConstraints {
    NSArray *imageSliderViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageSliderView]-0-|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:@{@"imageSliderView": self.imageSliderView}];

    [self.view addConstraints:imageSliderViewHConstraints];



    NSArray *imageSliderViewVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageSliderView]-0-|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:@{@"imageSliderView": self.imageSliderView}];

    [self.view addConstraints:imageSliderViewVConstraints];
}

- (void)setDisplayLabelConstraints {

    NSLayoutConstraint *conatraint = [NSLayoutConstraint constraintWithItem:self.displayLabel
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0f
                                                                   constant:0.0f];
    [self.view addConstraint:conatraint];

    NSArray *displayLabelVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-20-|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:@{@"label": self.displayLabel}];

    [self.view addConstraints:displayLabelVConstraints];
}

- (void)imageSliderViewSingleTap:(UITapGestureRecognizer *)tap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageSliderViewImageSwitch:(NSInteger)index count:(NSInteger)count imageUrl:(NSString *)imageUrl {
    self.displayLabel.text = [[NSString alloc] initWithFormat:@"%td／%td", index + 1, count];
}

@end