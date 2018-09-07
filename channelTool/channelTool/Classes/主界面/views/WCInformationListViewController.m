//
//  WCInformationListViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/8/31.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCInformationListViewController.h"
#import "WCInformationAddViewController.h"
#import "WCInformationTableViewCell.h"
#import "TBMoreReminderView.h"
#import "WCUploadPromptView.h"
#import "WCInformationListMode.h"
@interface WCInformationListViewController ()

@end

@implementation WCInformationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark ---参数配置---
- (void)initData
{
    [super initData];
    self.modeClass = [WCInformationListMode class];
    self.parameter[@"rows"] = @"20";
    self.parameter[@"interfaceId"] = @"332";
    self.parameter[@"shopid"] = self.scenicID;
    
    self.parameter[@"type"] = [NSNumber numberWithInteger:self.listType];
    self.parameter[@"id"] = [UserInfo account].userID;
    
}
#pragma mark ---初始化视图----
- (void)setUpView
{
    [super setUpView];
    self.tableView.estimatedRowHeight = 80.0f;
    self.tableView.backgroundColor = BACKLIST_COLOR;
    [self.tableView registerNib:[UINib nibWithNibName:@"WCInformationTableViewCell" bundle:nil] forCellReuseIdentifier:WCInformationTableViewCellID];
    
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
    WCInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WCInformationTableViewCellID];
    
    if (self.roots.count > indexPath.section) {
        [cell updataCellData:self.roots[indexPath.section]];
    }
    [cell setDeleteInformation:^(WCInformationListMode *mode) {
        [self deleteInformation:mode];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // 加载storboard
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"main" bundle:nil];
    
    WCInformationAddViewController *viewController = [board instantiateViewControllerWithIdentifier:@"WCInformationAddViewControllerID"];
    viewController.mode = self.roots[indexPath.section];
    [self.navigationController pushViewController:viewController animated:YES];
    
}
#pragma mark  ----tool----
- (void)deleteInformation:(WCInformationListMode *)mode
{
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:[NSString stringWithFormat:@"亲，是否删除<%@>%@",mode.name,mode.type == 0?@"服务点":@"厕所"]];
    [more showHandler:^{
        
        [self postDeleteData:mode];
        
    }];
}
#pragma mark  ----删除请求----
- (void)postDeleteData:(WCInformationListMode *)mode{
    
    NSDictionary *dic = @{@"interfaceId":@"335",
                          @"id":[UserInfo account].userID,
                          @"sid":mode.ID};
    
    hudShopWUploadProgress(0.8, @"正在提交信息");
    TBWeakSelf
    [[ZKPostHttp shareInstance] POST:POST_URL params:dic success:^(id  _Nonnull responseObject) {
        
        NSString *msg;
        BOOL isSuccessful;
        if ([[responseObject valueForKey:@"errcode"] isEqualToString:@"00000"]) {
            
            msg = @"删除成功";
            isSuccessful = YES;
            [weakSelf reloadData];
        }
        else
        {
            isSuccessful = NO;
            msg = [responseObject valueForKey:@"errmsg"];
        }
        [WCUploadPromptView showPromptString:msg isSuccessful:isSuccessful clickButton:^{
        }];
        hudDismiss();
        
    } failure:^(NSError * _Nonnull error) {
        
        hudShowError(@"网络异常，请查看网络连接");
    }];
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
