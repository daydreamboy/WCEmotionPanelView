//
//  WCEmotionSliderView.h
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/9.
//

#import <UIKit/UIKit.h>

@class WCEmotionSliderView;
@class WCEmotionGroup;

@protocol WCEmotionSliderViewDelegate <NSObject>
- (void)WCEmotionSliderView:(WCEmotionSliderView *)emotionSliderView didSelectGroup:(WCEmotionGroup *)group atIndex:(NSIndexPath *)indexPath;
@end

@protocol WCEmotionGroupItem;

@interface WCEmotionSliderView : UIView

@property (nonatomic, weak) id<WCEmotionSliderViewDelegate> delegate;

- (void)insertGroupItem:(WCEmotionGroup *)groupItem atIndex:(NSUInteger)index;

@end
