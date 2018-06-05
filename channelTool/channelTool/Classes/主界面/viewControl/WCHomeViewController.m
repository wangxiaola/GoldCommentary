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
#import "WCBillViewController.h"
#import "TBWithdrawalViewController.h"
#import "LSBasePageTabbar.h"
#import "CitiesDataTool.h"
#import "WCMyIncomeMode.h"
#import "TBMoreReminderView.h"

@interface WCHomeViewController ()<UIScrollViewDelegate,LSBasePageTabbarDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;//横幅
@property (weak, nonatomic) IBOutlet UILabel *earningsLabel;//收益
@property (weak, nonatomic) IBOutlet UILabel *withdrawalAmountLabel;//提现金额

@property (nonatomic, strong) LSTitlePageTabbar *titlePageTabBar;

@property (nonatomic, strong) UIScrollView *bottomContenView;
/**
 收益数据
 */
@property (nonatomic, strong) WCMyIncomeMode *incomeMode;
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
    [self setBaseData];
    [self requestUserData];
}
#pragma mark  ----视图设置----
- (void)setUIviews
{
    
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

// 设置基础数据
- (void)setBaseData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[CitiesDataTool sharedManager] requestGetData];
    });
    TBWeakSelf
    [[ZKPostHttp shareInstance] POST:POST_URL params:@{@"id":[UserInfo account].userID,@"interfaceId":@"298"} success:^(id  _Nonnull responseObject) {
        
        if ([[responseObject valueForKey:@"errcode"] isEqualToString:@"00000"]) {
            
            weakSelf.incomeMode = [WCMyIncomeMode mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
            weakSelf.earningsLabel.text = weakSelf.incomeMode.last? :@"0.00";
            NSString *txString = [NSString stringWithFormat:@"可提现：%@元",weakSelf.incomeMode.balance? :@"0.00"];
            weakSelf.withdrawalAmountLabel.text = txString;
            
        }
        else
        {
            [UIView addMJNotifierWithText:[responseObject valueForKey:@"errmsg"] dismissAutomatically:YES];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [UIView addMJNotifierWithText:@"网络异常，请查看网络连接" dismissAutomatically:YES];
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
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        WCPersonalViewController *personalVC = [[WCPersonalViewController alloc] init];
        [self.navigationController pushViewController:personalVC animated:YES];
    }];
    
}
//收入明细
- (IBAction)rightButtonClick:(UIButton *)sender {
    
    // 加载storboard
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"main" bundle:nil];
        
        WCBillViewController *viewController = [board instantiateViewControllerWithIdentifier:@"WCBillViewControllerID"];
        viewController.incomeMode = self.incomeMode;
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    
}
//  提现
- (IBAction)withdrawalClick:(UIButton *)sender {
    
    if ([UserInfo account].bankInfo.isbank == 1) {

        if (self.incomeMode.balance.doubleValue == 0) {
            
            [UIView addMJNotifierWithText:@"余额为0不能提现" dismissAutomatically:YES];
            return;
        }
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"main" bundle:nil];
        
        TBWithdrawalViewController *viewController = [board instantiateViewControllerWithIdentifier:@"TBWithdrawalViewControllerID"];
        viewController.money = self.incomeMode.balance;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        TBMoreReminderView *moreView = [[TBMoreReminderView alloc] initShowPrompt:@"亲，您暂未绑定收款账号，现在去绑定银行卡吗？"];
        [moreView showHandler:^{
         
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"main" bundle:nil];
            UIViewController *bankVC = [board instantiateViewControllerWithIdentifier:@"WCAddBankViewControllerID"];
            [self.navigationController pushViewController:bankVC animated:YES];
        }];
    }
    
}
#pragma mark  ----数据请求----
/**
 请求用户基本信息
 */
- (void)requestUserData
{
    UserInfo *info = [UserInfo account];
    
    dispatch_group_t group = dispatch_group_create();
    
    //验证实名认证
    dispatch_group_enter(group);
    
    NSDictionary *dicCard = @{@"interfaceId":@"295",
                          @"id":info.userID};
    
    [[ZKPostHttp shareInstance] POST:POST_URL params:dicCard success:^(id  _Nonnull responseObject) {
        
        if ([[responseObject valueForKey:@"errcode"] isEqualToString:@"00000"]) {
            
            UserCertification *cer = [UserCertification mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
            info.certification = cer;
            dispatch_group_leave(group);
        }
    } failure:^(NSError * _Nonnull error) {
        
        dispatch_group_leave(group);
    }];
    
    // 银行信息
    dispatch_group_enter(group);
    
    NSDictionary *dicBank = @{@"interfaceId":@"312",
                          @"id":info.userID};
    
    [[ZKPostHttp shareInstance] POST:POST_URL params:dicBank success:^(id  _Nonnull responseObject) {
        
        if ([[responseObject valueForKey:@"errcode"] isEqualToString:@"00000"]) {
            
            UserBankInfo *bankInfo = [UserBankInfo mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
            info.bankInfo = bankInfo;
            dispatch_group_leave(group);
        }
    } failure:^(NSError * _Nonnull error) {
        
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        [UserInfo saveAccount:info];
    });
    
//    [[ZKPostHttp shareInstance] POST:POST_URL params:@{@"interfaceId":@"316"} success:^(id  _Nonnull responseObject) {
//        
//        NSLog(@"%@",responseObject);
//        
//    } failure:^(NSError * _Nonnull error) {
//        
//    }];
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
