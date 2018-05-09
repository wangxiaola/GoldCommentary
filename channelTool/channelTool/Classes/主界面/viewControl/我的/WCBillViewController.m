//
//  WCBillViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/9.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCBillViewController.h"
#import "WCERecordTableViewCell.h"
#import "WCWRecordTableViewCell.h"

#import "MJUpdateUI.h"

@interface WCBillViewController ()<UITableViewDelegate,UITableViewDataSource>
// 总收益
@property (weak, nonatomic) IBOutlet UILabel *earningsLabel;
//出账
@property (weak, nonatomic) IBOutlet UILabel *chuZhangLabel;
//未出账
@property (weak, nonatomic) IBOutlet UILabel *notCZLabel;
//提现数量
@property (weak, nonatomic) IBOutlet UILabel *WithdrawalNumberLabel;
//交易列表
@property (weak, nonatomic) IBOutlet UITableView *eRecordTableView;
//提现记录
@property (weak, nonatomic) IBOutlet UITableView *wRecordTableView;
//交易数据
@property (nonatomic, strong) NSMutableArray *eRecordArray;
//提现记录数据
@property (nonatomic, strong) NSMutableArray *wRecordArray;

@property (nonatomic, assign) NSInteger pageE;

@property (nonatomic, assign) NSInteger pageW;
@end

@implementation WCBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUIViews];
}
#pragma mark  ----设置视图属性----
- (void)setUIViews
{
    self.pageE = 1;
    self.pageW = 1;
    
    self.eRecordTableView.tableFooterView = [[UIView alloc] init];
    self.eRecordTableView.backgroundColor = BACKLIST_COLOR;
    self.eRecordTableView.delegate = self;
    self.eRecordTableView.dataSource = self;
    self.eRecordTableView.estimatedRowHeight = 60;
    
    self.wRecordTableView.tableFooterView = [[UIView alloc] init];
    self.wRecordTableView.backgroundColor = BACKLIST_COLOR;
    self.wRecordTableView.delegate = self;
    self.wRecordTableView.dataSource = self;
    self.wRecordTableView.estimatedRowHeight = 44;
    
    [self.eRecordTableView registerNib:[UINib nibWithNibName:@"WCERecordTableViewCell" bundle:nil] forCellReuseIdentifier:WCERecordTableViewCellID];
    
    [self.wRecordTableView registerNib:[UINib nibWithNibName:@"WCWRecordTableViewCell" bundle:nil] forCellReuseIdentifier:WCWRecordTableViewCellID];
    
    self.eRecordTableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadEData)];
    self.eRecordTableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoadingEData)];
    [self.eRecordTableView.mj_header beginRefreshing];
    
    self.wRecordTableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadWData)];
    self.wRecordTableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoadingWData)];
    [self.wRecordTableView.mj_header beginRefreshing];
    
    [self.eRecordTableView reloadData];
    [self.wRecordTableView reloadData];
}
#pragma mark  ----数据请求----
- (void)requestDataBase
{
    [[ZKPostHttp shareInstance] POST:@"" params:@{} success:^(id  _Nonnull responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
/**
 *  重新加载数据
 */
- (void)reloadEData
{
    self.pageE = 1;
    [self requestListDataType:0];
}
/**
 *  上拉加载数据
 */
- (void)pullLoadingEData
{
    self.pageE++;
    [self requestListDataType:0];
}/**
  *  重新加载数据
  */
- (void)reloadWData
{
    self.pageW = 1;
    [self requestListDataType:1];
}
/**
 *  上拉加载数据
 */
- (void)pullLoadingWData
{
    self.pageW++;
    [self requestListDataType:1];
}
/**
 请求列表数据
 
 @param type 列表类型 0==eRecordTableView 1==wRecordTableView
 */
- (void)requestListDataType:(NSInteger)type
{
    [self.eRecordTableView.mj_header endRefreshing];
    [self.wRecordTableView.mj_header endRefreshing];
    
    [self.eRecordTableView.mj_footer endRefreshing];
    [self.wRecordTableView.mj_footer endRefreshing];
    
    if (type == 0) {
        
    }
    else
    {
        
    }
    [[ZKPostHttp shareInstance] POST:@"" params:@{} success:^(id  _Nonnull responseObject) {
        
        if (type == 0) {
            
        }
        else
        {
            
        }
    } failure:^(NSError * _Nonnull error) {
        
        if (type == 0) {
            
        }
        else
        {
            
        }
    }];
}
#pragma mark  ----点击事件----
- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark  ----UITableViewDelegate && UITableViewDataSource ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.eRecordTableView]) {
        
        return 11;
    }
    else
    {
        return 4;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.eRecordTableView]) {
        
        WCERecordTableViewCell *cell = [self.eRecordTableView dequeueReusableCellWithIdentifier:WCERecordTableViewCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 赋值
        if (self.eRecordArray.count > indexPath.row) {
            
            [cell updataCellMode:self.eRecordArray[indexPath.row]];
        }
        return cell;
    }
    else if ([tableView isEqual:self.wRecordTableView])
    {
        WCWRecordTableViewCell *cell = [self.wRecordTableView dequeueReusableCellWithIdentifier:WCWRecordTableViewCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 赋值
        if (self.wRecordArray.count > indexPath.row) {
            
            [cell updataCellMode:self.wRecordArray[indexPath.row]];
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
            
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.eRecordTableView]) {
        
        return 76;
    }
    else if ([tableView isEqual:self.wRecordTableView])
    {
        return 50;
    }
    return _SCREEN_HEIGHT/2;
}
#pragma mark  ----懒加载----
- (NSMutableArray *)eRecordArray
{
    if (!_eRecordArray) {
        _eRecordArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _eRecordArray;
}
- (NSMutableArray *)wRecordArray
{
    if (!_wRecordArray) {
        _wRecordArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _wRecordArray;
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
