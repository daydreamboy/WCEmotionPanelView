//
//  WCEmotionGroupItem.h
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/10.
//

#import <Foundation/Foundation.h>

@class WCEmotionItem;
@class WCEmotionPage;

typedef NS_ENUM(NSUInteger, WCEmotionGroupItemPosition) {
    WCEmotionGroupItemPositionSlider,
    WCEmotionGroupItemPositionFixedLeft,
    WCEmotionGroupItemPositionFixedRight,
};

@interface WCEmotionGroupItem : NSObject

@property (nonatomic, strong, readonly) NSArray<WCEmotionItem *> *emotions;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) NSMutableArray<WCEmotionPage *> *pages;

- (instancetype)initWithEmotions:(NSArray<WCEmotionItem *> *)emotions;

@property (nonatomic, assign) WCEmotionGroupItemPosition position;
@property (nonatomic, assign) NSUInteger numberOfPages;

@end
