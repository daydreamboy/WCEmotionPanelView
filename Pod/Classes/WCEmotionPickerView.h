//
//  WCEmotionPickerView.h
//  Pods-WCEmotionPanelView_Example
//
//  Created by wesley_chen on 2018/6/9.
//

#import <UIKit/UIKit.h>

@class WCEmotionPage;
@class WCEmotionGroupItem;

@interface WCEmotionPickerView : UIView

@property (nonatomic, strong, readonly) WCEmotionGroupItem *currentGroupItem;
@property (nonatomic, strong, readonly) WCEmotionPage *currentPage;

- (void)insertPagesWithGroupItem:(WCEmotionGroupItem *)groupItem atGroupIndex:(NSUInteger)groupIndex;
- (void)removePagesAtGroupIndex:(NSUInteger)index;
- (void)updatePagesWithGroupItem:(WCEmotionGroupItem *)groupItem atGroupIndex:(NSUInteger)groupIndex;

@end
