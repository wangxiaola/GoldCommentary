//
//  WCCreateScenicViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/15.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCCreateScenicViewController.h"
#import "LoginNavigationController.h"
#import "TBChoosePhotosTool.h"
#import "TBMoreReminderView.h"
#import "TBTemplateResourceCollectionViewCell.h"
#import "UIButton+ImageTitleStyle.h"
#import "WCCreateScenicMode.h"
#import "WCGeoCodeSearch.h"
#import "WCPositioningMode.h"
#import "WCPositioningViewController.h"
#import "XMRTimePiker.h"
#import "WCUploadPromptView.h"
#import "YBPopupMenu.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <IQKeyboardManager/IQTextView.h>

@interface WCCreateScenicViewController ()<UITextViewDelegate,YBPopupMenuDelegate,UICollectionViewDataSource,UICollectionViewDelegate,TBChoosePhotosToolDelegate,XMRTimePikerDelegate,BMKLocationServiceDelegate>

@property (weak, nonatomic) IBOutlet UITextField *scenicNameField;
@property (weak, nonatomic) IBOutlet UITextField *adderssField;
@property (weak, nonatomic) IBOutlet UITextField *ticketsField;//门票
@property (weak, nonatomic) IBOutlet IQTextView *infoTextView;//简介
@property (weak, nonatomic) IBOutlet UITextField *visitingTimeField;//游览时长
@property (weak, nonatomic) IBOutlet UITextField *headNameField;//负责人姓名
@property (weak, nonatomic) IBOutlet UITextField *headPhoneField;//负责人电话
@property (weak, nonatomic) IBOutlet UILabel *lineTimeLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *levelButton;


@property (weak, nonatomic) IBOutlet UIButton *submButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewHeight;

@property (nonatomic, strong) TBChoosePhotosTool * tool;
@property (assign, nonatomic) CGFloat  cellWidth;
@property (strong, nonatomic) NSMutableArray *imageArray;
// 最大选择数
@property (assign, nonatomic) NSInteger maxRow;

@property (nonatomic, copy) NSString *levelString;//等级

@property (nonatomic, copy) NSString *linestime;

@property (nonatomic, copy) NSString *lineetime;

@property (nonatomic, strong) BMKLocationService *locService;

@property (nonatomic, strong) WCGeoCodeSearch *godeSearch;

@property (nonatomic, strong) WCPositioningMode *locationMode;

@property (nonatomic, strong) WCCreateScenicMode *scenicMode;
@end

@implementation WCCreateScenicViewController
//视图将要出现
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"创建景区";
    self.view.backgroundColor = RGB(241, 241, 241);
    [self setUpView];
    
    self.linestime = @"00:00";
    self.lineetime = @"24:00";
    
    if (self.ID.length > 0) {
        
        [self postEditorSecnicInfo];
    }
    else
    {
        [self setLocService];
    }
}
#pragma mark ---初始化视图----
- (void)setUpView
{
    self.godeSearch = [[WCGeoCodeSearch alloc] init];
    self.locationMode = [[WCPositioningMode alloc] init];
    
    self.infoTextView.scrollEnabled = NO;
    self.infoTextView.delegate = self;
    
    self.levelButton.layer.cornerRadius = 4;
    self.levelButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.levelButton.layer.borderWidth = 0.6;
    [self.levelButton setButtonImageTitleStyle:(ButtonImageTitleStyleRightLeft) padding:4];
    
    self.headPhoneField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;

    
    self.tool = [[TBChoosePhotosTool alloc] init];
    self.tool.delegate = self;
    self.cellWidth = (_SCREEN_WIDTH- 10*8)/3;
    
    self.maxRow = 9;
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    [flowlayout setItemSize:CGSizeMake(self.cellWidth, self.cellWidth)];
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowlayout.minimumInteritemSpacing = 9;
    flowlayout.minimumLineSpacing = 9;
    flowlayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.photoCollectionView.dataSource = self;
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.bounces = NO;
    self.photoCollectionView.scrollEnabled = NO;
    [self.photoCollectionView registerClass:[TBTemplateResourceCollectionViewCell class] forCellWithReuseIdentifier:TBTemplateResourceCollectionViewCellID];
    self.photoCollectionView.collectionViewLayout = flowlayout;
    
    [self.submButton setTitle:self.ID?@"更 新 上 传":@"上 传 创 建" forState:(UIControlStateNormal)];
}
- (void)setLocService
{
    //初始化BMKLocationService
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
}
/**
 添加震动动画
 
 @param view 要动画的视图
 @param mark 提示
 */
