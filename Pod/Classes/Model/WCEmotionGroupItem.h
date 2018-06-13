//
//  WCEmotionGroupItem.h
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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

// required
@property (nonatomic, strong) UIImage *groupIcon;
@property (nonatomic, assign) CGSize groupIconSize;
@property (nonatomic, assign) CGFloat width;

// optional
@property (nonatomic, assign) NSUInteger numberOfItemsInRow;
@property (nonatomic, assign) NSUInteger numberOfItemsInColomn;
@property (nonatomic, strong) Class cellClass;

- (instancetype)initWithEmotions:(NSArray<WCEmotionItem *> *)emotions;

@property (nonatomic, assign) WCEmotionGroupItemPosition position;
@property (nonatomic, assign, readonly) NSUInteger numberOfPages;
@property (nonatomic, assign, readonly) NSUInteger numberOfItems;

@end

NS_ASSUME_NONNULL_END
