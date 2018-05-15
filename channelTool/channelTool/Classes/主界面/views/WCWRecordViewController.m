//
//  WCWRecordViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/14.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCWRecordViewController.h"
#import "WCWRecordTableViewCell.h"
#import "WCRecordTimeSelectView.h"

@interface WCWRecordViewController ()
@property (nonatomic, strong) WCRecordTimeSelectView *timeView;
@end

@implementation WCWRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark ---参数配置---
- (void)initData
{
    [super initData];
    self.modeClass = [WCWRecordMode class];
    //    self.parameter[@"rows"] = @"20";
    
}
#pragma mark ---初始化视图----
- (void)setUpView
{
    [super setUpView];
    self.tableView.estimatedRowHeight = 44;
    [self.tableView registerNib:[UINib nibWithNibName:@"WCWRecordTableViewCell" bundle:nil] forCellReuseIdentifier:WCWRecordTableViewCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.timeView = [[WCRecordTimeSelectView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 44)];
    self.tableView.tableHeaderView = self.timeView;
    TBWeakSelf
    [self.timeView setTimeSelectEnd:^(NSString *time) {
        
        [weakSelf.timeView updateAmount:@"提现：￥222.33" time:time];
    }];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM";
    NSString *newTime = [formatter stringFromDate:date];
    [self.timeView updateAmount:@"收入：￥222.33" time:newTime];
}

/**
 更新时间参数 重新请求
 
 @param time 时间
 */
- (void)updataTime:(NSString *)time
{
    if (time.length > 0) {
        
        self.parameter[@"time"] = time;
        [self.tableView.mj_header beginRefreshing];
    }
}
#pragma mark  ----UITableViewDataSource && UITableViewDelegate----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCWRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WCWRecordTableViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.roots.count > indexPath.section) {
        [cell updataCellMode:self.roots[indexPath.section]];
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
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
