//
//  WCEmotionPage.m
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/9.
//

#import "WCEmotionPage.h"
#import "WCEmotionKey.h"
#import "WCEmotionItem.h"

@interface WCEmotionPage ()
@property (nonatomic, assign) CGSize keySize;

// key views
@property (nonatomic, strong) NSArray<WCEmotionKey *> *keys;
// key data
@property (nonatomic, strong) NSArray<WCEmotionItem *> *keyItems;
@end

@implementation WCEmotionPage

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = NO;
        _keys = [NSMutableArray array];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        
        _textLabel = label;
    }
    return self;
}

- (void)layoutKeys:(NSArray<WCEmotionItem *> *)items numberOfRows:(NSUInteger)numberOfRows numberOfColumns:(NSUInteger)numberOfColumns {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

@end
