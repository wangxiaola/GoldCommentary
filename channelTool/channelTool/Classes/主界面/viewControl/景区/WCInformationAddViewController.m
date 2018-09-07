//
//  WCInformationAddViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/8/31.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCInformationAddViewController.h"
#import "TBMoreReminderView.h"
#import "WCPositioningViewController.h"
#import "LoginNavigationController.h"
#import "TBTemplateResourceCollectionViewCell.h"
#import "TBChoosePhotosTool.h"
#import "WCUploadPromptView.h"
#import "WCInformationListMode.h"
#import <IQKeyboardManager/IQTextView.h>
@interface WCInformationAddViewController ()<UITextViewDelegate,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,TBChoosePhotosToolDelegate>

@property (weak, nonatomic) IBOutlet UITextField *scenicNameField;

@property (weak, nonatomic) IBOutlet IQTextView *infoTextView;//简介
@property (weak, nonatomic) IBOutlet UITextField *coordinatesTextField;

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;

@property (nonatomic, strong) TBChoosePhotosTool * tool;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *sumberButton;
@property (strong, nonatomic) NSMutableArray *imageArray;
// 最大选择数
@property (assign, nonatomic) NSInteger maxRow;
@property (assign, nonatomic) CGFloat  cellWidth;

@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;

@end

@implementation WCInformationAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGB(241, 241, 241);
    [self setUpView];
    
    if (self.scenicID.length == 0 && self.mode) {
        
        [self updateScenicData];
    }
    [self updateNavigationItemTitle];
}

