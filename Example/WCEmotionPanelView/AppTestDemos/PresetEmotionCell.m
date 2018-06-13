//
//  PresetEmotionCell.m
//  WCEmotionPanelView_Example
//
//  Created by wesley_chen on 2018/6/13.
//  Copyright © 2018 daydreamboy. All rights reserved.
//

#import "PresetEmotionCell.h"
#import <WCEmotionPanelView/WCEmotionItem.h>

@interface PresetEmotionCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation PresetEmotionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
    }
    return self;
}

#pragma mark - Getter

- (UIImageView *)imageView {
    if (!_imageView) {
        CGFloat side = 32;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - side) / 2.0, ((self.bounds.size.height) - side) / 2.0, side, side)];
        _imageView = imageView;
    }
    
    return _imageView;
}

- (void)WCEmotionPage:(WCEmotionPage *)emotionPage cellForItem:(WCEmotionItem *)item atIndexPath:(NSIndexPath *)indexPath {
    NSString *emotionBundlePath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"Emoticon.bundle"];
    NSString *imagePath = [emotionBundlePath stringByAppendingPathComponent:item.name];
    self.imageView.image = [UIImage imageNamed:imagePath];
}

@end
