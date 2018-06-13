//
//  WCEmotionSliderView.h
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/9.
//

#import <UIKit/UIKit.h>

@protocol WCEmotionGroupItem;

@interface WCEmotionSliderView : UIView

- (void)insertGroupItem:(id<WCEmotionGroupItem>)groupItem atIndex:(NSUInteger)index;

@end
