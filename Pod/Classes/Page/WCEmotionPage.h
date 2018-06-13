//
//  WCEmotionPage.h
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/9.
//

#import <UIKit/UIKit.h>

@class WCEmotionGroupItem;

@interface WCEmotionPage : UIView
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, weak, readonly) WCEmotionGroupItem *groupItem;
@property (nonatomic, assign, readonly) NSUInteger index;
@property (nonatomic, assign, readonly) NSUInteger groupIndex;
@property (nonatomic, assign, readonly) CGSize itemSize;

- (instancetype)initWithIndex:(NSUInteger)index frame:(CGRect)frame groupItem:(WCEmotionGroupItem *)groupItem;

- (void)makeOriginXByOffset:(NSNumber *)offset;

@end