- (void)shakeAnimationForView:(UIView *)view markString:(NSString *)mark
{
    if (view) {
        [ZKUtil shakeAnimationForView:view];
    }
    if (mark) {
        [UIView addMJNotifierWithText:mark dismissAutomatically:YES];
    }
}

/**
 更新位置信息
 
 @param mode 数据
 */
- (void)updateAddressLabelData:(WCPositioningMode *)mode
{
    self.locationMode = mode;
    self.adderssField.text = mode.adderss;
}

/**
 更新赋值
 */
- (void)reloadUIText
{
    self.scenicNameField.text = self.scenicMode.name;
    [self.imageArray addObjectsFromArray:[self.scenicMode.allimg componentsSeparatedByString:@","]];
    [self updataCollectionView];
    
    [self.levelButton setTitle:self.scenicMode.label forState:UIControlStateNormal];
    [self.levelButton setButtonImageTitleStyle:(ButtonImageTitleStyleRightLeft) padding:4];
    self.adderssField.text = self.scenicMode.address;
    self.locationMode.adderss = self.scenicMode.address;
    self.locationMode.cityID = self.scenicMode.qcode;
    self.locationMode.latitude = self.scenicMode.lat;
    self.locationMode.longitude = self.scenicMode.lng;
    self.ticketsField.text = self.scenicMode.special;
    self.infoTextView.text = self.scenicMode.info;
    [self textViewDidChange:self.infoTextView];
    self.visitingTimeField.text = self.scenicMode.routetime;
    self.headNameField.text = self.scenicMode.boss;
    self.headPhoneField.text = self.scenicMode.phone;
    
    self.linestime = self.scenicMode.linestime;
    self.lineetime = self.scenicMode.lineetime;
    
    self.lineTimeLabel.text = [NSString stringWithFormat:@"%@-%@",self.linestime,self.lineetime];
}
#pragma mark  ----数据上传----
- (void)postScenicData
{
    hudShopWUploadProgress(0.1, @"正在上传图片");
    
    dispatch_group_t group = dispatch_group_create();
    TBWeakSelf
    for (int i = 0; i<self.imageArray.count; i++) {
        dispatch_group_enter(group);
        id data = self.imageArray[i];
        if ([data isKindOfClass:[UIImage class]]) {
            
            [ZKPostHttp uploadImage:POST_IMAGE_URL Data:UIImageJPEGRepresentation(data, 0.6) success:^(id  _Nonnull responseObj) {
                
                if ([[responseObj valueForKey:@"errcode"] isEqualToString:@"00000"]) {
                    
                    NSDictionary *data = [responseObj valueForKey:@"data"];
                    NSString *url = [data valueForKey:@"url"];
                    hudShopWUploadProgress(0.2*i, @"正在上传图片");
                    [weakSelf.imageArray replaceObjectAtIndex:i withObject:url];
                }
                dispatch_group_leave(group);
                
            } failure:^(NSError * _Nonnull error) {
                
                dispatch_group_leave(group);
            }];
        }
        else
        {
            dispatch_group_leave(group);
            hudShopWUploadProgress(0.2*i, @"正在上传图片");
        }
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if ([weakSelf.imageArray containsObject:[UIImage class]]) {
            
            hudShowError(@"景区图片上传遗漏");
        }
        else
        {
            [weakSelf submitInformation];
        }
    });
    
}
// 景区信息提交
- (void)submitInformation
{
    NSDictionary *jsonData = @{@"name":self.scenicNameField.text,
                               @"allimg":[self.imageArray componentsJoinedByString:@","],
                               @"label":self.levelButton.titleLabel.text,
                               @"address":self.adderssField.text,
                               @"lat":self.locationMode.latitude,
                               @"lng":self.locationMode.longitude,
                               @"qcode":self.locationMode.cityID,
                               @"linestime":self.linestime,
                               @"lineetime":self.lineetime,
                               @"special":self.ticketsField.text,
                               @"info":self.infoTextView.text,
                               @"routetime":self.visitingTimeField.text,
                               @"boss":self.headNameField.text,
                               @"consulttel":self.headPhoneField.text,
                               @"phone":self.headPhoneField.text};
    
    NSString *shopid = self.ID?self.ID:@"";
    NSDictionary *dic = @{@"interfaceId":@"302",
                          @"id":[UserInfo account].userID,
                          @"shopid":shopid,
                          @"model":jsonData.mj_JSONString};
    
    
    hudShopWUploadProgress(0.8, @"正在上传图片");
    TBWeakSelf
    [[ZKPostHttp shareInstance] POST:POST_URL params:dic success:^(id  _Nonnull responseObject) {
        
        if ([[responseObject valueForKey:@"errcode"] isEqualToString:@"00000"]) {
            
            [WCUploadPromptView showPromptString:self.ID?@"景区更新成功":@"景区创建成功" isSuccessful:NO clickButton:^{
                
                if (weakSelf.refreshTableView) {
                    weakSelf.refreshTableView();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
        else
        {
            [WCUploadPromptView showPromptString:[responseObject valueForKey:@"errmsg"] isSuccessful:NO clickButton:^{
            }];
        }
        hudDismiss();
        
    } failure:^(NSError * _Nonnull error) {
        
        hudShowError(@"网络异常，请查看网络连接");
        
    }];
}
#pragma mark  ----数据信息请求----
- (void)postEditorSecnicInfo
{
    hudShowLoading(@"正在请求数据");
    
    NSDictionary *dic = @{@"shopid":self.ID,
                          @"id":[UserInfo account].userID,
                          @"interfaceId":@"301"};
    TBWeakSelf
    [[ZKPostHttp shareInstance] POST:POST_URL params:dic success:^(id  _Nonnull responseObject) {
        
        if ([[responseObject valueForKey:@"errcode"] isEqualToString:@"00000"]) {
            
            NSDictionary *data = [[responseObject valueForKey:@"data"] mj_JSONObject];
            
            weakSelf.scenicMode = [WCCreateScenicMode mj_objectWithKeyValues:[data valueForKey:@"shop"]];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [weakSelf reloadUIText];
            }];
            hudDismiss();
        }
        else
        {
            hudShowError([responseObject valueForKey:@"errmsg"]);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError * _Nonnull error) {
        hudShowError(@"网络异常,请查看网络连接");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma mark  ----点击事件----
- (IBAction)selectPhotos:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (self.imageArray.count == self.maxRow) {
        
        [UIView addMJNotifierWithText:@"请先删除一些照片" dismissAutomatically:YES];
        return;
    }
    [self.tool showPhotosIndex:self.maxRow-self.imageArray.count];
}
- (IBAction)selectLevel:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    YBPopupMenu *popupMenu = [YBPopupMenu showRelyOnView:sender titles:@[@"5A",@"4A",@"3A",@"其它星级"] icons:nil menuWidth:100 delegate:self];
    popupMenu.offset = 5;
    popupMenu.fontSize = 13;
    popupMenu.type = YBPopupMenuTypeDefault;
    
}
- (IBAction)goMapView:(UIButton *)sender {
    [self.view endEditing:YES];
    
    WCPositioningViewController *mapView = [[WCPositioningViewController alloc] init];
    LoginNavigationController *nav = [[LoginNavigationController alloc] initWithRootViewController:mapView];
    
    [self presentViewController:nav animated:NO completion:nil];
    MJWeakSelf
    [mapView setSearchResults:^(WCPositioningMode *mode) {
        
        [weakSelf updateAddressLabelData:mode];
    }];
}
- (IBAction)selectTime:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSArray * star_arr = [self.linestime componentsSeparatedByString:@":"];
    NSArray * end_arr = [self.lineetime componentsSeparatedByString:@":"];
    
    XMRTimePiker *timeView = [[XMRTimePiker alloc] init];
    timeView.delegate = self;
    [timeView SetOldShowTimeOneLeft:star_arr[0] andOneRight:star_arr[1] andTowLeft:end_arr[0] andTowRight:end_arr[1]];
    [timeView showTime];
}
// 上传创建
- (IBAction)updataData:(UIButton *)sender {
    
    if (self.scenicNameField.text.length == 0) {
        [self shakeAnimationForView:self.scenicNameField.superview markString:@"请填写景区名称"];
        return;
    }
    if (self.imageArray.count == 0) {
        
        [self shakeAnimationForView:self.scenicNameField.superview markString:@"请至少上传一张图片"];
        return;
    }
    if (self.adderssField.text.length == 0 ||self.locationMode.latitude.length == 0 || self.locationMode.longitude.length == 0) {
        [self shakeAnimationForView:self.adderssField.superview markString:@"请先获取准确的位置信息"];
        [_locService startUserLocationService];
        return;
    }
    
    if (self.ticketsField.text.length == 0) {
        [self shakeAnimationForView:self.ticketsField.superview markString:@"请填写门票价格"];
        return;
    }
    
    if (self.infoTextView.text.length == 0) {
        [self shakeAnimationForView:self.infoTextView.superview markString:@"请填简介"];
        return;
    }
    
    if (self.visitingTimeField.text.length == 0) {
        [self shakeAnimationForView:self.visitingTimeField.superview markString:@"请填写游览时长"];
        return;
    }
    
    if (self.headNameField.text.length == 0) {
        [self shakeAnimationForView:self.headNameField.superview markString:@"请填写负责人姓名"];
        return;
    }
    
    if (self.headPhoneField.text.length == 0) {
        [self shakeAnimationForView:self.headPhoneField.superview markString:@"请填写负责人电话"];
        return;
    }
    [self postScenicData];
}
#pragma mark  ----XMRTimePikerDelegate----
-(void)XMSelectTimesViewSetOneLeft:(NSString *)oneLeft andOneRight:(NSString *)oneRight andTowLeft:(NSString *)towLeft andTowRight:(NSString *)towRight{
    
    self.lineetime = [NSString stringWithFormat:@"%@:%@",towLeft,towRight];
    self.linestime = [NSString stringWithFormat:@"%@:%@",oneLeft,oneRight];
    
    self.lineTimeLabel.text = [NSString stringWithFormat:@"%@-%@",self.linestime,self.lineetime];
}
#pragma mark  ----UITextViewDelegate----
- (void)textViewDidChange:(UITextView *)textView
{
    CGRect bounds = textView.bounds;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    // 重新计算高度
    if (newSize.height > 24) {
        self.infoViewHeight.constant = newSize.height;
    }
}
#pragma mark  ----YBPopupMenuDelegate----
/**
 点击事件回调
 */
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu;
{
    /*** 字段赋值 ***/
    
    NSString *levelName = @"其它星级   ";
    if (index < 3) {
        
        levelName = [NSString stringWithFormat:@"%ldA",5-index];
    }
    self.levelString = levelName;
    [self.levelButton setTitle:levelName forState:UIControlStateNormal];
    [self.levelButton setButtonImageTitleStyle:(ButtonImageTitleStyleRightLeft) padding:4];
}
#pragma mark <UICollectionViewDataSource>
- (void)updataCollectionView;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self updataCollectionViewHeight];
        [self.photoCollectionView reloadData];
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imageArray.count;
}
- (TBTemplateResourceCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TBTemplateResourceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TBTemplateResourceCollectionViewCellID forIndexPath:indexPath];
    
    [cell valueCellImage:self.imageArray[indexPath.row] showDelete:YES index:indexPath.row];
    TBWeakSelf
    [cell setDeleteCell:^(NSInteger row)
     {
         [weakSelf friendlyPromptIndex:row];
         
     }];
    return cell;
}
// 提示
- (void)friendlyPromptIndex:(NSInteger)dex
{
    [self.view endEditing:YES];
    
    TBWeakSelf
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲，是否删除当前图片?"];
    [more showHandler:^{
        [weakSelf.imageArray removeObjectAtIndex:dex];
        [weakSelf updataCollectionView];
    }];
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    
    TBTemplateResourceCollectionViewCell *cell = (TBTemplateResourceCollectionViewCell*)[self.photoCollectionView cellForItemAtIndexPath:indexPath];
    
    [self.tool showPreviewPhotosArray:self.imageArray baseView:cell.backImageView selected:indexPath.row];
}

