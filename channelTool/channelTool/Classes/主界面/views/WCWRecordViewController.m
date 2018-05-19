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

    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *newTime = [formatter stringFromDate:date];
    NSString *endTime = [newTime stringByReplacingCharactersInRange:NSMakeRange(newTime.length-2, 2) withString:@"01"];
    
    self.parameter[@"rows"] = @"20";
    self.parameter[@"interfaceId"] = @"300";
    self.parameter[@"sdate"] = endTime;
    self.parameter[@"edate"] = newTime;
    self.parameter[@"id"] = [UserInfo account].userID;
    
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
    [self.timeView setTimeSelectEnd:^(NSString *state, NSString *end) {
        
        weakSelf.parameter[@"sdate"] = state;
        weakSelf.parameter[@"edate"] = end;
        [weakSelf.tableView.mj_header beginRefreshing];
        
    }];

    [self.timeView updateAmount:@"提现：￥00.00" time:[NSString stringWithFormat:@"%@至%@",self.parameter[@"sdate"],self.parameter[@"edate"]]];
}

/**
 原生数据
 
 @param dictionary 数据
 */
- (void)originalData:(NSDictionary *)dictionary;
{
    NSString *numbaer = [[dictionary valueForKey:@"data"] valueForKey:@"number"];
    NSString *srString = [NSString stringWithFormat:@"提现：￥%@",numbaer? :@"0.00"];
    [self.timeView updateAmount:srString time:[NSString stringWithFormat:@"%@至%@",self.parameter[@"sdate"],self.parameter[@"edate"]]];
}
#pragma mark  ----UITableViewDataSource && UITableViewDelegate----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.roots.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCWRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WCWRecordTableViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.roots.count > indexPath.row) {
        [cell updataCellMode:self.roots[indexPath.row]];
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
