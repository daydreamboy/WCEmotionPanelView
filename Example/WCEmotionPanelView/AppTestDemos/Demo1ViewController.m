//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "Demo1ViewController.h"
#import <WCEmotionPanelView/WCEmotionPanelView.h>
#import <WCEmotionPanelView/WCEmotionGroupItem.h>
#import <WCEmotionPanelView/WCEmotionPage.h>

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
    WCEmotionGroupItem *groupItem = [[WCEmotionGroupItem alloc] initWithEmotions:nil];
    groupItem.numberOfPages = arc4random() % 3 + 1;
    [self.emotionPanelView insertGroupItem:groupItem atGroupIndex:self.stepper.value];
    self.stepper.maximumValue = self.stepper.maximumValue + 1;
}

- (void)removeItemClicked:(id)sender {
    [self.emotionPanelView removePagesAtGroupIndex:(NSUInteger)self.stepper.value];
    self.stepper.maximumValue = self.stepper.maximumValue - 1;
}

- (void)replaceItemClicked:(id)sender {
    WCEmotionGroupItem *groupItem = [[WCEmotionGroupItem alloc] initWithEmotions:nil];
    groupItem.numberOfPages = arc4random() % 3 + 1;
    
    NSUInteger groupIndex = self.stepper.value;
    [self.emotionPanelView updatePagesWithGroupItem:groupItem atGroupIndex:groupIndex];
}

@end
