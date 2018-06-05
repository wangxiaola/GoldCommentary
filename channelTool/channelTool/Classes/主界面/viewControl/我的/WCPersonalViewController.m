//
//  WCPersonalViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/7.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCPersonalViewController.h"
#import "WCResetPasswordViewController.h"
#import "WCBasisInfoViewController.h"
#import "WCInfoModifyViewController.h"
#import "WCAddBankViewController.h"
#import "WCPersonalHeaderView.h"
#import "TBMoreReminderView.h"
#import "ClearCacheTool.h"
#import "TBChoosePhotosTool.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface WCPersonalViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *lefInfoData;

@property (nonatomic, strong) WCPersonalHeaderView *headerView;

@property (nonatomic, strong) TBChoosePhotosTool *imageTool;
@end

@implementation WCPersonalViewController
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = BACKLIST_COLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
//视图将要出现
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (_tableView) {
        
        [_tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addData];
    [self createViews];
}
#pragma mark  ----添加数据----
- (void)addData
{
    _lefInfoData = [NSArray arrayWithObjects:
                    @[@{@"name":@"实名认证",@"image":@"user_personal"},
                      @{@"name":@"收款银行",@"image":@"user_bank"},
                      @{@"name":@"新手攻略",@"image":@"user_ strategy"},
                      @{@"name":@"意见反馈",@"image":@"user_opinion"},
                      @{@"name":@"清理缓存",@"image":@"user_ cache"},],
                    @[@{@"name":@"设置密码",@"image":@"user_password"},
                      @{@"name":@"退出账号",@"image":@"user_ account"},],nil];
    
    self.imageTool = [[TBChoosePhotosTool alloc] init];
}

#pragma mark  ----视图创建----
- (void)createViews
{
    self.headerView = [WCPersonalHeaderView loadNibViewStyle:PersonalHeaderViewStyleDefault];
    [self.view addSubview:self.headerView];
    
    TBWeakSelf
    [self.headerView setGoBack:^{
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    }];
    [self.headerView setEditor:^{
        // 个人信息修改
        WCInfoModifyViewController *vc = [[WCInfoModifyViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        [vc setUpdateHeaderImageView:^{
            [weakSelf setHeaderImageView];
        }];
    }];
    
    [self.headerView setUpdataHeaderPortrait:^{
        
        [weakSelf showHeaderPortrait];
    }];
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, CGRectGetHeight(self.headerView.frame), _SCREEN_WIDTH, _SCREEN_HEIGHT-CGRectGetHeight(self.headerView.frame));
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.tableView reloadData];
    [self setHeaderImageView];
    
}
- (void)showHeaderPortrait
{
    if ([UserInfo account].headimg) {
        
        [self.imageTool showPreviewPhotosArray:@[[UserInfo account].headimg] baseView:self.headerView.headerImageView selected:0];
    }
}
- (void)setHeaderImageView
{
    UserInfo *info = [UserInfo account];
    if (info) {
        
        [ZKUtil downloadImage:self.headerView.headerImageView imageUrl:info.headimg duImageName:@"header_default"];
        
        self.headerView.nameLabel.text = info.name;
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.lefInfoData[section];
    return array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    }
    NSArray *array = self.lefInfoData[indexPath.section];
    NSDictionary *dic = array[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:[dic valueForKey:@"image"]];
    cell.textLabel.text = [dic valueForKey:@"name"];
    cell.detailTextLabel.text = @"";
    
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:4 inSection:0]]) {
        // 缓存大小
        [ClearCacheTool obtainCacheSize:^(CGFloat cacheSize) {
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",cacheSize];
        }];
    }
    
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:0]] ) {
        
        NSInteger isPass = [UserInfo account].certification.ispass.integerValue;
        NSString *stateName = @"";
        switch (isPass) {
            case 0:
                stateName = @"未认证";
                break;
            case 1:
                stateName = @"已认证";
                break;
            case 2:
                stateName = @"正在审核";
                break;
                
            default:
                break;
        }
        cell.detailTextLabel.text = stateName;
    }
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:1 inSection:0]] ) {
        
        UserBankInfo *infoBank = [UserInfo account].bankInfo;
        NSInteger bank = 0;
        if (infoBank) {
            
            bank = infoBank.isbank;
        }
        NSString *bankInfo = bank == 1?@"已绑定":@"未绑定";
        cell.detailTextLabel.text = bankInfo;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self jumpViewControllerIndexPath:indexPath];
}
#pragma mark  ----跳转页面----
- (void)jumpViewControllerIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dataArray = [_lefInfoData objectAtIndex:indexPath.section];
    NSDictionary *dic  = [dataArray objectAtIndex:indexPath.row];
    NSString *key      = [dic valueForKey:@"name"];
    
    if ([key isEqualToString:@"实名认证"])
    {
        if ([UserInfo account].userID) {
            
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"main" bundle:nil];
            WCBasisInfoViewController *basisInfoVC = [board instantiateViewControllerWithIdentifier:@"WCBasisInfoViewControllerID"];
            [self.navigationController pushViewController:basisInfoVC animated:YES];
        }
        else
        {
            [UIView addMJNotifierWithText:@"请先登录" dismissAutomatically:YES];
        }
        
    }
    else if ([key isEqualToString:@"收款银行"]){
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"main" bundle:nil];
        WCAddBankViewController *bankVC = [board instantiateViewControllerWithIdentifier:@"WCAddBankViewControllerID"];
        [self.navigationController pushViewController:bankVC animated:YES];
        
    }
    else if ([key isEqualToString:@"新手攻略"])
    {
        [self.navigationController pushViewController:[[NSClassFromString(@"WCStrategyViewController") alloc] init] animated:YES];
    }
    else if ([key isEqualToString:@"意见反馈"])
    {
        [self.navigationController pushViewController:[[NSClassFromString(@"WCFeedbackViewController") alloc] init] animated:YES];
    }
    else if ([key isEqualToString:@"清理缓存"])
    {
        [ClearCacheTool clearActionSuccessful:^{
            [UIView addMJNotifierWithText:@"清理完毕" dismissAutomatically:YES];
            [self updateClearSize];
        }];
    }
    else if ([key isEqualToString:@"设置密码"])
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"login" bundle:nil];
        
        WCResetPasswordViewController *registrationVC = [board instantiateViewControllerWithIdentifier:@"WCResetPasswordViewControllerID"];
        registrationVC.phone = [UserInfo account].phone;
        [self.navigationController pushViewController:registrationVC animated:YES];
    }
    else if ([key isEqualToString:@"退出账号"])
    {
        [self logOutClick];
    }
}
/**
 更新缓存大小
 */
- (void)updateClearSize
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    if (cell) {
        [ClearCacheTool obtainCacheSize:^(CGFloat cacheSize) {
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",cacheSize];
        }];
    }
}
#pragma mark --- 退出登录---
- (void)logOutClick
{
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲，是否退出当前账号?"];
    [more showHandler:^{
        
        [self dataCleaning];
    }];
    
}
// 数据清理
- (void)dataCleaning
{
    
#pragma mark  ----注销APP别名----
    
    [UserInfo saveAccount:[UserInfo new]];
    
    [ClearCacheTool clearActionSuccessful:^{
        
        [self pushMainViewController];
    }];
    
}
- (void)pushMainViewController
{
    hudDismiss();
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 加载storboard
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"login" bundle:nil];
        
        UIViewController *viewController = [board instantiateInitialViewController];
        
        [APPDELEGATE window].rootViewController = viewController;
    });
}
- (void)dealloc
{
    self.imageTool = nil;
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
