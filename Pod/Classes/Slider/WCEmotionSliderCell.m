//
//  WCEmotionSliderCell.m
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/11.
//

#import "WCEmotionSliderCell.h"

@interface WCEmotionSliderCell ()
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation WCEmotionSliderCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.button];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

#pragma mark - Getters

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView = imageView;
    }
    
    return _imageView;
}

- (UIButton *)button {
    if (!_button) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;
        button.userInteractionEnabled = NO;
        [button setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        [button setBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        _button = button;
    }
    
    return _button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //self.imageView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0);
}

#pragma mark -

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    // Note: use UIGraphicsBeginImageContextWithOptions instead of UIGraphicsBeginImageContext to set UIImage.scale
    // @see https://stackoverflow.com/questions/4965036/uigraphicsgetimagefromcurrentimagecontext-retina-resolution
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
