//
//  WCEmotionPickerView.m
//  Pods-WCEmotionPanelView_Example
//
//  Created by wesley_chen on 2018/6/9.
//

#import "WCEmotionPickerView.h"
#import "WCEmotionPage.h"
#import "WCEmotionGroupItem.h"
#import "WCEmotionGroup.h"

#ifndef UICOLOR_ARGB
#define UICOLOR_ARGB(color)      [UIColor colorWithRed: (((color) >> 16) & 0xFF) / 255.0 green: (((color) >> 8) & 0xFF) / 255.0 blue: ((color) & 0xFF) / 255.0 alpha: (((color) >> 24) & 0xFF) / 255.0]
#endif

#define pageControlHeight 38

@interface WCEmotionPickerView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

// --- total pages
@property (nonatomic, assign) NSUInteger numberOfPages;
@property (nonatomic, assign) NSUInteger currentPageIndex;
@property (nonatomic, strong, readonly) WCEmotionPage *currentPage;

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

- (void)insertPagesWithGroupItem:(WCEmotionGroup *)groupItem atGroupIndex:(NSUInteger)groupIndex {
    NSMutableArray *pagesToInsert = groupItem.pages;
    
    CGFloat pageWidth = self.pageWidth;
    
    WCEmotionPage *currentPage = self.currentPage;
    
    NSUInteger countOfGroup = self.pages.count;
    if (groupIndex == countOfGroup) {
        
        if (self.flattenPages.count == 0) {
            // setup UIControl
            self.pageControl.numberOfPages = groupItem.numberOfPages;
            self.pageControl.currentPage = 0;
        }
        
        CGFloat startX = self.flattenPages.count * pageWidth;
        // append
        for (NSUInteger i = 0; i < pagesToInsert.count; i++) {
            WCEmotionPage *page = pagesToInsert[i];
            [page makeOriginXByOffset:@(startX + i * pageWidth)];
            [self.scrollView addSubview:page];
        }
        [self.pages addObject:pagesToInsert];
        self.numberOfPages += pagesToInsert.count;
    }
    else {
        // insert
        WCEmotionPage *previousPage = nil;
        if (groupIndex < self.pages.count) {
            previousPage = [self.pages[groupIndex] firstObject];
        }
        
        CGFloat startX = CGRectGetMinX(previousPage.frame);
        
        CGFloat offset = pagesToInsert.count * pageWidth;
        for (NSUInteger i = groupIndex; i < self.pages.count; i++) {
            NSArray *pages = self.pages[i];
            [pages makeObjectsPerformSelector:@selector(makeOriginXByOffset:) withObject:@(offset)];
        }
        
        for (NSUInteger i = 0; i < pagesToInsert.count; i++) {
            WCEmotionPage *page = pagesToInsert[i];
            [page makeOriginXByOffset:@(startX + i * pageWidth)];
            [self.scrollView addSubview:page];
        }
        [self.pages insertObject:pagesToInsert atIndex:groupIndex];
        self.numberOfPages += pagesToInsert.count;
    }
    
    // Configure UIScrollView
    
    CGSize contentSize = self.scrollView.contentSize;
    self.scrollView.contentSize = CGSizeMake(contentSize.width + pagesToInsert.count * pageWidth, contentSize.height);
    // Note: keep current page still in visual region of UIScrollView
    self.scrollView.contentOffset = CGPointMake(currentPage.frame.origin.x, 0);
}

