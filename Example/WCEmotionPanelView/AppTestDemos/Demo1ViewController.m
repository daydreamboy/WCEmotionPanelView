//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "Demo1ViewController.h"
#import "PresetEmotionCell.h"
#import "WCEmotionGroupItemModel.h"
#import "WCEmotionGroupItemExtraModel.h"
#import "WCEmotionItemModel.h"

#import <WCEmotionPanel/WCEmotionPanel.h>

@interface Demo1ViewController ()
@property (nonatomic, strong) WCEmotionPanelView *emotionPanelView;
@property (nonatomic, strong) UIStepper *stepper;
@property (nonatomic, strong) UILabel *labelIndex;
@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addItemClicked:)];
    UIBarButtonItem *removeItem = [[UIBarButtonItem alloc] initWithTitle:@"Remove" style:UIBarButtonItemStylePlain target:self action:@selector(removeItemClicked:)];
    UIBarButtonItem *replaceItem = [[UIBarButtonItem alloc] initWithTitle:@"Replace" style:UIBarButtonItemStylePlain target:self action:@selector(replaceItemClicked:)];

    self.navigationItem.rightBarButtonItems = @[replaceItem, removeItem, addItem];
    
    [self.view addSubview:self.emotionPanelView];
    [self.view addSubview:self.stepper];
    [self.view addSubview:self.labelIndex];
}

#pragma mark - Getter

- (WCEmotionPanelView *)emotionPanelView {
    if (!_emotionPanelView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        WCEmotionPanelView *emotionPanelView = [[WCEmotionPanelView alloc] initWithFrame:CGRectMake(0, 200, screenSize.width, 216)];
        _emotionPanelView = emotionPanelView;
    }
    
    return _emotionPanelView;
}

- (UIStepper *)stepper {
    if (!_stepper) {
        UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectMake(10, 64 + 10, 100, 30)];
        stepper.minimumValue = 0;
        stepper.maximumValue = 0;
        [stepper addTarget:self action:@selector(stepperClicked:) forControlEvents:UIControlEventValueChanged];
        
        _stepper = stepper;
    }
    
    return _stepper;
}

- (UILabel *)labelIndex {
    if (!_labelIndex) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.stepper.frame) + 10, CGRectGetMinY(self.stepper.frame), 150, CGRectGetHeight(self.stepper.bounds))];
        label.text = @"Group Index: 0";
        
        _labelIndex = label;
    }
    
    return _labelIndex;
}

#pragma mark - Actions

- (void)stepperClicked:(id)sender {
    UIStepper *stepper = (UIStepper *)sender;
    
    self.labelIndex.text = [NSString stringWithFormat:@"Group Index: %ld", (long)stepper.value];
}

- (void)addItemClicked:(id)sender {
    NSString *emotionBundlePath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"Emoticon.bundle"];
    
    NSString *orderPlistFilePath = [emotionBundlePath stringByAppendingPathComponent:@"emotionOrder.plist"];
    NSString *codePlistFilePath = [emotionBundlePath stringByAppendingPathComponent:@"EmoticonInfo.plist"];
    
    NSMutableArray<id<WCEmotionItem>> *items = [NSMutableArray array];
    NSArray<NSString *> *emotionNameList = [NSArray arrayWithContentsOfFile:orderPlistFilePath];
    NSDictionary<NSString *, NSArray *> *emotionCodeDict = [NSDictionary dictionaryWithContentsOfFile:codePlistFilePath];
    
    for (NSUInteger i = 0; i < emotionNameList.count; i++) {
        NSString *imageName = emotionNameList[i];
        
        id<WCEmotionItem> item = [WCEmotionItemModel new];
        item.name = imageName;
        item.codes = emotionCodeDict[imageName];
        
        [items addObject:item];
    }
    
    id<WCEmotionItem> deleteItem = [WCEmotionItemModel new];
    deleteItem.name = @"message_keyboard_back";
    
    id<WCEmotionItem> sendItem = [WCEmotionItemModel new];
    sendItem.name = @"message_keyboard_back";
    
    id<WCEmotionGroupItemExtraInfo> extraInfo = [WCEmotionGroupItemExtraModel new];
    extraInfo.reservedItem1 = deleteItem;
//    extraInfo.reservedItem1 = sendItem;
//    extraInfo.reservedItem2 = deleteItem;
//
    id<WCEmotionGroupItem> groupItem = [[WCEmotionGroupItemModel alloc] initWithEmotions:items layoutSize:CGSizeMake(8, 3) extraInfo:extraInfo];
    NSString *imageName = [NSString stringWithFormat:@"EmotionGroupIcon_%d", arc4random() % 8 + 1];
    groupItem.groupIcon = [UIImage imageNamed:imageName];
    groupItem.groupIconSize = CGSizeMake(21, 21);
    groupItem.width = 45.5;
    groupItem.cellClass = [PresetEmotionCell class];
    [self.emotionPanelView insertGroupItem:groupItem atGroupIndex:self.stepper.value];
    self.stepper.maximumValue = self.stepper.maximumValue + 1;
}

- (void)removeItemClicked:(id)sender {
    [self.emotionPanelView removePagesAtGroupIndex:(NSUInteger)self.stepper.value];
    self.stepper.maximumValue = self.stepper.maximumValue - 1;
}

- (void)replaceItemClicked:(id)sender {
    NSString *emotionBundlePath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"Emoticon.bundle"];
    
    NSString *orderPlistFilePath = [emotionBundlePath stringByAppendingPathComponent:@"emotionOrder.plist"];
    NSString *codePlistFilePath = [emotionBundlePath stringByAppendingPathComponent:@"EmoticonInfo.plist"];
    
    NSMutableArray<id<WCEmotionItem>> *items = [NSMutableArray array];
    NSArray<NSString *> *emotionNameList = [NSArray arrayWithContentsOfFile:orderPlistFilePath];
    NSDictionary<NSString *, NSArray *> *emotionCodeDict = [NSDictionary dictionaryWithContentsOfFile:codePlistFilePath];
    
    for (NSUInteger i = 0; i < emotionNameList.count; i++) {
        NSString *imageName = emotionNameList[i];
        
        id<WCEmotionItem> item = [WCEmotionItemModel new];
        item.name = imageName;
        item.codes = emotionCodeDict[imageName];
        
        [items addObject:item];
    }
    
    id<WCEmotionGroupItem> groupItem = [[WCEmotionGroupItemModel alloc] initWithEmotions:items layoutSize:CGSizeMake(6, 3) extraInfo:nil];
    groupItem.groupIcon = [UIImage imageNamed:[NSString stringWithFormat:@"EmotionGroupIcon_%d", arc4random() % 8 + 1]];
    groupItem.groupIconSize = CGSizeMake(21, 21);
    groupItem.width = 45.5;
    groupItem.cellClass = [PresetEmotionCell class];
    
    NSUInteger groupIndex = self.stepper.value;
    [self.emotionPanelView updatePagesWithGroupItem:groupItem atGroupIndex:groupIndex];
}

@end
