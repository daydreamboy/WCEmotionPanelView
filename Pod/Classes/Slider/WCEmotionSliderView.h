//
//  WCEmotionSliderView.h
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/9.
//

#import <UIKit/UIKit.h>

@protocol WCEmotionSliderViewDelegate

@end

@protocol WCEmotionGroupItem;
@class WCEmotionGroup;

@interface WCEmotionSliderView : UIView

@property (nonatomic, weak) id<WCEmotionSliderViewDelegate> delegate;

- (void)insertGroupItem:(id<WCEmotionGroupItem>)groupItem atIndex:(NSUInteger)index;

@end
