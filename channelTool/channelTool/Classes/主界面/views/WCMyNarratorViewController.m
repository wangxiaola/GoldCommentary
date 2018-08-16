//
//  WCMyNarratorViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/4.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCMyNarratorViewController.h"
#import "WCMyNarratorTableViewCell.h"
#import "WCMyNarratorMode.h"
@interface WCMyNarratorViewController ()

@end

@implementation WCMyNarratorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark ---参数配置---
- (void)initData
{
    [super initData];
    self.modeClass = [WCMyNarratorMode class];
    
    self.parameter[@"rows"] = @"20";
    self.parameter[@"interfaceId"] = @"297";
    self.parameter[@"id"] = [UserInfo account].userID;
}
#pragma mark ---初始化视图----
- (void)setUpView
{
    [super setUpView];
    self.view.backgroundColor = BACKLIST_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"WCMyNarratorTableViewCell" bundle:nil] forCellReuseIdentifier:WCMyNarratorTableViewCellID];
    TBWeakSelf
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view.mas_left).offset(8);
        make.right.equalTo(weakSelf.view.mas_right).offset(-8);
    }];
}

#pragma mark  ----UITableViewDataSource && UITableViewDelegate----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.roots.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCMyNarratorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WCMyNarratorTableViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.roots.count > indexPath.section)
    {
        WCMyNarratorMode *mode = self.roots[indexPath.section];
        mode.section = indexPath.section;
        [cell updataCellData:mode];
    }
    
    [cell setUpdataCell:^(NSInteger section) {
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

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