- (void)removePagesAtGroupIndex:(NSUInteger)groupIndex {
    if (groupIndex >= self.pages.count) {
        return;
    }
    
    CGFloat pageWidth = self.pageWidth;
    
    WCEmotionPage *currentPage = self.currentPage;
    
    NSArray *pagesToRemove = self.pages[groupIndex];
    
    // Note: if not tail, move the following group by offset
    if (groupIndex < self.pages.count - 1) {
        CGFloat offset = pagesToRemove.count * pageWidth;
        for (NSUInteger i = groupIndex + 1; i < self.pages.count; i++) {
            NSArray *pages = self.pages[i];
            [pages makeObjectsPerformSelector:@selector(makeOriginXByOffset:) withObject:@(-offset)];
        }
    }
    
    // Note: the current page will delete, so change current page to the last page of previous group
    // and reconfigure UIControl
    if ([pagesToRemove containsObject:currentPage]) {
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
    [pagesToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.pages removeObjectAtIndex:groupIndex];
    
    self.numberOfPages -= pagesToRemove.count;
    
    // Configure UIScrollView
    CGSize contentSize = self.scrollView.contentSize;
    self.scrollView.contentSize = CGSizeMake(contentSize.width - pagesToRemove.count * pageWidth, contentSize.height);
    self.scrollView.contentOffset = CGPointMake(currentPage.frame.origin.x, 0);
}

- (void)updatePagesWithGroupItem:(WCEmotionGroup *)groupItem atGroupIndex:(NSUInteger)groupIndex {
    if (groupIndex > self.pages.count || groupItem.pages.count == 0) {
        return;
    }
    
    CGFloat pageWidth = self.pageWidth;
    
    WCEmotionPage *currentPage = self.currentPage;
    
    NSArray *oldGroupOfPages = self.pages[groupIndex];
    NSArray *newGroupOfPages = groupItem.pages;
    
    WCEmotionPage *previousPage = [oldGroupOfPages firstObject];
    CGFloat startX = CGRectGetMinX(previousPage.frame);
    
    // Note: if newGroupOfPages.count < oldGroupOfPages.count, (newGroupOfPages.count - oldGroupOfPages.count) will generate big positive number,
    // so cast it to NSInteger
    CGFloat offset = (NSInteger)(newGroupOfPages.count - oldGroupOfPages.count) * pageWidth;
    
    for (NSUInteger i = groupIndex; i < self.pages.count; i++) {
        NSArray *pages = self.pages[i];
        [pages makeObjectsPerformSelector:@selector(makeOriginXByOffset:) withObject:@(offset)];
    }
    
    [oldGroupOfPages makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (NSUInteger i = 0; i < newGroupOfPages.count; i++) {
        WCEmotionPage *page = newGroupOfPages[i];
        [page makeOriginXByOffset:@(startX + i * pageWidth)];
        [self.scrollView addSubview:page];
    }
    
    if ([oldGroupOfPages containsObject:currentPage]) {
        if (groupIndex >= 1) {
            currentPage = [self.pages[groupIndex - 1] lastObject];
            self.pageControl.numberOfPages = [self.pages[groupIndex - 1] count];
            self.pageControl.currentPage = currentPage.index;
        }
        else {
            currentPage = nil;
            self.pageControl.numberOfPages = newGroupOfPages.count;
            self.pageControl.currentPage = 0;
        }
    }
    
    self.pages[groupIndex] = newGroupOfPages;
    
    self.numberOfPages += (NSInteger)(newGroupOfPages.count - oldGroupOfPages.count);
    
    // Configure UIScrollView
    CGSize contentSize = self.scrollView.contentSize;
    self.scrollView.contentSize = CGSizeMake(contentSize.width + offset, contentSize.height);
    self.scrollView.contentOffset = CGPointMake(currentPage.frame.origin.x, 0);
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

#pragma mark > Properties

- (WCEmotionGroup *)currentGroupItem {
    return self.currentPage.groupItem;
}

- (CGFloat)pageWidth {
    return CGRectGetWidth(self.scrollView.bounds);
}

- (CGFloat)pageHeight {
    return CGRectGetHeight(self.scrollView.bounds);
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

- (WCEmotionPage *)currentPage {
    WCEmotionPage *currentPage = nil;
    if (self.currentPageIndex < self.flattenPages.count) {
        currentPage = self.flattenPages[self.currentPageIndex];
    }
    return currentPage;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.currentPageIndex = [self currentPageOfScrollView:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    WCEmotionGroup *groupItem = self.currentGroupItem;
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
