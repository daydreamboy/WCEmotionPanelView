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
@protocol WCEmotionGroupItem;

@protocol WCEmotionPanelViewDelegate <NSObject>
- (void)WCEmotionPanelView:(WCEmotionPanelView *)emotionPanelView didSelectGroupDummyItem:(id<WCEmotionGroupItem>)groupItem atGroupIndex:(NSUInteger)groupIndex;

- (UIView *)WCEmotionPanelView:(WCEmotionPanelView *)emotionPanelView leftViewWithSliderHeight:(CGFloat)sliderHeight;
- (UIView *)WCEmotionPanelView:(WCEmotionPanelView *)emotionPanelView rightViewWithSliderHeight:(CGFloat)sliderHeight;

@end

@protocol WCEmotionPanelCellDataSource
- (void)WCEmotionPage:(WCEmotionPage *)emotionPage cellForItem:(id<WCEmotionItem>)item atIndexPath:(NSIndexPath *)indexPath;
@end


@protocol WCEmotionGroupItem;

@interface WCEmotionPanelView : UIView

@property (nonatomic, assign) NSUInteger countOfGroupItems;
@property (nonatomic, weak) id<WCEmotionPanelViewDelegate> delegate;

//@property (nonatomic, strong) UIView *sliderLeftView;
//@property (nonatomic, strong) UIView *sliderRightView;

- (void)insertGroupItem:(id<WCEmotionGroupItem>)groupItem atGroupIndex:(NSUInteger)groupIndex;
- (void)removePagesAtGroupIndex:(NSUInteger)index;
- (void)updatePagesWithGroupItem:(id<WCEmotionGroupItem>)groupItem atGroupIndex:(NSUInteger)groupIndex;

@end

NS_ASSUME_NONNULL_END