#pragma mark ---- TBChoosePhotosToolDelegate --

- (void)choosePhotosArray:(NSArray<UIImage*>*)images;
{
    TBWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf.imageArray addObjectsFromArray:images];
        [weakSelf updataCollectionView];
    });
    
}

/**
 计算cell高度
 */
- (void)updataCollectionViewHeight
{
    CGFloat number = 0;
    CGFloat  constant = 0.01;
    
    NSInteger h = self.imageArray.count/3;
    NSInteger s = (self.imageArray.count-3*h)>0?1:0;
    number = h+s;
    
    if (number > 0) {
        constant  = 10+(self.cellWidth+10)*number;
    }
    self.photoCollectionHeight.constant = constant;
    
}
#pragma mark  ----BMKLocationServiceDelegate----
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation;
{
    if (userLocation.location !=nil) {
        CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
        MJWeakSelf
        [_godeSearch searchAddressLatitude:coordinate.latitude longitude:coordinate.longitude searchResults:^(WCPositioningMode *mode) {
            
            [weakSelf updateAddressLabelData:mode];
        }];
        [_locService stopUserLocationService];
    }
}
#pragma mark  ----懒加载----
- (NSMutableArray *)imageArray
{
    if (!_imageArray)
    {
        _imageArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _imageArray;
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
