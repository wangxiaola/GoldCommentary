//
//  WCMyScenicViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/4.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCMyScenicViewController.h"
#import "WCAuthenticationPopupsView.h"
#import "WCCreateScenicViewController.h"
#import "WCAddScenicViewController.h"
#import "WCMyScenicTableViewCell.h"
#import "WCMyScenicMode.h"
#import <WXApi.h>
@interface WCMyScenicViewController ()
// 是否有微信app
@property (nonatomic, assign) BOOL isWxApp;
@end

@implementation WCMyScenicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isWxApp = [WXApi isWXAppInstalled];
}
#pragma mark ---参数配置---
- (void)initData
{
    [super initData];
    self.modeClass = [WCMyScenicMode class];
    self.parameter[@"rows"] = @"20";
    self.parameter[@"interfaceId"] = @"296";
    self.parameter[@"id"] = [UserInfo account].userID;
    
}
#pragma mark ---初始化视图----
- (void)setUpView
{
    [super setUpView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WCMyScenicTableViewCell" bundle:nil] forCellReuseIdentifier:WCMyScenicTableViewCellID];
    
    CGFloat bottomHeight = 20;
    // 设配iPhone X底部
    if (_SCREEN_HEIGHT == 812) {
        bottomHeight = 34;
    }
    UIButton *addScenicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addScenicButton setBackgroundImage:[UIImage imageNamed:@"addJq"] forState:(UIControlStateNormal)];
    [addScenicButton addTarget:self action:@selector(addScenicClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addScenicButton];
    
    MJWeakSelf
    [addScenicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-bottomHeight);
    }];
    
    
}
#pragma mark  ----景区添加----
- (void)addScenicClick
{
    UserInfo *info = [UserInfo account];
    if (info.certification.ID.length == 0) {
        [WCAuthenticationPopupsView show];
        return;
    }
    // 加载storboard
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"main" bundle:nil];
    
    WCCreateScenicViewController *viewController = [board instantiateViewControllerWithIdentifier:@"WCCreateScenicViewControllerID"];
    [self.navigationController pushViewController:viewController animated:YES];
    TBWeakSelf
    [viewController setRefreshTableView:^{
        
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
}
- (void)editorSecnicInfo:(WCMyScenicMode *)mode
{
    // 加载storboard
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"main" bundle:nil];
    
    WCCreateScenicViewController *viewController = [board instantiateViewControllerWithIdentifier:@"WCCreateScenicViewControllerID"];
    viewController.ID = mode.ID;
    [self.navigationController pushViewController:viewController animated:YES];
    TBWeakSelf
    [viewController setRefreshTableView:^{
        
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
}
#pragma mark  ----默认图位置----
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView;
{
    return -60;
}

#pragma mark  ----UITableViewDataSource && UITableViewDelegate----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.roots.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCMyScenicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WCMyScenicTableViewCellID];
    
    if (self.roots.count > indexPath.section) {
        [cell updataCellData:self.roots[indexPath.section]];
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  //    0审核中 1成功 2未通过
    WCMyScenicMode *mode = self.roots[indexPath.section];
    
    if (mode.state.integerValue == 1) {
        WCAddScenicViewController *vc = [[WCAddScenicViewController alloc] init];
        
        vc.scenicID = mode.ID;
        [self.navigationController pushViewController:vc animated:YES];
        TBWeakSelf
        [vc setRefreshTableView:^{
            
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
    }
    else
    {
        [UIView addMJNotifierWithText:@"该景区暂未审核通过" dismissAutomatically:YES];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
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
