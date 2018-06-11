//
//  WCEmotionPanelView.h
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/9.
//

#import <UIKit/UIKit.h>

@class WCEmotionGroupItem;

@interface WCEmotionPanelView : UIView

@property (nonatomic, assign) NSUInteger countOfGroupItems;

- (void)insertGroupItem:(WCEmotionGroupItem *)groupItem atGroupIndex:(NSUInteger)index;
- (void)removePagesAtGroupIndex:(NSUInteger)index;
- (void)updatePagesWithGroupItem:(WCEmotionGroupItem *)groupItem atGroupIndex:(NSUInteger)groupIndex;

@end
