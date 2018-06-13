//
//  WCEmotionPackage.h
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/13.
//

#import <Foundation/Foundation.h>

#define WCEmotionGroupItemExtraInfo_synthesize \
@synthesize reservedItem1; \
@synthesize reservedItem2; \
@synthesize extraData;

NS_ASSUME_NONNULL_BEGIN

@protocol WCEmotionItem;

typedef NS_ENUM(NSUInteger, WCEmotionGroupItemPosition) {
    WCEmotionGroupItemPositionSlider,
    WCEmotionGroupItemPositionFixedLeft,
    WCEmotionGroupItemPositionFixedRight,
};

@protocol WCEmotionGroupItemExtraInfo <NSObject>
@property (nonatomic, strong, nullable) id<WCEmotionItem> reservedItem1; /// < 预留item，总是每页倒数第1个位置
@property (nonatomic, strong, nullable) id<WCEmotionItem> reservedItem2; /// < 预留item，总是每页倒数第2个位置
@property (nonatomic, strong, nullable) NSMutableDictionary *extraData;
@end

@protocol WCEmotionGroupItem <NSObject>

@required

// required
@property (nonatomic, strong, readonly) NSArray<id<WCEmotionItem>> *emotions;
@property (nonatomic, assign, readonly) CGSize layoutSize;
@property (nonatomic, strong, readonly) id<WCEmotionGroupItemExtraInfo> extraInfo;

@property (nonatomic, strong) UIImage *groupIcon;
@property (nonatomic, assign) CGSize groupIconSize;
@property (nonatomic, assign) CGFloat width;

- (instancetype)initWithEmotions:(NSArray<id<WCEmotionItem>> *)emotions layoutSize:(CGSize)layoutSize extraInfo:(nullable id<WCEmotionGroupItemExtraInfo>)extraInfo;

@optional

// optional
@property (nonatomic, strong) Class cellClass;
@property (nonatomic, assign) WCEmotionGroupItemPosition position;

@end

NS_ASSUME_NONNULL_END
