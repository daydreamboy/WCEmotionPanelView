//
//  WCEmotionPanelView.h
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WCEmotionPanelView;
@class WCEmotionPage;
@protocol WCEmotionItem;

//@protocol WCEmotionPanelViewDataSource
//- (void)WCEmotionPanelView:(WCEmotionPanelView *)emotionPanelView cellForItem:(id<WCEmotionItem>)item atIndexPath:(NSIndexPath *)indexPath pageIndex:(NSUInteger)pageIndex groupIndex:(NSUInteger)groupIndex;
//@end

@protocol WCEmotionPanelCellDataSource
- (void)WCEmotionPage:(WCEmotionPage *)emotionPage cellForItem:(id<WCEmotionItem>)item atIndexPath:(NSIndexPath *)indexPath;
@end

@protocol WCEmotionGroupItem;

@interface WCEmotionPanelView : UIView

@property (nonatomic, assign) NSUInteger countOfGroupItems;
//@property (nonatomic, weak) id<WCEmotionPanelViewDataSource> dataSource;

- (void)insertGroupItem:(id<WCEmotionGroupItem>)groupItem atGroupIndex:(NSUInteger)groupIndex;
- (void)removePagesAtGroupIndex:(NSUInteger)index;
- (void)updatePagesWithGroupItem:(id<WCEmotionGroupItem>)groupItem atGroupIndex:(NSUInteger)groupIndex;

@end

NS_ASSUME_NONNULL_END
