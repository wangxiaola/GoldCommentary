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
@interface WCMoreAttractionsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *numberScenicLabel;

@property (nonatomic, strong) NSMutableArray <WCAddScenicImageMode *>*dataArray;

@end

@implementation WCMoreAttractionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"更多景点";
    
    [self setUpView];
}
#pragma mark ---初始化视图----
- (void)setUpView
{
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UILabel *siteLabel = [[UILabel alloc] init];
    siteLabel.text = @"第一站：xxxxx";
    siteLabel.font = [UIFont systemFontOfSize:14];
    siteLabel.textColor = [UIColor blackColor];
    [topView addSubview:siteLabel];
    
    self.numberScenicLabel = [[UILabel alloc] init];
    self.numberScenicLabel.text = [NSString stringWithFormat:@"(共有%ld个景点)",self.scenicMode.scenicArray.count];
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
    flowlayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowlayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.bounces = YES;
    self.collectionView.scrollEnabled = NO;
    
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
    
    if (self.dataArray.count>indexPath.section)
    {
        imageMode = self.dataArray[indexPath.section];
    }
    [cell updataCellUI:imageMode];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 加载storboard
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"main" bundle:nil];
    
    WCAddAttractionsViewController *viewController = [board instantiateViewControllerWithIdentifier:@"WCAddAttractionsViewControllerID"];
    [self.navigationController pushViewController:viewController animated:YES];
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
