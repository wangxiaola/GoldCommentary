//
//  WCMoreAttractionsViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/17.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCMoreAttractionsViewController.h"
#import "WCAddScenicCollectionViewCell.h"
#import "WCAddAttractionsViewController.h"
#import "WCAddScenicMode.h"
#import "TBBaseClassViewMode.h"
@interface WCMoreAttractionsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,TBBaseClassViewModeDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *numberScenicLabel;

@property (nonatomic, strong) NSMutableArray <WCAddScenicImageMode *>*dataArray;

@property (nonatomic, strong) TBBaseClassViewMode *viewMode;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger total;
@end

@implementation WCMoreAttractionsViewController
- (TBBaseClassViewMode *)viewMode
{
    if (!_viewMode)
    {
        _viewMode = [[TBBaseClassViewMode alloc] init];
        _viewMode.delegate = self;
    }
    return _viewMode;
}
- (NSMutableArray<WCAddScenicImageMode *> *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
//视图将要消失
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.dataArray.count >2 && self.refreshTableView) {
        
        self.refreshTableView(self.dataArray);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"更多景点";
    
    [self setUpView];
}
#pragma mark ---初始化视图----
- (void) setUpView
{
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UILabel *siteLabel = [[UILabel alloc] init];
    siteLabel.font = [UIFont systemFontOfSize:14];
    siteLabel.textColor = [UIColor blackColor];
    [topView addSubview:siteLabel];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    NSString *number = [formatter stringFromNumber:[NSNumber numberWithInteger:self.sort.integerValue+1]];// 第一
    
    siteLabel.text = [NSString stringWithFormat:@"第%@站：%@",number,self.name];
    
    
    self.numberScenicLabel = [[UILabel alloc] init];
    self.numberScenicLabel.font = [UIFont systemFontOfSize:12];
    self.numberScenicLabel.textColor = [UIColor blackColor];
    [topView addSubview:self.numberScenicLabel];
    
    UIView *linView = [[UIView alloc] init];
    linView.backgroundColor = BODER_COLOR;
    [topView addSubview:linView];
    
    CGFloat cellWidth = (_SCREEN_WIDTH-21-10*3)/4;
    CGFloat cellHeight = cellWidth+30;
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    [flowlayout setItemSize:CGSizeMake(cellWidth, cellHeight)];
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowlayout.minimumInteritemSpacing = 10;
    flowlayout.minimumLineSpacing = 10;
    flowlayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowlayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.bounces = YES;
    
    // 表格注册
    [self.collectionView registerNib:[UINib nibWithNibName:@"WCAddScenicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:WCAddScenicCollectionViewCellID];
    [self.view addSubview:self.collectionView];
    
    MJWeakSelf
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
        make.height.equalTo(@50);
    }];
    
    [siteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(topView);
        make.height.equalTo(@40);
    }];
    [self.numberScenicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(topView);
        make.centerY.equalTo(siteLabel.mas_centerY);
    }];
    [linView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(topView);
        make.height.equalTo(@0.6);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
        make.top.equalTo(topView.mas_bottom);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    self.collectionView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    self.collectionView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoadingData)];
    [self.collectionView.mj_header beginRefreshing];
}
#pragma mark  ----数据请求----

/**
 *  重新加载数据
 */
- (void)reloadData
{
    self.page = 1;
    [self requestData];
}
/**
 *  上拉加载数据
 */
- (void)pullLoadingData
{
    self.page++;
    [self requestData];
}
- (void)requestData
{
    NSDictionary *dic = @{@"interfaceId":@"310",
                          @"id":[UserInfo account].userID,
                          @"shopid":self.shopid,
                          @"sort":self.sort,
                          @"page":[NSNumber numberWithInteger:self.page]
                          };
    
    [self.viewMode postDataParameter:dic.mutableCopy];
}
#pragma mark ---TBBaseClassViewModeDelegate--
/**
 原生数据
 
 @param dictionary 数据
 */
- (void)originalData:(NSDictionary *)dictionary;
{
    NSDictionary *data = [dictionary valueForKey:@"data"];
    self.total = [[data valueForKey:@"total"] integerValue];
    self.numberScenicLabel.text = [NSString stringWithFormat:@"(共有%ld个景点)",self.total];
}
/**
 请求结束
 
 @param array 数据源
 */
- (void)postDataEnd:(NSArray *)array;
{
    NSArray *data = [WCAddScenicImageMode mj_objectArrayWithKeyValuesArray:array];
    
    [self.collectionView.mj_header endRefreshing];
    if (self.page == 1)
    {
        [self.collectionView.mj_footer resetNoMoreData];
        self.collectionView.mj_footer.hidden = NO;
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:data];
    }
    else
    {
        [self.collectionView.mj_footer endRefreshing];
        [self.dataArray addObjectsFromArray:data];
    }
    [self  updataTableView];
}
/**
 请求出错了
 
 @param error 错误信息
 */
- (void)postError:(NSString *)error;
{
    hudDismiss();
    [UIView addMJNotifierWithText:error dismissAutomatically:YES];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}
/**
 没有更多数据了
 */
- (void)noMoreData;
{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
}
/**
 主线程刷新
 */
- (void)updataTableView
{
    hudDismiss();
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}
#pragma mark  ----UICollectionViewDataSource && UICollectionViewDelegate----
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count+1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WCAddScenicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WCAddScenicCollectionViewCellID forIndexPath:indexPath];
    
    WCAddScenicImageMode *imageMode;
    
    if (self.dataArray.count>indexPath.row)
    {
        imageMode = self.dataArray[indexPath.row];
    }
    [cell updataCellUI:imageMode];
    
    return cell;
}
// 添加景点或编辑景点
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 加载storboard
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"main" bundle:nil];
    
    WCAddAttractionsViewController *viewController = [board instantiateViewControllerWithIdentifier:@"WCAddAttractionsViewControllerID"];
    WCAddScenicImageMode *mode;
    if (self.dataArray.count > indexPath.row) {
        
        mode = self.dataArray[indexPath.row];
        
    }
    else
    {
        mode = [[WCAddScenicImageMode alloc] init];
    }
    mode.scenicID = self.shopid? :@"";
    mode.pname = self.name? :@"";
    mode.scenicInfo = self.info? :@"";
    
    mode.rows = indexPath.row+1;
    mode.psort = [NSString stringWithFormat:@"%ld",indexPath.section+1];
    viewController.scenicMode = mode;
    [self.navigationController pushViewController:viewController animated:YES];
    
    TBWeakSelf
    [viewController setRefreshTableView:^(WCAddScenicImageMode *mode) {
        
        if (weakSelf.dataArray.count > indexPath.row) {
            
            [weakSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:mode];
        }
        else
        {
            [weakSelf.dataArray addObject:mode];
            weakSelf.numberScenicLabel.text = [NSString stringWithFormat:@"(共有%ld个景点)",self.total+1];
        }
        
        [weakSelf.collectionView reloadData];
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
