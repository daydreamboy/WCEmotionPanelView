//
//  WCEmotionGroup.h
//  WCEmotionPanel
//
//  Created by wesley_chen on 2018/6/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WCEmotionGroupItem;
@protocol WCEmotionItem;
@class WCEmotionPage;

@interface WCEmotionGroup : NSObject

@property (nonatomic, strong, readonly) id<WCEmotionGroupItem> emotionGroupItem;
@property (nonatomic, assign, readonly) NSUInteger numberOfItems;
@property (nonatomic, assign, readonly) NSUInteger numberOfItemsInRow;
@property (nonatomic, assign, readonly) NSUInteger numberOfItemsInColumn;
@property (nonatomic, assign, readonly) NSUInteger numberOfReservedItems;
@property (nonatomic, assign, readonly) NSUInteger capacityOfPage;
@property (nonatomic, assign, readonly) NSUInteger availableCapacityOfPage;
@property (nonatomic, assign, readonly) NSUInteger numberOfPages;
@property (nonatomic, strong, readonly) NSArray<id<WCEmotionItem>> *reservedItems;

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) NSMutableArray<WCEmotionPage *> *pages;
@property (nonatomic, strong) Class cellClass;

+ (instancetype)newWithEmotionGroupItem:(id<WCEmotionGroupItem>)emotionGroupItem;

@end

NS_ASSUME_NONNULL_END
