//
//  PresetEmotionCell.m
//  WCEmotionPanelView_Example
//
//  Created by wesley_chen on 2018/6/13.
//  Copyright © 2018 daydreamboy. All rights reserved.
//

#import "PresetEmotionCell.h"
#import <WCEmotionPanel/WCEmotionPanel.h>

@interface PresetEmotionCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation PresetEmotionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.label];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.label.hidden = YES;
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

- (UILabel *)label {
    if (!_label) {
        CGFloat padding = 5;
        CGFloat height = 20;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding, ((self.bounds.size.height) - height) / 2.0, (self.bounds.size.width - 2 * padding), height)];
        label.text = @"发送";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor orangeColor];
        label.hidden = YES;
        //label.layer.borderColor = [UIColor redColor].CGColor;
//        label.layer.borderWidth = 1;
        label.layer.cornerRadius = 2;
        label.layer.masksToBounds = YES;
        
        _label = label;
    }
    
    return _label;
}

- (void)WCEmotionPage:(WCEmotionPage *)emotionPage cellForItem:(id<WCEmotionItem>)item atIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == emotionPage.capacityOfPage - 1) {
//        self.label.hidden = NO;
//    }
//    else {
        NSString *emotionBundlePath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"Emoticon.bundle"];
        NSString *imagePath = [emotionBundlePath stringByAppendingPathComponent:item.name];
        self.imageView.image = [UIImage imageNamed:imagePath];
//    }
}

@end
