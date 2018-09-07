//
//  WCInformationViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/8/29.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCInformationViewController.h"
#import "WCInformationListViewController.h"
#import "WCInformationAddViewController.h"
#import "LSBasePageTabbar.h"
@interface WCInformationViewController ()<LSBasePageTabbarDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) WCInformationListViewController *toiletVC;
@property (nonatomic, strong) WCInformationListViewController *serviceVC;
@property (nonatomic, strong) LSTitlePageTabbar *titlePageTabBar;
@property (nonatomic, strong) UIScrollView *bottomContenView;

@end

@implementation WCInformationViewController
//视图将要出现
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
//视图将要消失
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"信息采集";
    [self setUIviews];
}
#pragma mark  ----视图设置----
- (void)setUIviews
{
    // 添加选择块
    LSTitlePageTabbar *titlePageTabBar = [[LSTitlePageTabbar alloc] initWithTitleArray:@[@"厕所",@"服务点"]];
    titlePageTabBar.backgroundColor = [UIColor whiteColor];
    titlePageTabBar.textFont = [UIFont systemFontOfSize:14];
    titlePageTabBar.selectedTextFont = [UIFont systemFontOfSize:15];
    titlePageTabBar.textColor = [UIColor grayColor];
    titlePageTabBar.horIndicatorSpacing = 20;
    titlePageTabBar.delegate = self;
    titlePageTabBar.horIndicatorColor = NAVIGATION_COLOR;
    titlePageTabBar.selectedTextColor = NAVIGATION_COLOR;
    titlePageTabBar.frame = CGRectMake(0, 0, _SCREEN_WIDTH, 50);
    titlePageTabBar.edgeInset = UIEdgeInsetsMake(0, 0, 0, 0);
    titlePageTabBar.titleSpacing = 6;
    [titlePageTabBar refreshUI];
    [self.view addSubview:titlePageTabBar];
    // 添加中间线
    UIView *linView = [[UIView alloc] init];
    linView.backgroundColor = BODER_COLOR;
    [titlePageTabBar addSubview:linView];
    
    self.titlePageTabBar = titlePageTabBar;
    
    
    //获取状态栏的rect
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    //获取导航栏的rect
    CGRect navRect = self.navigationController.navigationBar.frame;
//    那么导航栏+状态栏的高度
    CGFloat navHeight =  statusRect.size.height+navRect.size.height;
    // 内容高度
    CGFloat contenViewHieght = _SCREEN_HEIGHT - navHeight - CGRectGetHeight(self.titlePageTabBar.frame);
    // 创建底部溶区
    
    self.bottomContenView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.titlePageTabBar.frame), _SCREEN_WIDTH, contenViewHieght)];
    self.bottomContenView.contentSize = CGSizeMake(_SCREEN_WIDTH*2, 0);
    self.bottomContenView.backgroundColor = BACKLIST_COLOR;
    self.bottomContenView.delegate = self;
    //隐藏滚动条
    self.bottomContenView.showsHorizontalScrollIndicator = NO;
    self.bottomContenView.showsVerticalScrollIndicator = NO;
    self.bottomContenView.pagingEnabled = YES;
    [self.view addSubview:self.bottomContenView];
    
    
    self.toiletVC = [[WCInformationListViewController alloc] init];
    self.toiletVC.listType = InformationListToilet;
    self.toiletVC.scenicID = self.scenicID;
    [self addChildViewController:self.toiletVC];
    UIView *toiletView = self.toiletVC.view;
    toiletView.frame = CGRectMake(0, 0, _SCREEN_WIDTH, contenViewHieght);
    [self.bottomContenView addSubview:toiletView];
    
    self.serviceVC = [[WCInformationListViewController alloc] init];
    self.serviceVC.listType = InformationListToiletServicePlace;
    self.serviceVC.scenicID = self.scenicID;
    [self addChildViewController:self.serviceVC];
    UIView *serviceView = self.serviceVC.view;
    serviceView.frame = CGRectMake(_SCREEN_WIDTH, 0, _SCREEN_WIDTH, contenViewHieght);
    [self.bottomContenView addSubview:serviceView];
    
    
    CGFloat bottomHeight = 20;
    // 设配iPhone X底部
    if (_SCREEN_HEIGHT == 812) {
        bottomHeight = 34;
    }
    UIButton *addInformationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addInformationButton addTarget:self action:@selector(addInformationClick) forControlEvents:UIControlEventTouchUpInside];
    addInformationButton.titleLabel.font = [UIFont systemFontOfSize:16];
    addInformationButton.backgroundColor = NAVIGATION_COLOR;
    [addInformationButton setTitle:@"创 建 采 集 点" forState:UIControlStateNormal];
    [addInformationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addInformationButton.layer.cornerRadius = 4;
    [self.view addSubview:addInformationButton];
    
    // 添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInformList:) name:@"NoticeInformUpdate" object:nil];
    
    MJWeakSelf
    [linView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.titlePageTabBar);
        make.width.equalTo(@0.6);
        make.height.equalTo(@18);
    }];

    [addInformationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.equalTo(@44);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-bottomHeight);
    }];
    

}
#pragma mark  ----点击事件----
- (void)addInformationClick
{
    // 加载storboard
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"main" bundle:nil];
    
    WCInformationAddViewController *viewController = [board instantiateViewControllerWithIdentifier:@"WCInformationAddViewControllerID"];
    viewController.scenicID = self.scenicID;
    [self.navigationController pushViewController:viewController animated:YES];
    
}
#pragma mark  ----通知刷新列表----
- (void)updateInformList:(NSNotification *)notif
{
    NSInteger type = [[notif.userInfo valueForKey:@"type"] integerValue];
    
    if (type == 3) {
        
        [self.serviceVC reloadData];
        [self.toiletVC reloadData];
    }
    else
    {
        type == 0 ? [self.serviceVC reloadData]:[self.toiletVC reloadData];
    }
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
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
