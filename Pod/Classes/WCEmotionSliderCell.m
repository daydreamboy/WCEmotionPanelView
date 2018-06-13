//
//  WCEmotionSliderCell.m
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/11.
//

#import "WCEmotionSliderCell.h"

@interface WCEmotionSliderCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation WCEmotionSliderCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //self.imageView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0);
}

@end
