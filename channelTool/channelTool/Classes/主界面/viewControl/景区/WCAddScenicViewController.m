//
//  WCAddScenicViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/17.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCAddScenicViewController.h"
#import "WCAddAttractionsViewController.h"
#import "WCMoreAttractionsViewController.h"
#import "WCAddScenicCollectionViewCell.h"
#import "WCAddScenicHeaderView.h"
#import "WCAddScenicFootorView.h"
#import "WCAddScenicMode.h"

@interface WCAddScenicViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray <WCAddScenicMode *>*dataArray;

@end

@implementation WCAddScenicViewController
//视图将要出现
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"创建游览路线";
    [self setUpView];
}
#pragma mark ---初始化视图----
- (void)setUpView
{
    CGFloat cellWidth = (_SCREEN_WIDTH-21-10*3)/4;
    CGFloat cellHeight = cellWidth+30;
    
    CGFloat bottomHeight = 20;
    // 设配iPhone X底部
    if (_SCREEN_HEIGHT == 812) {
        bottomHeight = 34;
    }
    
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
    

    [self.collectionView registerNib:[UINib nibWithNibName:@"WCAddScenicFootorView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:WCAddScenicFootorViewID];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"WCAddScenicHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WCAddScenicHeaderViewID];

    [self.view addSubview:self.collectionView];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"保 存" forState:(UIControlStateNormal)];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    saveButton.backgroundColor = NAVIGATION_COLOR;
    saveButton.layer.cornerRadius = 6;
    [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    TBWeakSelf
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-bottomHeight);
        make.height.equalTo(@44);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
}
#pragma mark  ----上传信息----
- (void)saveClick
{
    
}
#pragma mark  ----UICollectionViewDataSource && UICollectionViewDelegate----
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count+1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    WCAddScenicMode *mode = self.dataArray[section];
    return mode.scenicArray.count+1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WCAddScenicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WCAddScenicCollectionViewCellID forIndexPath:indexPath];
    
    WCAddScenicImageMode *imageMode;
    
    if (self.dataArray.count>indexPath.section)
    {
        WCAddScenicMode *mode = self.dataArray[indexPath.section];
        
        if (mode.scenicArray.count > indexPath.row) {
            imageMode = mode.scenicArray[indexPath.row];
        }
    }
    [cell updataCellUI:imageMode];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(_SCREEN_WIDTH-20, 80);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
       return CGSizeMake(_SCREEN_WIDTH-20, 30);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        WCAddScenicMode *mode = self.dataArray[indexPath.section];
        WCAddScenicHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WCAddScenicHeaderViewID forIndexPath:indexPath];
        [headerView updateHaaderViewData:mode indexSection:indexPath.section];
        
        reusableview = headerView;
    }
    else if (kind == UICollectionElementKindSectionFooter)
    {
        WCAddScenicFootorView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:WCAddScenicFootorViewID forIndexPath:indexPath];
        footer.moreButton.tag = indexPath.section;
        [footer.moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        reusableview = footer;
    }
    return reusableview;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    // 加载storboard
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"main" bundle:nil];
    
    WCAddAttractionsViewController *viewController = [board instantiateViewControllerWithIdentifier:@"WCAddAttractionsViewControllerID"];
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark  ----加载更多----
- (void)moreButtonClick:(UIButton *)sender
{
    WCMoreAttractionsViewController *vc = [[WCMoreAttractionsViewController alloc] init];
//    vc.scenicMode = self.dataArray[sender.tag];
    [self.navigationController pushViewController:vc animated:YES];
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
