//
//  WCEmotionGroupItem.m
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/10.
//

#import "WCEmotionGroupItemModel.h"

@interface WCEmotionGroupItemModel ()
//@property (nonatomic, strong, readwrite) NSArray<WCEmotionItem *> *emotions;
@end

@implementation WCEmotionGroupItemModel

@synthesize emotions = _emotions;
@synthesize groupIcon = _groupIcon;
@synthesize groupIconSize = _groupIconSize;
@synthesize width = _width;
@synthesize cellClass = _cellClass;
@synthesize position = _position;
@synthesize layoutSize = _layoutSize;
@synthesize extraInfo = _extraInfo;

- (instancetype)initWithEmotions:(NSArray<id<WCEmotionItem>> *)emotions layoutSize:(CGSize)layoutSize extraInfo:(id<WCEmotionGroupItemExtraInfo>)extraInfo {
    self = [super init];
    if (self) {
        _emotions = emotions;
        _layoutSize = layoutSize;
        _extraInfo = extraInfo;
    }
    return self;
}

@end
