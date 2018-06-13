//
//  WCEmotionPage.h
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/9.
//

#import <UIKit/UIKit.h>

@protocol WCEmotionGroupItem;
@class WCEmotionGroup;

@interface WCEmotionPage : UIView
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, weak, readonly) WCEmotionGroup *group;
@property (nonatomic, assign, readonly) NSUInteger index;
@property (nonatomic, assign, readonly) NSUInteger groupIndex;
@property (nonatomic, assign, readonly) CGSize itemSize;

@property (nonatomic, assign, readonly) NSUInteger numberOfItems; /// > 除了reserved items之外的item个数
@property (nonatomic, assign, readonly) NSUInteger numberOfItemsInRow; /// > 行上的item个数
@property (nonatomic, assign, readonly) NSUInteger numberOfItemsInColumn; /// > 列上的item个数

@property (nonatomic, assign, readonly) NSUInteger capacityOfPage; /// > 放置item容量（包括reserved items）

- (instancetype)initWithIndex:(NSUInteger)index frame:(CGRect)frame group:(WCEmotionGroup *)group;

- (void)makeOriginXByOffset:(NSNumber *)offset;

@end
