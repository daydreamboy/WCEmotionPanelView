//
//  WCEmotionPickerView.m
//  Pods-WCEmotionPanelView_Example
//
//  Created by wesley_chen on 2018/6/9.
//

#import "WCEmotionPickerView.h"
#import "WCEmotionPage.h"
#import "WCEmotionGroupItem.h"

#ifndef UICOLOR_ARGB
#define UICOLOR_ARGB(color)      [UIColor colorWithRed: (((color) >> 16) & 0xFF) / 255.0 green: (((color) >> 8) & 0xFF) / 255.0 blue: ((color) & 0xFF) / 255.0 alpha: (((color) >> 24) & 0xFF) / 255.0]
#endif

#define pageControlHeight 38

@interface WCEmotionPickerView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) NSUInteger numberOfPages;
@property (nonatomic, assign) NSUInteger currentPageIndex;

@property (nonatomic, strong) NSMutableArray<NSArray<WCEmotionPage *> *> *pages;
@property (nonatomic, strong, readonly) NSArray<WCEmotionPage *> *flattenPages;
@end

@implementation WCEmotionPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _pages = [NSMutableArray array];
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    
    return self;
}

- (void)insertPagesWithGroupItem:(WCEmotionGroupItem *)groupItem atGroupIndex:(NSUInteger)groupIndex {
    NSMutableArray *pages = groupItem.pages;
    
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.bounds);
    CGFloat pageHeight = CGRectGetHeight(self.scrollView.bounds);
    
    WCEmotionPage *currentPage = nil;
    if (self.currentPageIndex < self.flattenPages.count) {
        currentPage = self.flattenPages[self.currentPageIndex];
    }
    
    NSUInteger countOfGroup = self.pages.count;
    if (groupIndex == countOfGroup) {
        
        if (self.flattenPages.count == 0) {
            // setup UIControl
            self.pageControl.numberOfPages = groupItem.numberOfPages;
            self.pageControl.currentPage = 0;
        }
        
        CGFloat startX = self.flattenPages.count * pageWidth;
        // append
        for (NSUInteger i = 0; i < pages.count; i++) {
            WCEmotionPage *page = pages[i];
            page.frame = CGRectMake(startX + i * pageWidth, 0, pageWidth, pageHeight);
            page.textLabel.text = [NSString stringWithFormat:@"%d-%d", (int)countOfGroup, (int)i];
            [self.scrollView addSubview:page];
        }
        [self.pages addObject:pages];
        self.numberOfPages += pages.count;
    }
    else {
        // insert
        WCEmotionPage *previousPage = nil;
        if (groupIndex < self.pages.count) {
            previousPage = [self.pages[groupIndex] firstObject];
        }
        
        CGFloat startX = CGRectGetMinX(previousPage.frame);
        
        CGFloat offset = pages.count * pageWidth;
        for (NSUInteger i = groupIndex; i < self.pages.count; i++) {
            NSArray *groupOfPages = self.pages[i];
            [groupOfPages makeObjectsPerformSelector:@selector(makeOriginXByOffset:) withObject:@(offset)];
            
            for (NSUInteger j = 0; j < groupOfPages.count; j++) {
                WCEmotionPage *page = groupOfPages[j];
                page.textLabel.text = [NSString stringWithFormat:@"%d-%d", (int)page.groupItem.index, (int)j];
            }
        }
        
        for (NSUInteger i = 0; i < pages.count; i++) {
            WCEmotionPage *page = pages[i];
            page.frame = CGRectMake(startX + i * pageWidth, 0, pageWidth, pageHeight);
            page.textLabel.text = [NSString stringWithFormat:@"%d-%d", (int)groupIndex, (int)i];
            [self.scrollView addSubview:page];
        }
        [self.pages insertObject:pages atIndex:groupIndex];
        self.numberOfPages += pages.count;
    }
    
    // Configure UIScrollView
    
    CGSize contentSize = self.scrollView.contentSize;
    self.scrollView.contentSize = CGSizeMake(contentSize.width + pages.count * pageWidth, contentSize.height);
    // Note: keep current page still in visual region of UIScrollView
    self.scrollView.contentOffset = CGPointMake(currentPage.frame.origin.x, 0);
}

