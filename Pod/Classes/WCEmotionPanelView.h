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

- (void)insertGroupItem:(WCEmotionGroupItem *)groupItem atIndex:(NSUInteger)index;
- (void)removeGroupItem:(WCEmotionGroupItem *)groupItem atIndex:(NSUInteger)index;

@end
