//
//  WCEmotionSliderCellSeparator.m
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/12.
//

#import "WCEmotionSliderCellSeparator.h"

@implementation WCEmotionSliderCellSeparator

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
    
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    self.frame = layoutAttributes.frame;
}

@end
