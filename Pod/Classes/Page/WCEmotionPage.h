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
@property (nonatomic, weak) WCEmotionGroupItem *groupItem;
@property (nonatomic, assign) NSUInteger index;

- (void)makeOriginXByOffset:(NSNumber *)offset;

@end
