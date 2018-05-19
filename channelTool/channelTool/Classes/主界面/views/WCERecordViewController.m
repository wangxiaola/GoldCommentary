//
//  WCERecordViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/14.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCERecordViewController.h"
#import "WCERecordTableViewCell.h"
#import "WCRecordTimeSelectView.h"
@interface WCERecordViewController ()

@property (nonatomic, strong) WCRecordTimeSelectView *timeView;

@end

@implementation WCERecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark ---参数配置---
- (void)initData
{
    [super initData];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *newTime = [formatter stringFromDate:date];
    NSString *endTime = [newTime stringByReplacingCharactersInRange:NSMakeRange(newTime.length-2, 2) withString:@"01"];
    
    self.modeClass = [WCERecordMode class];
    self.parameter[@"rows"] = @"20";
    self.parameter[@"interfaceId"] = @"299";
    self.parameter[@"sdate"] = endTime;
    self.parameter[@"edate"] = newTime;
    self.parameter[@"id"] = [UserInfo account].userID;
}
#pragma mark ---初始化视图----
- (void)setUpView
{
    [super setUpView];
    self.tableView.estimatedRowHeight = 75;
    [self.tableView registerNib:[UINib nibWithNibName:@"WCERecordTableViewCell" bundle:nil] forCellReuseIdentifier:WCERecordTableViewCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.timeView = [[WCRecordTimeSelectView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 44)];
    self.tableView.tableHeaderView = self.timeView;
    TBWeakSelf
    
    [self.timeView setTimeSelectEnd:^(NSString *state, NSString *end) {
        
        weakSelf.parameter[@"sdate"] = state;
        weakSelf.parameter[@"edate"] = end;
        [weakSelf.tableView.mj_header beginRefreshing];
        
    }];

    [self.timeView updateAmount:@"收入：￥00.00" time:[NSString stringWithFormat:@"%@至%@",self.parameter[@"sdate"],self.parameter[@"edate"]]];
}

/**
 原生数据
 
 @param dictionary 数据
 */
- (void)originalData:(NSDictionary *)dictionary;
{
    NSString *numbaer = [[dictionary valueForKey:@"data"] valueForKey:@"number"];
    NSString *srString = [NSString stringWithFormat:@"收入：￥%@",numbaer? :@"0.00"];
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
    WCERecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WCERecordTableViewCellID];
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
    return 75;
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
