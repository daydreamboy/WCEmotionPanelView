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

#ifndef UICOLOR_randomColor
#define UICOLOR_randomColor [UIColor colorWithRed:(arc4random() % 255 / 255.0f) green:(arc4random() % 255 / 255.0f) blue:(arc4random() % 255 / 255.0f) alpha:1]
#endif

#define groupViewHeight 34

@interface WCEmotionPanelView ()
@property (nonatomic, strong) WCEmotionPickerView *emotionPickerView;
@property (nonatomic, strong) WCEmotionSliderView *emotionSliderView;
@property (nonatomic, strong) NSMutableArray<WCEmotionGroupItem *> *groupItems;
@end

@implementation WCEmotionPanelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.emotionPickerView];
        [self addSubview:self.emotionSliderView];
        _groupItems = [NSMutableArray array];
    }
    return self;
}

- (void)insertGroupItem:(WCEmotionGroupItem *)groupItem atGroupIndex:(NSUInteger)index {
    NSLog(@"insert group item: %d pages at index %d", (int)groupItem.numberOfPages, (int)index);
    if (groupItem.numberOfPages) {
        groupItem.index = index;
        
        for (NSUInteger i = index; i < self.groupItems.count; i++) {
            WCEmotionGroupItem *groupItem = self.groupItems[i];
            groupItem.index += 1;
        }
        
        [self.groupItems insertObject:groupItem atIndex:index];
        
        NSMutableArray *pages = [NSMutableArray array];
        
        CGSize pageSize = CGSizeMake(self.emotionPickerView.pageWidth, self.emotionPickerView.pageHeight);
        for (NSUInteger i = 0; i < groupItem.numberOfPages; i++) {
            WCEmotionPage *page = [[WCEmotionPage alloc] initWithIndex:i frame:CGRectMake(0, 0, pageSize.width, pageSize.height) groupItem:groupItem];
            page.backgroundColor = UICOLOR_randomColor;
            [pages addObject:page];
        }
        groupItem.pages = pages;
        
        [self.emotionPickerView insertPagesWithGroupItem:groupItem atGroupIndex:index];
        [self.emotionSliderView insertGroupItem:groupItem atIndex:index];
    }
}

- (void)removePagesAtGroupIndex:(NSUInteger)index {
    NSLog(@"remove group item at index: %d", (int)index);
    if (index < self.groupItems.count) {
        for (NSUInteger i = index; i < self.groupItems.count; i++) {
            WCEmotionGroupItem *groupItem = self.groupItems[i];
            groupItem.index -= 1;
        }
        
        [self.groupItems removeObjectAtIndex:index];
        [self.emotionPickerView removePagesAtGroupIndex:index];
    }
}

- (void)updatePagesWithGroupItem:(WCEmotionGroupItem *)groupItem atGroupIndex:(NSUInteger)groupIndex {
    NSLog(@"update group item at index: %d", (int)groupIndex);
    if (groupIndex < self.groupItems.count && groupItem.numberOfPages) {
        
        groupItem.index = groupIndex;
        
        NSMutableArray *pages = [NSMutableArray array];
        CGSize pageSize = CGSizeMake(self.emotionPickerView.pageWidth, self.emotionPickerView.pageHeight);
        for (NSUInteger i = 0; i < groupItem.numberOfPages; i++) {
            WCEmotionPage *page = [[WCEmotionPage alloc] initWithIndex:i frame:CGRectMake(0, 0, pageSize.width, pageSize.height) groupItem:groupItem];
            page.backgroundColor = UICOLOR_randomColor;
            [pages addObject:page];
        }
        groupItem.pages = pages;

        self.groupItems[groupIndex] = groupItem;
        [self.emotionPickerView updatePagesWithGroupItem:groupItem atGroupIndex:groupIndex];
    }
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

- (UIView *)emotionSliderView {
    if (!_emotionSliderView) {
        WCEmotionSliderView *view = [[WCEmotionSliderView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emotionPickerView.frame), CGRectGetWidth(self.bounds), groupViewHeight)];
        view.backgroundColor = [UIColor greenColor];
        _emotionSliderView = view;
    }
    
    return _emotionSliderView;
}

@end
