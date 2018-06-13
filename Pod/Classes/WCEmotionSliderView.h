//
//  WCEmotionSliderView.h
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/9.
//

#import <UIKit/UIKit.h>

@class WCEmotionGroupItem;

@interface WCEmotionSliderView : UIView

- (void)insertGroupItem:(WCEmotionGroupItem *)groupItem atIndex:(NSUInteger)index;

@end
