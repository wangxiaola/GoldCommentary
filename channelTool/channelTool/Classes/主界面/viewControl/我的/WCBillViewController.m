//
//  WCBillViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/9.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCBillViewController.h"
#import "WCERecordViewController.h"
#import "WCWRecordViewController.h"
#import "LSBasePageTabbar.h"



@interface WCBillViewController ()<UIScrollViewDelegate,LSBasePageTabbarDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
// 总收益
@property (weak, nonatomic) IBOutlet UILabel *earningsLabel;
//出账
@property (weak, nonatomic) IBOutlet UILabel *chuZhangLabel;
//未出账
@property (weak, nonatomic) IBOutlet UILabel *notCZLabel;

@property (nonatomic, strong) LSTitlePageTabbar *titlePageTabBar;

@property (nonatomic, strong) UIScrollView *bottomContenView;



@end

@implementation WCBillViewController

- (void )viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUIViews];
}
#pragma mark  ----设置视图属性----
- (void)setUIViews
{


    CGFloat topHeight = CGRectGetHeight(self.headerImageView.frame);
    // 添加选择块
    LSTitlePageTabbar *titlePageTabBar = [[LSTitlePageTabbar alloc] initWithTitleArray:@[@"收入明细",@"提现记录"]];
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
    WCERecordViewController *eRecordVC = [[WCERecordViewController alloc] init];
    [self addChildViewController:eRecordVC];
    UIView *eRecordView = eRecordVC.view;
    eRecordView.frame = CGRectMake(0, 0, _SCREEN_WIDTH, contenViewHeight);
    [self.bottomContenView addSubview:eRecordView];
    // 加载我的解说员
    WCWRecordViewController *wRecordVC = [[WCWRecordViewController alloc] init];
    [self addChildViewController:wRecordVC];
    UIView *wRecordView = wRecordVC.view;
    wRecordView.frame = CGRectMake(_SCREEN_WIDTH, 0, _SCREEN_WIDTH, contenViewHeight);
    [self.bottomContenView addSubview:wRecordView];
    
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

#pragma mark  ----goBack----

- (IBAction)goBack:(UIButton *)sender {
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
