//
//  WCEmotionPage.m
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/9.
//

#import "WCEmotionPage.h"
#import "WCEmotionItem.h"
#import "WCEmotionGroupItem.h"
#import "WCEmotionPanelView.h"
#import "WCEmotionGroup.h"

#ifndef UICOLOR_randomColor
#define UICOLOR_randomColor [UIColor colorWithRed:(arc4random() % 255 / 255.0f) green:(arc4random() % 255 / 255.0f) blue:(arc4random() % 255 / 255.0f) alpha:1]
#endif

@interface WCEmotionPage () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign, readwrite) CGSize itemSize;
@property (nonatomic, assign, readwrite) NSUInteger index;
@property (nonatomic, assign, readwrite) NSUInteger groupIndex;

@property (nonatomic, weak, readwrite) WCEmotionGroup *group;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign, readwrite) NSUInteger numberOfItems;
@property (nonatomic, assign, readwrite) NSUInteger numberOfItemsInRow;
@property (nonatomic, assign, readwrite) NSUInteger numberOfItemsInColumn;

@property (nonatomic, assign, readwrite) NSUInteger numberOfReservedItems;
@property (nonatomic, strong) NSArray<id<WCEmotionItem>> *reservedItems;
@property (nonatomic, assign, readwrite) NSUInteger capacityOfPage;
@property (nonatomic, assign, readwrite) NSUInteger availableCapacityOfPage;

@end

@implementation WCEmotionPage

- (instancetype)initWithIndex:(NSUInteger)index frame:(CGRect)frame group:(WCEmotionGroup *)group {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        _index = index;
        _group = group;
        _numberOfItemsInRow = group.numberOfItemsInRow;
        _numberOfItemsInColumn = group.numberOfItemsInColumn;
        _capacityOfPage = group.capacityOfPage;
        _availableCapacityOfPage = group.availableCapacityOfPage;
        _reservedItems = group.reservedItems;
        _numberOfReservedItems = group.numberOfReservedItems;
        _itemSize = CGSizeMake(self.frame.size.width / _numberOfItemsInRow, self.frame.size.height / _numberOfItemsInColumn);
        
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
        
        [view registerClass:self.group.emotionGroupItem.cellClass forCellWithReuseIdentifier:NSStringFromClass(self.group.emotionGroupItem.cellClass)];
        [view registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        
        _collectionView = view;
    }
    
    return _collectionView;
}

- (NSUInteger)numberOfItems {
    if (_numberOfItems == 0) {
        NSUInteger numberOfTotalItems = self.group.numberOfItems;
        NSUInteger numberOfTotalPages = (NSUInteger)(ceil((float)numberOfTotalItems / self.availableCapacityOfPage));
        
        if (self.index == numberOfTotalPages - 1) {
            // last page
            _numberOfItems = numberOfTotalItems - self.index * self.availableCapacityOfPage;
        }
        else {
            _numberOfItems = self.availableCapacityOfPage;
        }
    }
    return _numberOfItems;
}

#pragma mark - Public Methods

- (void)makeOriginXByOffset:(NSNumber *)offset {
    CGRect frame = self.frame;
    frame.origin.x += [offset floatValue];
    self.frame = frame;
    
    // DEBUG:
    self.textLabel.text = [NSString stringWithFormat:@"%d-%d", (int)self.group.index, (int)self.index];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

- (id<WCEmotionItem>)itemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = self.index * self.availableCapacityOfPage + indexPath.row;
    return self.group.emotionGroupItem.emotions[index];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.capacityOfPage;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.numberOfItems) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.group.emotionGroupItem.cellClass) forIndexPath:indexPath];
        
        if ([cell respondsToSelector:@selector(WCEmotionPage:cellForItem:atIndexPath:)]) {
            id<WCEmotionItem> item = [self itemAtIndexPath:indexPath];
            [(id<WCEmotionPanelCellDataSource>)cell WCEmotionPage:self cellForItem:item atIndexPath:indexPath];
        }
        
        return cell;
    }
    else {
        if (indexPath.row == self.capacityOfPage - 2 && self.numberOfReservedItems == 2) {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.group.emotionGroupItem.cellClass) forIndexPath:indexPath];
            
            if ([cell respondsToSelector:@selector(WCEmotionPage:cellForItem:atIndexPath:)]) {
                id<WCEmotionItem> item = [self.reservedItems firstObject];
                [(id<WCEmotionPanelCellDataSource>)cell WCEmotionPage:self cellForItem:item atIndexPath:indexPath];
            }
            
            return cell;
        }
        else if (indexPath.row == self.capacityOfPage - 1 && (self.numberOfReservedItems == 2 || self.numberOfReservedItems == 1)) {
            
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.group.emotionGroupItem.cellClass) forIndexPath:indexPath];
            
            if ([cell respondsToSelector:@selector(WCEmotionPage:cellForItem:atIndexPath:)]) {
                id<WCEmotionItem> item = self.numberOfReservedItems == 2 ? [self.reservedItems lastObject] : [self.reservedItems firstObject];
                [(id<WCEmotionPanelCellDataSource>)cell WCEmotionPage:self cellForItem:item atIndexPath:indexPath];
            }
            
            return cell;
        }
        else {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
            cell.contentView.backgroundColor = UICOLOR_randomColor;
            
            return cell;
        }
    }
}

@end
