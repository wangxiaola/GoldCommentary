//
//  WCHomeViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/4.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCHomeViewController.h"
#import "WCPersonalViewController.h"
#import "WCMyScenicViewController.h"
#import "WCMyNarratorViewController.h"
#import "UIButton+ImageTitleStyle.h"
#import "LSBasePageTabbar.h"

@interface WCHomeViewController ()<UIScrollViewDelegate,LSBasePageTabbarDelegate>

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;//横幅
@property (weak, nonatomic) IBOutlet UILabel *earningsLabel;//收益
@property (weak, nonatomic) IBOutlet UILabel *withdrawalAmountLabel;//提现金额

@property (nonatomic, strong) LSTitlePageTabbar *titlePageTabBar;

@property (nonatomic, strong) UIScrollView *bottomContenView;
@end

@implementation WCHomeViewController
//视图将要出现
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
//视图已经出现
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
//视图将要消失
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
}
//视图已经消失
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUIviews];
    
}
#pragma mark  ----视图设置----
- (void)setUIviews
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    // 设置按钮显示样式
    [self.leftButton setButtonImageTitleStyle:(ButtonImageTitleStyleCenterDown) padding:3];
    [self.rightButton setButtonImageTitleStyle:(ButtonImageTitleStyleCenterDown) padding:3];
    
    CGFloat topHeight = CGRectGetHeight(self.bannerImageView.frame);
    // 添加选择块
    LSTitlePageTabbar *titlePageTabBar = [[LSTitlePageTabbar alloc] initWithTitleArray:@[@"我的景区",@"我的解说员"]];
    titlePageTabBar.backgroundColor = [UIColor whiteColor];
    titlePageTabBar.textFont = [UIFont systemFontOfSize:14];
    titlePageTabBar.selectedTextFont = [UIFont systemFontOfSize:15];
    titlePageTabBar.textColor = [UIColor grayColor];
    titlePageTabBar.horIndicatorSpacing = 20;
    titlePageTabBar.delegate = self;
    titlePageTabBar.horIndicatorColor = NAVIGATION_COLOR;
    titlePageTabBar.selectedTextColor = NAVIGATION_COLOR;
    titlePageTabBar.frame = CGRectMake(0, topHeight, _SCREEN_WIDTH,40);
    titlePageTabBar.edgeInset = UIEdgeInsetsMake(0, 0, 0, 0);
    titlePageTabBar.titleSpacing = 6;
    [titlePageTabBar refreshUI];
    [self.view addSubview:titlePageTabBar];
    // 添加中间线
    UIView *linView = [[UIView alloc] init];
    linView.backgroundColor = BODER_COLOR;
    [titlePageTabBar addSubview:linView];
    
    self.titlePageTabBar = titlePageTabBar;
    // 创建底部溶区
    // 内容高度
    CGFloat contenViewHeight = _SCREEN_HEIGHT - topHeight - 40;
    
    self.bottomContenView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topHeight+40, _SCREEN_WIDTH, contenViewHeight)];
    self.bottomContenView.contentSize = CGSizeMake(_SCREEN_WIDTH*2, 0);
    self.bottomContenView.backgroundColor = BACKLIST_COLOR;
    self.bottomContenView.delegate = self;
    //隐藏滚动条
    self.bottomContenView.showsHorizontalScrollIndicator = NO;
    self.bottomContenView.showsVerticalScrollIndicator = NO;
    self.bottomContenView.pagingEnabled = YES;
    [self.view addSubview:self.bottomContenView];

    // 加载我的景区
    WCMyScenicViewController *scenicVC = [[WCMyScenicViewController alloc] init];
    [self addChildViewController:scenicVC];
    UIView *scenicView = scenicVC.view;
    scenicView.frame = CGRectMake(0, 0, _SCREEN_WIDTH, contenViewHeight);
    [self.bottomContenView addSubview:scenicView];
    // 加载我的解说员
    WCMyNarratorViewController *narratorVC = [[WCMyNarratorViewController alloc] init];
    [self addChildViewController:narratorVC];
    UIView *narratorView = narratorVC.view;
    narratorView.frame = CGRectMake(_SCREEN_WIDTH, 0, _SCREEN_WIDTH, contenViewHeight);
    [self.bottomContenView addSubview:narratorView];
    
    MJWeakSelf
    [linView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.titlePageTabBar);
        make.width.equalTo(@0.6);
        make.height.equalTo(@18);
    }];
    
}

#pragma mark  ----LSBasePageTabbarDelegate----
- (void)basePageTabbar:(id<LSBasePageTabbarProtocol>)tabbar clickedPageTabbarAtIndex:(NSInteger)index;
{
    [self.bottomContenView setContentOffset:CGPointMake(_SCREEN_WIDTH*index, 0) animated:YES];
}
#pragma mark  ----UIScrollViewDelegate----
//滚动代理  scroll减速完毕调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //页码
    int pageNo= scrollView.contentOffset.x/scrollView.frame.size.width;
    [self.titlePageTabBar switchToPageAtIndex:pageNo];
}


#pragma mark  ----点击事件----
//我的
- (IBAction)leftButtonClick:(UIButton *)sender {
    
    WCPersonalViewController *personalVC = [[WCPersonalViewController alloc] init];
    [self.navigationController pushViewController:personalVC animated:YES];
}
//收入明细
- (IBAction)rightButtonClick:(UIButton *)sender {
}
//  提现
- (IBAction)withdrawalClick:(UIButton *)sender {
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
