//
//  WCEmotionPickerView.h
//  Pods-WCEmotionPanelView_Example
//
//  Created by wesley_chen on 2018/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WCEmotionPage;
@class WCEmotionGroup;
@class WCEmotionPickerView;
@protocol WCEmotionGroupItem;

@protocol WCEmotionPickerViewDelegate <NSObject>
- (void)WCEmotionPickerViewDidEndDecelerating:(WCEmotionPickerView *)emotionPickerView;
- (void)WCEmotionPickerViewDidEndScrollingAnimation:(WCEmotionPickerView *)emotionPickerView;
@end


@interface WCEmotionPickerView : UIView

@property (nonatomic, strong, readonly) WCEmotionGroup *currentGroup;
@property (nonatomic, assign, readonly) CGFloat pageWidth;
@property (nonatomic, assign, readonly) CGFloat pageHeight;
@property (nonatomic, weak) id<WCEmotionPickerViewDelegate> delegate;

- (void)insertPagesWithGroup:(WCEmotionGroup *)group atGroupIndex:(NSUInteger)groupIndex;
- (void)updatePagesWithGroup:(WCEmotionGroup *)group atGroupIndex:(NSUInteger)groupIndex;
- (void)removePagesAtGroupIndex:(NSUInteger)index;

- (void)scrollToGroupIndex:(NSUInteger)groupIndex pageIndex:(NSUInteger)pageIndex animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
