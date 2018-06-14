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

@interface WCEmotionPanelView () <WCEmotionSliderViewDelegate>
@property (nonatomic, strong) WCEmotionPickerView *emotionPickerView;
@property (nonatomic, strong) WCEmotionSliderView *emotionSliderView;
@property (nonatomic, strong) NSMutableArray<WCEmotionGroup *> *groups;
@end

@implementation WCEmotionPanelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.emotionPickerView];
        [self addSubview:self.emotionSliderView];
        _groups = [NSMutableArray array];
    }
    return self;
}

- (void)insertGroupItem:(id<WCEmotionGroupItem>)groupItem atGroupIndex:(NSUInteger)groupIndex {
    if (groupItem.emotions.count) {
        
        for (NSUInteger i = groupIndex; i < self.groups.count; i++) {
            WCEmotionGroup *groupItem = self.groups[i];
            groupItem.index += 1;
        }
        
        WCEmotionGroup *group = [WCEmotionGroup newWithEmotionGroupItem:groupItem];
        group.index = groupIndex;
        [self.groups insertObject:group atIndex:groupIndex];
        
        NSLog(@"insert group item: %d pages at index %d", (int)group.numberOfPages, (int)groupIndex);
        
        NSMutableArray *pages = [NSMutableArray array];
        
        CGSize pageSize = CGSizeMake(self.emotionPickerView.pageWidth, self.emotionPickerView.pageHeight);
        for (NSUInteger i = 0; i < group.numberOfPages; i++) {
            WCEmotionPage *page = [[WCEmotionPage alloc] initWithIndex:i frame:CGRectMake(0, 0, pageSize.width, pageSize.height) group:group];
            //page.backgroundColor = UICOLOR_randomColor;
            [pages addObject:page];
        }
        group.pages = pages;
        
        [self.emotionPickerView insertPagesWithGroup:group atGroupIndex:groupIndex];
        [self.emotionSliderView insertGroup:group atIndex:groupIndex];
        [self.emotionSliderView selectGroupAtIndex:self.emotionPickerView.currentGroup.index animated:NO];
    }
}

- (void)removePagesAtGroupIndex:(NSUInteger)index {
    NSLog(@"remove group item at index: %d", (int)index);
    if (index < self.groups.count) {
        BOOL removeDisplayingGroup = index == self.emotionPickerView.currentGroup.index;
        
        for (NSUInteger i = index; i < self.groups.count; i++) {
            WCEmotionGroup *groupItem = self.groups[i];
            groupItem.index -= 1;
        }
        
        [self.groups removeObjectAtIndex:index];
        [self.emotionPickerView removePagesAtGroupIndex:index];
        [self.emotionSliderView removeGroupAtIndex:index];
        [self.emotionSliderView selectGroupAtIndex:self.emotionPickerView.currentGroup.index animated:NO];
        
        if (removeDisplayingGroup) {
            [self.emotionPickerView scrollToGroupIndex:self.emotionPickerView.currentGroup.index pageIndex:0 animated:NO];
        }
    }
}

- (void)updatePagesWithGroupItem:(id<WCEmotionGroupItem>)groupItem atGroupIndex:(NSUInteger)groupIndex {
    NSLog(@"update group item at index: %d", (int)groupIndex);
    if (groupIndex < self.groups.count && groupItem.emotions.count) {
        
        WCEmotionGroup *group = [WCEmotionGroup newWithEmotionGroupItem:groupItem];
        group.index = groupIndex;
        
        NSMutableArray *pages = [NSMutableArray array];
        CGSize pageSize = CGSizeMake(self.emotionPickerView.pageWidth, self.emotionPickerView.pageHeight);
        for (NSUInteger i = 0; i < group.numberOfPages; i++) {
            WCEmotionPage *page = [[WCEmotionPage alloc] initWithIndex:i frame:CGRectMake(0, 0, pageSize.width, pageSize.height) group:group];
//            page.backgroundColor = UICOLOR_randomColor;
            [pages addObject:page];
        }
        group.pages = pages;

        self.groups[groupIndex] = group;
        [self.emotionPickerView updatePagesWithGroup:group atGroupIndex:groupIndex];
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
        view.delegate = self;
        view.backgroundColor = [UIColor greenColor];
        _emotionSliderView = view;
    }
    
    return _emotionSliderView;
}

#pragma mark - WCEmotionSliderViewDelegate

- (void)WCEmotionSliderView:(WCEmotionSliderView *)emotionSliderView didSelectGroup:(WCEmotionGroup *)group atIndex:(NSIndexPath *)indexPath {
    [self.emotionPickerView scrollToGroupIndex:group.index pageIndex:0 animated:YES];
}

@end
