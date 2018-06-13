//
//  WCEmotionGroup.m
//  WCEmotionPanel
//
//  Created by wesley_chen on 2018/6/13.
//

#import "WCEmotionGroup.h"
#import "WCEmotionGroupItem.h"

@interface WCEmotionGroup ()
@property (nonatomic, strong, readwrite) id<WCEmotionGroupItem> emotionGroupItem;
@property (nonatomic, assign, readwrite) NSUInteger numberOfItems;
@property (nonatomic, assign, readwrite) NSUInteger numberOfItemsInRow;
@property (nonatomic, assign, readwrite) NSUInteger numberOfItemsInColumn;
@property (nonatomic, assign, readwrite) NSUInteger numberOfReservedItems;
@property (nonatomic, assign, readwrite) NSUInteger capacityOfPage;
@property (nonatomic, assign, readwrite) NSUInteger availableCapacityOfPage;
@property (nonatomic, assign, readwrite) NSUInteger numberOfPages;
@property (nonatomic, strong, readwrite) NSArray<id<WCEmotionItem>> *reservedItems;
@end

@implementation WCEmotionGroup
+ (instancetype)newWithEmotionGroupItem:(id<WCEmotionGroupItem>)emotionGroupItem {
    return [[WCEmotionGroup alloc] initWithEmotionGroupItem:emotionGroupItem];
}

- (instancetype)initWithEmotionGroupItem:(id<WCEmotionGroupItem>)emotionGroupItem {
    self = [super init];
    if (self) {
        _emotionGroupItem = emotionGroupItem;
        _numberOfItems = emotionGroupItem.emotions.count;
        _numberOfItemsInRow = (NSUInteger)emotionGroupItem.layoutSize.width;
        _numberOfItemsInColumn = (NSUInteger)emotionGroupItem.layoutSize.height;
        _cellClass = emotionGroupItem.cellClass;
        
        _capacityOfPage = _numberOfItemsInRow * _numberOfItemsInColumn;
        _numberOfPages = (NSUInteger)(ceil((float)_numberOfItems / _capacityOfPage));
        
        if (emotionGroupItem.extraInfo.reservedItem2 && emotionGroupItem.extraInfo.reservedItem1) {
            _numberOfReservedItems = 2;
            _reservedItems = @[emotionGroupItem.extraInfo.reservedItem1, emotionGroupItem.extraInfo.reservedItem2];
        }
        else if (emotionGroupItem.extraInfo.reservedItem1 && !emotionGroupItem.extraInfo.reservedItem2) {
            _numberOfReservedItems = 1;
            _reservedItems = @[emotionGroupItem.extraInfo.reservedItem1];
        }
        else {
            _numberOfReservedItems = 0;
            _reservedItems = @[];
        }
        _availableCapacityOfPage = _capacityOfPage - _numberOfReservedItems;
    }
    return self;
}

@end