//#pragma mark ---初始化视图----
- (void)setUpView
{
    self.infoTextView.delegate = self;
    self.scenicNameField.delegate = self;

    self.tool = [[TBChoosePhotosTool alloc] init];
    self.tool.delegate = self;
    self.cellWidth = (_SCREEN_WIDTH- 10*8)/3;

    self.maxRow = 3;

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

    [self.sumberButton setTitle:self.scenicID.length > 0 ?@"创 建 采 集 点":@"编 辑 采 集 点" forState:UIControlStateNormal];

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
 更新经纬度

 @param lat 纬度
 @param lng 经度
 */
- (void)updateCoordinatesLatitude:(NSString *)lat longitude:(NSString *)lng addrees:(NSString *)addrees;
{
    if (lat.length == 0 || lng.length == 0) {
        self.coordinatesTextField.text = @"";
        self.latitude = @"";
        self.longitude = @"";
        return;
    }
    self.latitude = lat;
    self.longitude = lng;
    self.coordinatesTextField.text = addrees;
}
//#pragma mark  ----数据上传----
// 更新景点数据
- (void)updateScenicData
{
    self.scenicNameField.text = self.mode.name;
    [self.imageArray addObjectsFromArray:[self.mode.allimg componentsSeparatedByString:@","]];
    [self updataCollectionView];

    self.infoTextView.text = self.mode.info;
    [self textViewDidChange:self.infoTextView];

    // 采集类型
    NSInteger unit = self.mode.type;
    self.segControl.selectedSegmentIndex = unit;
    self.navigationItem.title = unit == 0?@"":@"";
    [self updateCoordinatesLatitude:self.mode.lat longitude:self.mode.lng addrees:self.mode.address];
}

/**
 更新标题
 */
- (void)updateNavigationItemTitle{
    
    NSString *prefixString = @"创建";
    if (self.scenicID.length == 0 && self.mode) {
        
        prefixString = @"编辑";
    }
    
    NSString *suffixString = @"采集点";
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@%@",prefixString,suffixString];
}
#pragma mark  ----上传----
// 上传图片
- (void)uploadPictures
{

    hudShopWUploadProgress(0.1, @"正在上传图片");

    dispatch_group_t group = dispatch_group_create();
    TBWeakSelf
    for (int i = 0; i<self.imageArray.count; i++) {
        dispatch_group_enter(group);
        id data = self.imageArray[i];
        if ([data isKindOfClass:[UIImage class]]) {

            [ZKPostHttp uploadImage:POST_URL Data:UIImageJPEGRepresentation(data, 0.5) success:^(id  _Nonnull responseObj) {

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
            weakSelf.mode.allimg = [weakSelf.imageArray componentsJoinedByString:@","];
            [weakSelf submitScenicData];
        }
    });


}
// 提交数据
- (void)submitScenicData
{
    
    NSString *lat = self.latitude.length > 0?self.latitude:@"";
    NSString *lng = self.longitude.length > 0?self.longitude:@"";
    NSString *interfaceId = @"333";
    NSString *sid = self.mode.ID? :@"";
    NSString *shopid = self.scenicID ? self.scenicID:self.mode.shopid;
    
    NSDictionary *dic = @{@"interfaceId":interfaceId,
                          @"id":[UserInfo account].userID,
                          @"sid":sid,
                          @"name":self.scenicNameField.text,
                          @"info":self.infoTextView.text,
                          @"allimg":[self.imageArray componentsJoinedByString:@","],
                          @"lat":lat,
                          @"lng":lng,
                          @"shopid":shopid,
                          @"address":self.coordinatesTextField.text,
                          @"type":[NSNumber numberWithInteger:self.segControl.selectedSegmentIndex]
                          };

    hudShopWUploadProgress(0.8, @"正在提交信息");
    TBWeakSelf
    [[ZKPostHttp shareInstance] POST:POST_URL params:dic success:^(id  _Nonnull responseObject) {

        if ([[responseObject valueForKey:@"errcode"] isEqualToString:@"00000"]) {

            [WCUploadPromptView showPromptString:self.scenicID.length > 0?@"创建成功":@"编辑成功" isSuccessful:YES clickButton:^{

                [self noticeInformUpdate];
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
- (void)noticeInformUpdate
{
    NSInteger type;
    if (self.scenicID.length == 0 && self.mode) {
        
        type = 3;
    }
    else
    {
        type = self.segControl.selectedSegmentIndex;
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NoticeInformUpdate" object:nil userInfo:@{@"type":[NSNumber numberWithInteger:type]}];
    
}
#pragma mark  ----点击事件----
- (IBAction)selectPhoto:(UIButton *)sender {

    if (self.imageArray.count == self.maxRow) {

        [UIView addMJNotifierWithText:@"请先删除一些照片" dismissAutomatically:YES];
        return;
    }
    [self.tool showPhotosIndex:self.maxRow-self.imageArray.count];

}

- (IBAction)pushMapCoordinates:(UIButton *)sender {

    WCPositioningViewController *mapView = [[WCPositioningViewController alloc] init];
    LoginNavigationController *nav = [[LoginNavigationController alloc] initWithRootViewController:mapView];

    [self presentViewController:nav animated:NO completion:nil];

    TBWeakSelf
    [mapView setSearchResults:^(WCPositioningMode *mode) {

        [weakSelf updateCoordinatesLatitude:mode.latitude longitude:mode.longitude addrees:mode.adderss];
    }];
}

- (IBAction)updataAttractions:(id)sender {

    if (self.imageArray.count == 0) {

        [self shakeAnimationForView:self.scenicNameField.superview markString:@"请至少上传一张图片"];
        return;
    }

    if (self.scenicNameField.text.length == 0) {
        [self shakeAnimationForView:self.scenicNameField.superview markString:@"请填写场所名称"];
        return;
    }
    if (self.infoTextView.text.length == 0) {
        [self shakeAnimationForView:self.infoTextView.superview markString:@"请填写简介"];
        return;
    }

    if (self.latitude.length == 0 || self.longitude.length == 0 || self.coordinatesTextField.text.length == 0) {
        
        [self shakeAnimationForView:self.coordinatesTextField.superview markString:@"请选择地址"];
        return;
    }
  
    [self uploadPictures];
}

#pragma mark  ----UITextViewDelegate----
- (void)textViewDidChange:(UITextView *)textView
{
    [textView setContentInset:UIEdgeInsetsZero];
    [textView setTextAlignment:NSTextAlignmentLeft];

    CGRect bounds = textView.bounds;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    // 重新计算高度
    if (newSize.height > 24) {
        self.infoViewHeight.constant = newSize.height;
    }

    if (newSize.height > 120)
    {
        self.infoViewHeight.constant = 120.0f;
    }
}
#pragma mark  ----UITextFieldDelegate----
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if ([string isEqualToString:@"\n"])
    { //按下return
        [textField resignFirstResponder];
        return YES;
    }
     NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (toBeString.length > 12) {
        
        textField.text = [toBeString substringToIndex:12];
        [UIView addMJNotifierWithText:@"名称不能超过12位汉字" dismissAutomatically:YES];
        return NO;
    }

    return YES;
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

    NSInteger rows = self.imageArray.count >3?3:self.imageArray.count;
    return rows;
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
    CGFloat  constant  = 0.01f;
    if (self.imageArray.count > 0) {
        constant  = 20+self.cellWidth;
    }
    self.photoCollectionHeight.constant = constant;

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
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
