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
#import "WCUploadPromptView.h"
#import "WCAddScenicMode.h"

@interface WCAddScenicViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray <WCAddScenicMode *>*dataArray;

@property (nonatomic, assign) NSInteger maxRow;// cell最大数量

@end

@implementation WCAddScenicViewController
//视图将要出现
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
//视图将要消失
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"创建游览路线";
    [self setUpView];
    [self postScenicListData];
    
}
#pragma mark ---初始化视图----
- (void)setUpView
{
    CGFloat cellWidth = (_SCREEN_WIDTH-20-10*3)/4;
    CGFloat cellHeight = cellWidth+30;
    
    CGFloat bottomHeight = 20;
    // 设配iPhone X底部
    if (_SCREEN_HEIGHT == 812) {
        bottomHeight = 34;
    }
    
    self.maxRow = 8;
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    [flowlayout setItemSize:CGSizeMake(cellWidth, cellHeight)];
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowlayout.minimumInteritemSpacing = 10;
    flowlayout.minimumLineSpacing = 10;
    flowlayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowlayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource      = self;
    self.collectionView.delegate        = self;
    self.collectionView.bounces         = YES;
    
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
        make.bottom.equalTo(saveButton.mas_top).offset(-4);
    }];
    
    
    
    
}
#pragma mark  ----基本信息请求----
- (void)postScenicListData
{
    NSDictionary *dic = @{@"interfaceId":@"307",
                          @"id":[UserInfo account].userID,
                          @"shopid":self.scenicID};
    hudShowLoading(@"请稍等...");
    TBWeakSelf
    [[ZKPostHttp shareInstance] POST:POST_URL params:dic success:^(id  _Nonnull responseObject) {
        
        if ([[responseObject valueForKey:@"errcode"] isEqualToString:@"00000"]) {
            
            NSDictionary *data = [responseObject valueForKey:@"data"];
            weakSelf.dataArray = [WCAddScenicMode mj_objectArrayWithKeyValuesArray:[data valueForKey:@"root"]];
            [weakSelf.dataArray addObject:[[WCAddScenicMode alloc] init]];
            [weakSelf.collectionView reloadData];
            hudDismiss();
        }
        else
        {
            hudShowError([responseObject valueForKey:@"errmsg"]);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        hudShowError(@"网络异常，请查看网络连接");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma mark  ----上传信息----
- (void)saveClick
{
    hudShowLoading(@"请稍等...");
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
    
    NSInteger tag = 0;
    
    for (int i = 0; i<self.dataArray.count; i++) {
        
        WCAddScenicMode *mode = self.dataArray[i];
        
        if ((mode.name.length == 0 || mode.info.length == 0)) {
            
            if ((self.dataArray.count-1)!=i) {
                tag = i;
                break;
            }
        }
        else
        {
            NSDictionary *dic = @{@"sort":[NSNumber numberWithInt:i+1],
                                  @"name":mode.name,
                                  @"info":mode.info};
            [data addObject:dic];
        }
    }
    
    if (tag>0) {
        hudDismiss();
        [data removeAllObjects];
        data = nil;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathWithIndex:tag] atScrollPosition:(UICollectionViewScrollPositionNone) animated:YES];
        [UIView addMJNotifierWithText:@"信息填写不完整" dismissAutomatically:YES];
        return;
    }
    
    NSDictionary *dic = @{@"interfaceId":@"309",
                          @"id":[UserInfo account].userID,
                          @"shopid":self.scenicID,
                          @"spotlist":data.mj_JSONString};
    TBWeakSelf
    [[ZKPostHttp shareInstance] POST:POST_URL params:dic success:^(id  _Nonnull responseObject) {
        
        hudDismiss();
        if ([[responseObject valueForKey:@"errcode"] isEqualToString:@"00000"]) {
            
            [WCUploadPromptView showPromptString:@"保存成功" isSuccessful:NO clickButton:^{
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
      
            if (weakSelf.refreshTableView ) {
                weakSelf.refreshTableView();
            }
        }
        else
        {
            [WCUploadPromptView showPromptString:[responseObject valueForKey:@"errmsg"] isSuccessful:NO clickButton:^{
            }];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        hudShowError(@"网络异常，请查看网络连接");
        
    }];
    
}
#pragma mark  ----UICollectionViewDataSource && UICollectionViewDelegate----
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataArray.count > section) {
        
        WCAddScenicMode *mode = self.dataArray[section];
        if (mode.shopspot.count >= self.maxRow) {
            
            return self.maxRow;
        }
        return mode.shopspot.count+1;
    }
    return 1;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WCAddScenicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WCAddScenicCollectionViewCellID forIndexPath:indexPath];
    
    WCAddScenicImageMode *imageMode;
    
    if (self.dataArray.count>indexPath.section)
    {
        WCAddScenicMode *mode = self.dataArray[indexPath.section];
        
        if (mode.shopspot.count > indexPath.row) {
            imageMode = mode.shopspot[indexPath.row];
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
    if (self.dataArray.count > section) {
        
        WCAddScenicMode *mode = self.dataArray[section];
        if (mode.shopspot.count >= self.maxRow) {
            
            return CGSizeMake(_SCREEN_WIDTH-20, 30);
        }
    }
    return CGSizeMake(_SCREEN_WIDTH-20, 0.01);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        WCAddScenicHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WCAddScenicHeaderViewID forIndexPath:indexPath];
        
        if (self.dataArray.count > indexPath.section) {
            WCAddScenicMode *mode = self.dataArray[indexPath.section];
            
            [headerView updateHaaderViewData:mode indexSection:indexPath.section];
            [headerView setEditEnd:^(NSString *scenicName, NSString *siteName, NSInteger section) {
                
                mode.info = scenicName;
                mode.name = siteName;
            }];
        }
        else
        {
            [headerView updateHaaderViewData:nil indexSection:indexPath.section];
        }
        
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
    //    [self.view endEditing:YES];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    // 加载storboard
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"main" bundle:nil];
    
    WCAddAttractionsViewController *viewController = [board instantiateViewControllerWithIdentifier:@"WCAddAttractionsViewControllerID"];
    WCAddScenicImageMode *mode;
    if (self.dataArray.count > indexPath.section) {
        
        WCAddScenicMode *data = self.dataArray[indexPath.section];
        
        if (data.name.length == 0 || data.info.length == 0) {
            
            [UIView addMJNotifierWithText:@"请先完善站点信息" dismissAutomatically:YES];
            return;
        }
        if (data.shopspot.count > indexPath.row) {
            mode = data.shopspot[indexPath.row];
        }
        else
        {
            mode = [[WCAddScenicImageMode alloc] init];
        }
        mode.scenicID = self.scenicID? :@"";
        mode.pname = data.name? :@"";
        mode.scenicInfo = data.info? :@"";
        
        mode.rows = indexPath.row+1;
        mode.psort = [NSString stringWithFormat:@"%ld",indexPath.section+1];
        viewController.scenicMode = mode;
        [self.navigationController pushViewController:viewController animated:YES];
        
    }
    TBWeakSelf
    [viewController setRefreshTableView:^(WCAddScenicImageMode *mode) {
        
        WCAddScenicMode *data = [weakSelf.dataArray objectAtIndex:indexPath.section];
        
        if (data.shopspot.count > indexPath.row) {
            
            [data.shopspot replaceObjectAtIndex:indexPath.row withObject:mode];
        }
        else
        {
            [data.shopspot addObject:mode];
            data.total = data.total+1;
            //  刷新景区列表
            if (weakSelf.refreshTableView ) {
                weakSelf.refreshTableView();
            }
        }
        
        if (indexPath.section == weakSelf.dataArray.count-1) {
            
            [weakSelf.dataArray addObject:[[WCAddScenicMode alloc] init]];
            [weakSelf.collectionView reloadData];
        }
        else
        {
            [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
        }
    }];
}
#pragma mark  ----加载更多----
- (void)moreButtonClick:(UIButton *)sender
{
    WCAddScenicMode *mode = self.dataArray[sender.tag];
    if (mode.name.length == 0 || mode.info.length == 0) {
        
        [UIView addMJNotifierWithText:@"请先完善信息" dismissAutomatically:YES];
        return;
    }
    WCMoreAttractionsViewController *vc = [[WCMoreAttractionsViewController alloc] init];
    
    vc.sort = [NSString stringWithFormat:@"%ld",sender.tag+1];
    vc.shopid = self.scenicID;
    vc.name = mode.name;
    vc.info = mode.info;
    [self.navigationController pushViewController:vc animated:YES];
    
    TBWeakSelf
    [vc setRefreshTableView:^(NSArray *modeArray) {
        // 更新区
        [mode.shopspot removeAllObjects];
        [mode.shopspot addObjectsFromArray:modeArray];
        mode.total = modeArray.count;
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag]];
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