- (void)removePagesAtGroupIndex:(NSUInteger)groupIndex {
    if (groupIndex >= self.pages.count) {
        return;
    }
    
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.bounds);
    
    WCEmotionPage *currentPage = nil;
    if (self.currentPageIndex < self.flattenPages.count) {
        currentPage = self.flattenPages[self.currentPageIndex];
    }
    
    NSArray *groupOfPages = self.pages[groupIndex];
    
    // Note: if not tail, move the following group by offset
    if (groupIndex < self.pages.count - 1) {
        CGFloat offset = groupOfPages.count * pageWidth;
        for (NSUInteger i = groupIndex + 1; i < self.pages.count; i++) {
            NSArray *pages = self.pages[i];
            
            [pages makeObjectsPerformSelector:@selector(makeOriginXByOffset:) withObject:@(-offset)];
            
            for (NSUInteger j = 0; j < pages.count; j++) {
                WCEmotionPage *page = pages[j];
                page.textLabel.text = [NSString stringWithFormat:@"%d-%d", (int)page.groupItem.index, (int)j];
            }
        }
    }
    
    // Note: the current page will delete, so change current page to the last page of previous group
    // and reconfigure UIControl
    if ([groupOfPages containsObject:currentPage]) {
        if (groupIndex >= 1) {
            currentPage = [self.pages[groupIndex - 1] lastObject];
            self.pageControl.numberOfPages = [self.pages[groupIndex - 1] count];
            self.pageControl.currentPage = currentPage.index;
        }
        else {
            // Note: no previous group, let the next group to configure UIControl
            currentPage = nil;
            
            if (groupIndex + 1 < self.pages.count) {
                self.pageControl.numberOfPages = [self.pages[groupIndex + 1] count];
                self.pageControl.currentPage = currentPage.index;
            }
            else {
                // no group and pages show
                self.pageControl.numberOfPages = 0;
                self.pageControl.currentPage = 0;
            }
        }
    }
    [groupOfPages makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.pages removeObjectAtIndex:groupIndex];
    
    self.numberOfPages -= groupOfPages.count;
    
    // Configure UIScrollView
    CGSize contentSize = self.scrollView.contentSize;
    self.scrollView.contentSize = CGSizeMake(contentSize.width - groupOfPages.count * pageWidth, contentSize.height);
    self.scrollView.contentOffset = CGPointMake(currentPage.frame.origin.x, 0);
}

- (void)updatePagesWithGroupItem:(WCEmotionGroupItem *)groupItem atGroupIndex:(NSUInteger)groupIndex {
    if (groupIndex > self.pages.count) {
        return;
    }
    
    
}

- (void)scrollToGroupIndex:(NSUInteger)groupIndex pageIndex:(NSUInteger)pageIndex animated:(BOOL)animated {
    if (groupIndex >= self.pages.count) {
        groupIndex = self.pages.count - 1;
    }
    NSArray *groupOfPages = self.pages[groupIndex];
    
    if (pageIndex >= groupOfPages.count) {
        pageIndex = groupOfPages.count - 1;
    }
    
    WCEmotionPage *page = groupOfPages[pageIndex];
    [self.scrollView scrollRectToVisible:page.frame animated:animated];
}

#pragma mark >

- (WCEmotionGroupItem *)currentGroupItem {
    return self.currentPage.groupItem;
}

- (WCEmotionPage *)currentPage {
    return self.flattenPages[self.currentPageIndex];
}

#pragma mark - Getters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - pageControlHeight)];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(0, CGRectGetHeight(scrollView.bounds));
        
        _scrollView = scrollView;
    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), CGRectGetWidth(self.bounds), pageControlHeight)];
        pageControl.backgroundColor = [UICOLOR_ARGB(0xFFCFD3D8) colorWithAlphaComponent:0.3];
        pageControl.pageIndicatorTintColor = UICOLOR_ARGB(0xFFA5A9AD);
        pageControl.currentPageIndicatorTintColor = UICOLOR_ARGB(0xFF67686B);
        
        [pageControl addTarget:self action:@selector(pageControlTapped:) forControlEvents:UIControlEventValueChanged];
        
        _pageControl = pageControl;
    }
    
    return _pageControl;
}

- (NSArray<WCEmotionPage *> *)flattenPages {
    // @see https://stackoverflow.com/questions/17087380/flatten-an-nsarray
    NSArray<WCEmotionPage *> *flatArray = [self.pages valueForKeyPath:@"@unionOfArrays.self"];
    return flatArray;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.currentPageIndex = [self currentPageOfScrollView:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    WCEmotionGroupItem *groupItem = self.currentGroupItem;
    NSLog(@"%d - %d", (int)groupItem.index, (int)self.currentPage.index);
    self.pageControl.numberOfPages = groupItem.numberOfPages;
    self.pageControl.currentPage = self.currentPage.index;
}

#pragma mark - Actions

- (void)pageControlTapped:(UIPageControl *)sender {
//    _pageControlIsChangingPage = YES;
    
    NSUInteger groupIndex = self.currentGroupItem.index;
    NSInteger pageIndex = sender.currentPage;
    
    [self scrollToGroupIndex:groupIndex pageIndex:pageIndex animated:YES];
}

#pragma mark -

- (NSUInteger)currentPageOfScrollView:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    page = MAX(page, 0);
    page = MIN(page, self.numberOfPages - 1);

    return page;
}

@end
