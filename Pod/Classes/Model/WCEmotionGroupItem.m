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
        _cellClass = [UICollectionViewCell class];
    }
    return self;
}

#pragma mark - Properties

- (NSUInteger)numberOfPages {
    NSUInteger numberOfItemsInPage = self.numberOfItemsInRow * self.numberOfItemsInColomn;
    return (NSUInteger)(ceil(self.emotions.count / (float)numberOfItemsInPage));
}

- (NSUInteger)numberOfItems {
    return self.emotions.count;
}

@end
