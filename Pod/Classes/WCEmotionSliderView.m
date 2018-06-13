//
//  WCEmotionSliderView.m
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/9.
//

#import "WCEmotionSliderView.h"
#import "WCEmotionGroupItem.h"
#import "WCEmotionSliderCell.h"
#import "WCEmotionSliderLayout.h"
#import "WCEmotionSliderCellSeparator.h"

#ifndef UNSPECIFIED
#define UNSPECIFIED 0
#endif

@interface WCEmotionSliderView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<id<WCEmotionGroupItem>> *collectionData;

@end

@implementation WCEmotionSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _collectionData = [NSMutableArray array];
        
        [self addSubview:self.leftView];
        [self addSubview:self.rightView];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)insertGroupItem:(id<WCEmotionGroupItem>)groupItem atIndex:(NSUInteger)index {
    [self.collectionData insertObject:groupItem atIndex:index];
    [self.collectionView reloadData];
}

- (void)removeGroupItemAtIndex:(NSUInteger)index {
    
}

- (void)updateGroupItem:(id<WCEmotionGroupItem>)groupItem atIndex:(NSUInteger)index {
    
}

#pragma mark -

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (CGRectGetWidth(self.leftView.bounds) || CGRectGetWidth(self.rightView.bounds)) {
        // TODO: change width of middle view
    }
}

#pragma mark - Getters

- (UIView *)leftView {
    if (!_leftView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGRectGetHeight(self.bounds))];
        
        _leftView = view;
    }
    
    return _leftView;
}

- (UIView *)rightView {
    if (!_rightView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGRectGetHeight(self.bounds))];
        
        _rightView = view;
    }
    
    return _rightView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        WCEmotionSliderLayout *layout = [[WCEmotionSliderLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 1.0 / [UIScreen mainScreen].scale;
        layout.minimumLineSpacing = 0;
        [layout registerClass:[WCEmotionSliderCellSeparator class] forDecorationViewOfKind:@"Separator"];
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) collectionViewLayout:layout];
        view.dataSource = self;
        view.delegate = self;
        view.alwaysBounceHorizontal = YES;
        view.backgroundColor = [UIColor clearColor];
        
        [view registerClass:[WCEmotionSliderCell class] forCellWithReuseIdentifier:NSStringFromClass([WCEmotionSliderCell class])];
        
        _collectionView = view;
    }
    
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WCEmotionSliderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WCEmotionSliderCell class]) forIndexPath:indexPath];
    id<WCEmotionGroupItem> item = self.collectionData[indexPath.row];
    
    CGSize size = item.groupIcon.size;
    if (!CGSizeEqualToSize(item.groupIconSize, CGSizeZero)) {
        size = item.groupIconSize;
    }
    
    //cell.imageView.frame = CGRectMake(UNSPECIFIED, UNSPECIFIED, size.width, size.height);
    
    cell.imageView.frame = CGRectMake((CGRectGetWidth(cell.bounds) - size.width) / 2.0, (CGRectGetHeight(cell.bounds) - size.height) / 2.0, size.width, size.height);
    cell.imageView.image = item.groupIcon;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    backgroundView.backgroundColor = [UIColor whiteColor];
    cell.backgroundView = backgroundView;
    
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
    cell.selectedBackgroundView = selectedBackgroundView;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id<WCEmotionGroupItem> item = self.collectionData[indexPath.row];
    return CGSizeMake(item.width, CGRectGetHeight(self.bounds));
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
