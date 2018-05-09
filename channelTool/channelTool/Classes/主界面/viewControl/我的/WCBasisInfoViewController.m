//
//  WCCardInfoViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/8.
//  Copyright © 2018年 王小腊. All rights reserved.
//



#import "WCBasisInfoViewController.h"
#import "TBChoosePhotosTool.h"
#import "TBCityChooseView.h"
#import "WCUploadPromptView.h"
typedef NS_ENUM(NSInteger, PhotoType) {
    PhotoTypeHeader = 0,
    PhotoTypeEmblem
};

@interface WCBasisInfoViewController ()<TBChoosePhotosToolDelegate>
// 姓名
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
//身份证号码
@property (weak, nonatomic) IBOutlet UITextField *idCardTextField;
//地区
@property (weak, nonatomic) IBOutlet UITextField *regionTextField;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
//国徽
@property (weak, nonatomic) IBOutlet UIImageView *emblemImageView;

@property (nonatomic, strong) UIImage *headerImage;
@property (nonatomic, strong) UIImage *emblemImage;

@property (nonatomic, strong) TBChoosePhotosTool *photosTool;
// 选择的照片类型
@property (nonatomic) PhotoType photoType;
// 城市ID
@property (nonatomic, copy) NSString *cityCode;
@end

@implementation WCBasisInfoViewController
//视图将要出现
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"实名认证";
    [self requestUserInfo];
    
}
#pragma mark  ----点击事件----
//选择地区
- (IBAction)regionSelectClick:(UIButton *)sender {
    
    TBCityChooseView *chooseView = [[TBCityChooseView alloc] init];
    [chooseView showCity:self.cityCode];
    TBWeakSelf
    [chooseView setAddressChooseLocation:^(NSString *address, NSString *code) {
        weakSelf.regionTextField.text = address;
        weakSelf.cityCode = code;
    }];
    
}
//选择头像
- (IBAction)photoSelect:(UIButton *)sender {
    [self showSelectPhotoType:PhotoTypeHeader];
}
//选择国徽
- (IBAction)emblemSelect:(UIButton *)sender {
    [self showSelectPhotoType:PhotoTypeEmblem];
}
//提交审核
- (IBAction)submitAudit:(UIButton *)sender {
    
    TBWeakSelf
    NSString *msg = @"申请提交成功\n我们会在2个工作日内给您回复";
   [WCUploadPromptView showPromptString:msg isSuccessful:YES clickButton:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    if (self.nameTextField.text.length == 0) {
        [self shakeAnimationForView:self.nameTextField markString:@"请填写真实姓名"];
        return;
    }
    if (self.idCardTextField.text.length == 0) {
        [self shakeAnimationForView:self.idCardTextField markString:@"请填写身份证号码"];
        return;
    }
    if ([ZKUtil checkIsIdentityCard:self.idCardTextField.text]) {
        [self shakeAnimationForView:self.idCardTextField markString:@"身份证号码填写有误"];
        return;
    }
    if (self.cityCode.length == 0) {
        
        [self shakeAnimationForView:self.regionTextField markString:@"请选择地区"];
        return;
    }
    if (self.headerImage == nil) {
        [self shakeAnimationForView:self.photoImageView markString:@"请添加身份证正面照"];
        return;
    }
    if (self.emblemImage == nil) {
        [self shakeAnimationForView:self.emblemImageView markString:@"请添加身份证反面照"];
        return;
    }
    [self postUserInfo];
}

#pragma mark  ----fun tool----
- (void)showSelectPhotoType:(PhotoType)type
{
    self.photoType = type;
    self.photosTool = nil;
    self.photosTool = [[TBChoosePhotosTool alloc] init];
    self.photosTool.delegate = self;
    [self.photosTool showPhotosIndex:1];
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
#pragma mark  ----数据请求----
/**
 请求用户信息
 */
- (void)requestUserInfo
{
    UserInfo *info = [UserInfo account];
    
    if (info.userID) {
        
        [[ZKPostHttp shareInstance] POST:@"" params:@{} success:^(id  _Nonnull responseObject) {
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
}

/**
 提交信息
 */
- (void)postUserInfo
{
    [[ZKPostHttp shareInstance] POST:@"" params:@{} success:^(id  _Nonnull responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
#pragma mark  ----TBChoosePhotosToolDelegate----
- (void)choosePhotosArray:(NSArray<UIImage*>*)images;
{
    UIImage *image = images.firstObject;
    if (self.photoType == PhotoTypeHeader) {
        
        self.photoImageView.image = image;
        self.headerImage = image;
    }
    else if (self.photoType == PhotoTypeEmblem)
    {
        self.emblemImageView.image = image;
        self.emblemImage = image;
    }
}
- (void)dealloc
{
    _photosTool.delegate = nil;
    _photosTool = nil;
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
