//
//  WCEmotionPage.m
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/9.
//

#import "WCEmotionPage.h"
#import "WCEmotionKey.h"
#import "WCEmotionItem.h"
#import "WCEmotionGroupItem.h"
#import "WCEmotionPanelView.h"

#ifndef UICOLOR_randomColor
#define UICOLOR_randomColor [UIColor colorWithRed:(arc4random() % 255 / 255.0f) green:(arc4random() % 255 / 255.0f) blue:(arc4random() % 255 / 255.0f) alpha:1]
#endif

@interface WCEmotionPage () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign, readwrite) CGSize itemSize;
@property (nonatomic, assign, readwrite) NSUInteger index;
@property (nonatomic, assign, readwrite) NSUInteger groupIndex;

@property (nonatomic, weak, readwrite) WCEmotionGroupItem *groupItem;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSUInteger numberOfItems;

// key views
@property (nonatomic, strong) NSArray<WCEmotionKey *> *keys;
// key data
@property (nonatomic, strong) NSArray<WCEmotionItem *> *keyItems;
@end

@implementation WCEmotionPage

- (instancetype)initWithIndex:(NSUInteger)index frame:(CGRect)frame groupItem:(WCEmotionGroupItem *)groupItem {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        _keys = [NSMutableArray array];
        _index = index;
        _groupItem = groupItem;
        _itemSize = CGSizeMake(self.frame.size.width / groupItem.numberOfItemsInRow, self.frame.size.height / groupItem.numberOfItemsInColomn);
        
        if (index == groupItem.numberOfPages - 1) {
            // last page
            _numberOfItems = groupItem.numberOfItems - index * (groupItem.numberOfItemsInColomn * groupItem.numberOfItemsInRow);
        }
        else {
            _numberOfItems = groupItem.numberOfItemsInColomn * groupItem.numberOfItemsInRow;
        }
        
        [self addSubview:self.collectionView];
        [self addSubview:self.textLabel];
    }
    return self;
}

#pragma mark -

- (UILabel *)textLabel {
    if (!_textLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        
        _textLabel = label;
    }
    
    return _textLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = self.itemSize;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:layout];
        view.dataSource = self;
        view.delegate = self;
        view.backgroundColor = [UIColor clearColor];
        
        [view registerClass:self.groupItem.cellClass forCellWithReuseIdentifier:NSStringFromClass(self.groupItem.cellClass)];
        
        _collectionView = view;
    }
    
    return _collectionView;
}

#pragma mark - Public Methods

- (void)makeOriginXByOffset:(NSNumber *)offset {
    CGRect frame = self.frame;
    frame.origin.x += [offset floatValue];
    self.frame = frame;
    
    // DEBUG:
    self.textLabel.text = [NSString stringWithFormat:@"%d-%d", (int)self.groupItem.index, (int)self.index];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

- (WCEmotionItem *)itemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger index;
    if (self.index > 0) {
        index = (self.index - 1) * (self.groupItem.numberOfItemsInColomn * self.groupItem.numberOfItemsInRow) + indexPath.row;
    }
    else {
        index = indexPath.row;
    }
    
    return self.groupItem.emotions[index];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.groupItem.cellClass) forIndexPath:indexPath];
    cell.contentView.backgroundColor = UICOLOR_randomColor;
    
    if ([cell respondsToSelector:@selector(WCEmotionPage:cellForItem:atIndexPath:)]) {
        WCEmotionItem *item = [self itemAtIndexPath:indexPath];
        [(id<WCEmotionPanelCellDataSource>)cell WCEmotionPage:self cellForItem:item atIndexPath:indexPath];
    }
    
    return cell;
}

@end
