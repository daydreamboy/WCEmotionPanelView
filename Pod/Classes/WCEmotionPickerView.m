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

#ifndef UICOLOR_randomColor
#define UICOLOR_randomColor [UIColor colorWithRed:(arc4random() % 255 / 255.0f) green:(arc4random() % 255 / 255.0f) blue:(arc4random() % 255 / 255.0f) alpha:1]
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
    NSMutableArray *pages = [NSMutableArray array];
    for (NSUInteger i = 0; i < groupItem.numberOfPages; i++) {
        WCEmotionPage *page = [WCEmotionPage new];
        page.groupItem = groupItem;
        page.index = i;
        page.backgroundColor = UICOLOR_randomColor;
        [pages addObject:page];
    }
    
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.bounds);
    CGFloat pageHeight = CGRectGetHeight(self.scrollView.bounds);
    
    WCEmotionPage *currentPage = nil;
    if (self.currentPageIndex < self.flattenPages.count) {
        currentPage = self.flattenPages[self.currentPageIndex];
    }
    
    NSUInteger countOfGroup = self.pages.count;
    if (groupIndex == countOfGroup) {
        
        CGFloat startX = countOfGroup * pageWidth;
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
            
            for (NSUInteger j = 0; j < groupOfPages.count; j++) {
                WCEmotionPage *page = groupOfPages[j];
                
                CGRect frame = page.frame;
                frame.origin.x += offset;
                page.frame = frame;
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
    
    CGSize contentSize = self.scrollView.contentSize;
    self.scrollView.contentSize = CGSizeMake(contentSize.width + pages.count * pageWidth, contentSize.height);
    self.scrollView.contentOffset = CGPointMake(currentPage.frame.origin.x, 0);
}

- (void)removePage:(WCEmotionPage *)page atIndex:(NSUInteger)index {
    
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
        pageControl.numberOfPages = 10;//self.currentNumberOfPages;
        pageControl.currentPage = 0;
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
}

#pragma mark - Actions

- (void)pageControlTapped:(UIPageControl *)sender {
    NSInteger page = sender.currentPage;
    
    // Update the scroll view to the appropriate page
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
    
//    _pageControlIsChangingPage = YES;
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
