//
//  WCStrategyViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/6/5.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCStrategyViewController.h"
#import "SDCycleScrollView.h"

@interface WCStrategyViewController ()

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end

@implementation WCStrategyViewController


- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView)
    {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, _SCREEN_HEIGHT) shouldInfiniteLoop:YES imageNamesGroup:@[@"strategy_1",@"strategy_2",@"strategy_3"]];
        _cycleScrollView.showPageControl = YES;
        _cycleScrollView.pageControlStyle =SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
        _cycleScrollView.pageDotColor = [UIColor whiteColor];
        _cycleScrollView.pageControlBottomOffset = 40;
        _cycleScrollView.pageControlBottomOffset = 10;
        _cycleScrollView.autoScroll = NO;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    }
    return _cycleScrollView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.cycleScrollView adjustWhenControllerViewWillAppera];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
}
#pragma mark ---initView---
- (void)setUpView
{
    [self.view addSubview:self.cycleScrollView];
    
    if (NSFoundationVersionNumber>=NSFoundationVersionNumber_iOS_8_0) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        self.extendedLayoutIncludesOpaqueBars = NO;
        
        self.modalPresentationCapturesStatusBarAppearance = NO;
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"tutorialReturn"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(tutorialReturnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(14);
        make.bottom.equalTo(self.view.mas_bottom).offset(-14);
    }];
    
}
- (void)tutorialReturnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
