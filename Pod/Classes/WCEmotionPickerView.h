//
//  WCEmotionPickerView.h
//  Pods-WCEmotionPanelView_Example
//
//  Created by wesley_chen on 2018/6/9.
//

#import <UIKit/UIKit.h>

@class WCEmotionPage;
@class WCEmotionGroup;
@protocol WCEmotionGroupItem;

@interface WCEmotionPickerView : UIView

@property (nonatomic, strong, readonly) WCEmotionGroup *currentGroupItem;
@property (nonatomic, assign, readonly) CGFloat pageWidth;
@property (nonatomic, assign, readonly) CGFloat pageHeight;

- (void)insertPagesWithGroupItem:(WCEmotionGroup *)groupItem atGroupIndex:(NSUInteger)groupIndex;
- (void)removePagesAtGroupIndex:(NSUInteger)index;
- (void)updatePagesWithGroupItem:(WCEmotionGroup *)groupItem atGroupIndex:(NSUInteger)groupIndex;

@end
