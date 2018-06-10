//
//  WCEmotionGroupItem.m
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/10.
//

#import "WCEmotionGroupItem.h"

@interface WCEmotionGroupItem ()
@property (nonatomic, strong, readwrite) NSArray<WCEmotionItem *> *emotions;
@end

@implementation WCEmotionGroupItem

- (instancetype)initWithEmotions:(NSArray<WCEmotionItem *> *)emotions {
    self = [super init];
    if (self) {
        _emotions = emotions;
    }
    return self;
}

@end
