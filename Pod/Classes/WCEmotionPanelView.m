//
//  WCEmotionPanelView.m
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/9.
//

#import "WCEmotionPanelView.h"
#import "WCEmotionPickerView.h"
#import "WCEmotionSliderView.h"
#import "WCEmotionGroupItem.h"
#import "WCEmotionPage.h"

#define groupViewHeight 34

@interface WCEmotionPanelView ()
@property (nonatomic, strong) WCEmotionPickerView *emotionPickerView;
@property (nonatomic, strong) WCEmotionSliderView *groupView;
@property (nonatomic, strong) NSMutableArray<WCEmotionGroupItem *> *groupItems;
@end

@implementation WCEmotionPanelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.emotionPickerView];
        [self addSubview:self.groupView];
        _groupItems = [NSMutableArray array];
    }
    return self;
}

- (void)insertGroupItem:(WCEmotionGroupItem *)groupItem atIndex:(NSUInteger)index {
    if (groupItem.numberOfPages) {
        groupItem.index = index;
        
        for (NSUInteger i = index; i < self.groupItems.count; i++) {
            WCEmotionGroupItem *groupItem = self.groupItems[i];
            groupItem.index += 1;
        }
        
        [self.groupItems insertObject:groupItem atIndex:index];
        [self.emotionPickerView insertPagesWithGroupItem:groupItem atGroupIndex:index];
        
    }
}

- (void)removeGroupItem:(WCEmotionGroupItem *)groupItem atIndex:(NSUInteger)index {
    [self.groupItems removeObjectAtIndex:index];
}

#pragma mark - Getters

- (UIView *)emotionPickerView {
    if (!_emotionPickerView) {
        WCEmotionPickerView *view = [[WCEmotionPickerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - groupViewHeight)];
        view.backgroundColor = [UIColor greenColor];
        _emotionPickerView = view;
    }
    
    return _emotionPickerView;
}

- (UIView *)groupView {
    if (!_groupView) {
        WCEmotionSliderView *view = [[WCEmotionSliderView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emotionPickerView.frame), CGRectGetWidth(self.bounds), groupViewHeight)];
        view.backgroundColor = [UIColor yellowColor];
        _groupView = view;
    }
    
    return _groupView;
}

@end
