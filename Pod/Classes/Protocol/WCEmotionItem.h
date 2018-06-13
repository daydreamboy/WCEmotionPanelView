//
//  WCEmotionItem.h
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/13.
//

#import <Foundation/Foundation.h>

#define WCEmotionItem_synthesize \
@synthesize codes = _codes; \
@synthesize name = _name; \
@synthesize reservedItem1 = _reservedItem1; \
@synthesize reservedItem2 = _reservedItem2;

NS_ASSUME_NONNULL_BEGIN

@protocol WCEmotionItem <NSObject>

@required

@property (nonatomic, copy) NSString *name; /// < 名称
@property (nonatomic, strong) NSArray<NSString *> *codes; /// < 表情编码

// optional and not set by outside
@optional
@property (nonatomic, assign) BOOL reservedItem1;
@property (nonatomic, assign) BOOL reservedItem2;

@end

NS_ASSUME_NONNULL_END
