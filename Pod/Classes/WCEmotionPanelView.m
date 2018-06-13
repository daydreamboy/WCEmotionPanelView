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
#import "WCEmotionGroup.h"

#ifndef UICOLOR_randomColor
#define UICOLOR_randomColor [UIColor colorWithRed:(arc4random() % 255 / 255.0f) green:(arc4random() % 255 / 255.0f) blue:(arc4random() % 255 / 255.0f) alpha:1]
#endif

#define groupViewHeight 34

@interface WCEmotionPanelView ()
@property (nonatomic, strong) WCEmotionPickerView *emotionPickerView;
@property (nonatomic, strong) WCEmotionSliderView *emotionSliderView;
@property (nonatomic, strong) NSMutableArray<WCEmotionGroup *> *groupItems;
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

- (void)insertGroupItem:(id<WCEmotionGroupItem>)groupItem atGroupIndex:(NSUInteger)index {
    if (groupItem.emotions.count) {
        
        for (NSUInteger i = index; i < self.groupItems.count; i++) {
            WCEmotionGroup *groupItem = self.groupItems[i];
            groupItem.index += 1;
        }
        
        WCEmotionGroup *group = [WCEmotionGroup newWithEmotionGroupItem:groupItem];
        group.index = index;
        [self.groupItems insertObject:group atIndex:index];
        
        NSLog(@"insert group item: %d pages at index %d", (int)group.numberOfPages, (int)index);
        
        NSMutableArray *pages = [NSMutableArray array];
        
        CGSize pageSize = CGSizeMake(self.emotionPickerView.pageWidth, self.emotionPickerView.pageHeight);
        for (NSUInteger i = 0; i < group.numberOfPages; i++) {
            WCEmotionPage *page = [[WCEmotionPage alloc] initWithIndex:i frame:CGRectMake(0, 0, pageSize.width, pageSize.height) groupItem:group];
            //page.backgroundColor = UICOLOR_randomColor;
            [pages addObject:page];
        }
        group.pages = pages;
        
        [self.emotionPickerView insertPagesWithGroupItem:group atGroupIndex:index];
        [self.emotionSliderView insertGroupItem:groupItem atIndex:index];
    }
}

- (void)removePagesAtGroupIndex:(NSUInteger)index {
    NSLog(@"remove group item at index: %d", (int)index);
    if (index < self.groupItems.count) {
        for (NSUInteger i = index; i < self.groupItems.count; i++) {
            WCEmotionGroup *groupItem = self.groupItems[i];
            groupItem.index -= 1;
        }
        
        [self.groupItems removeObjectAtIndex:index];
        [self.emotionPickerView removePagesAtGroupIndex:index];
    }
}

- (void)updatePagesWithGroupItem:(id<WCEmotionGroupItem>)groupItem atGroupIndex:(NSUInteger)groupIndex {
    NSLog(@"update group item at index: %d", (int)groupIndex);
    if (groupIndex < self.groupItems.count && groupItem.emotions.count) {
        
        WCEmotionGroup *group = [WCEmotionGroup newWithEmotionGroupItem:groupItem];
        group.index = groupIndex;
        
        NSMutableArray *pages = [NSMutableArray array];
        CGSize pageSize = CGSizeMake(self.emotionPickerView.pageWidth, self.emotionPickerView.pageHeight);
        for (NSUInteger i = 0; i < group.numberOfPages; i++) {
            WCEmotionPage *page = [[WCEmotionPage alloc] initWithIndex:i frame:CGRectMake(0, 0, pageSize.width, pageSize.height) groupItem:group];
            page.backgroundColor = UICOLOR_randomColor;
            [pages addObject:page];
        }
        group.pages = pages;

        self.groupItems[groupIndex] = group;
        [self.emotionPickerView updatePagesWithGroupItem:group atGroupIndex:groupIndex];
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
