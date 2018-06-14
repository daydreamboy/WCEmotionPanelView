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

@interface WCEmotionPanelView () <WCEmotionSliderViewDelegate, WCEmotionPickerViewDelegate>
@property (nonatomic, strong) WCEmotionPickerView *emotionPickerView;
@property (nonatomic, strong) WCEmotionSliderView *emotionSliderView;

@property (nonatomic, strong) UIView *sliderLeftView;
@property (nonatomic, strong) UIView *sliderRightView;

@property (nonatomic, strong) NSMutableArray<WCEmotionGroup *> *groups;
@property (nonatomic, strong) NSMutableArray<WCEmotionGroup *> *groupsLeft;
@property (nonatomic, strong) NSMutableArray<WCEmotionGroup *> *groupsRight;
@end

@implementation WCEmotionPanelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _groups = [NSMutableArray array];
        
        [self addSubview:self.emotionPickerView];
        [self addSubview:self.emotionSliderView];
    }
    return self;
}

- (void)insertGroupItem:(id<WCEmotionGroupItem>)groupItem atGroupIndex:(NSUInteger)groupIndex {
    
    if (groupItem.position == WCEmotionGroupItemPositionSlider) {
        
        if (groupItem.emotions.count) {
            for (NSUInteger i = groupIndex; i < self.groups.count; i++) {
                WCEmotionGroup *group = self.groups[i];
                group.index += 1;
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
        }
        
        /*
        if (!groupItem.dummy) {
            if (groupItem.emotions.count) {
                for (NSUInteger i = groupIndex; i < self.groups.count; i++) {
                    WCEmotionGroup *groupItem = self.groups[i];
                    groupItem.index += 1;
                    groupItem.sliderIndex += 1;
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
            }
        }
        else {
            for (NSUInteger i = groupIndex; i < self.groups.count; i++) {
                WCEmotionGroup *groupItem = self.groups[i];
                groupItem.sliderIndex += 1;
            }
            
            WCEmotionGroup *group = [WCEmotionGroup newWithEmotionGroupItem:groupItem];
            group.dummy = YES;
            group.sliderIndex = groupIndex;
            [self.groups insertObject:group atIndex:groupIndex];
            [self.emotionSliderView insertGroup:group atIndex:groupIndex];
        }
         */
    }
}

- (void)removePagesAtGroupIndex:(NSUInteger)groupIndex {
    NSLog(@"remove group item at index: %d", (int)groupIndex);
    if (groupIndex < self.groups.count) {
        BOOL removeDisplayingGroup = groupIndex == self.emotionPickerView.currentGroup.index;
        
        for (NSUInteger i = groupIndex; i < self.groups.count; i++) {
            WCEmotionGroup *groupItem = self.groups[i];
            groupItem.index -= 1;
        }
        
        [self.groups removeObjectAtIndex:groupIndex];
        [self.emotionPickerView removePagesAtGroupIndex:groupIndex];
        [self.emotionSliderView removeGroupAtIndex:groupIndex];
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
        [self.emotionSliderView updateGroup:group atIndex:groupIndex];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        UIView *leftView;
        UIView *rightView;
        
        if ([self.delegate respondsToSelector:@selector(WCEmotionPanelView:leftViewWithSliderHeight:)]) {
            leftView = [self.delegate WCEmotionPanelView:self leftViewWithSliderHeight:groupViewHeight];
        }
        
        if ([self.delegate respondsToSelector:@selector(WCEmotionPanelView:rightViewWithSliderHeight:)]) {
            rightView = [self.delegate WCEmotionPanelView:self rightViewWithSliderHeight:groupViewHeight];
        }
        
        _emotionSliderView.frame = CGRectMake(CGRectGetWidth(leftView.bounds), CGRectGetMaxY(_emotionPickerView.frame), CGRectGetWidth(self.bounds) - CGRectGetWidth(leftView.bounds) - CGRectGetWidth(rightView.bounds), groupViewHeight);
        
        if (leftView) {
            CGRect bounds = leftView.bounds;
            leftView.frame = CGRectMake(0, CGRectGetMinY(_emotionSliderView.frame), bounds.size.width, bounds.size.height);
            
            [self addSubview:leftView];
            _sliderLeftView = leftView;
        }
        
        if (rightView) {
            CGRect bounds = rightView.bounds;
            rightView.frame = CGRectMake(CGRectGetMaxX(_emotionSliderView.frame), CGRectGetMinY(_emotionSliderView.frame), bounds.size.width, bounds.size.height);
            
            [self addSubview:rightView];
            _sliderRightView = rightView;
        }
    }
}

#pragma mark - Getters

- (UIView *)emotionPickerView {
    if (!_emotionPickerView) {
        WCEmotionPickerView *view = [[WCEmotionPickerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - groupViewHeight)];
        view.delegate = self;
        view.backgroundColor = [UIColor greenColor];
        _emotionPickerView = view;
    }
    
    return _emotionPickerView;
}

- (UIView *)emotionSliderView {
    if (!_emotionSliderView) {
        WCEmotionSliderView *view = [[WCEmotionSliderView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_sliderLeftView.bounds), CGRectGetMaxY(self.emotionPickerView.frame), CGRectGetWidth(self.bounds) - CGRectGetWidth(_sliderLeftView.bounds) - CGRectGetWidth(_sliderRightView.bounds), groupViewHeight)];
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

#pragma mark - WCEmotionPickerViewDelegate

- (void)WCEmotionPickerViewDidEndDecelerating:(WCEmotionPickerView *)emotionPickerView {
    WCEmotionGroup *currentGroup = self.emotionPickerView.currentGroup;
    [self.emotionSliderView selectGroupAtIndex:currentGroup.index animated:YES];
}

@end
