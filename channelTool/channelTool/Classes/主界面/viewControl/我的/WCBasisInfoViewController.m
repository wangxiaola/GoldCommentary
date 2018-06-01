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
#import <SDWebImage/SDWebImageDownloader.h>
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

@property (nonatomic, copy) NSString *headerImageURL;
@property (nonatomic, copy) NSString *emblemImageURL;

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
    self.view.backgroundColor = BACKLIST_COLOR;
    
    [self setBaseData];
    
}
#pragma mark  ----点击事件----
//选择地区
- (IBAction)regionSelectClick:(UIButton *)sender {
    [self.view endEditing:YES];
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
    [self.view endEditing:YES];
    [self showSelectPhotoType:PhotoTypeHeader];
}
//选择国徽
- (IBAction)emblemSelect:(UIButton *)sender {
    [self.view endEditing:YES];
    [self showSelectPhotoType:PhotoTypeEmblem];
}
//提交审核
- (IBAction)submitAudit:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.nameTextField.text.length == 0) {
        [self shakeAnimationForView:self.nameTextField markString:@"请填写真实姓名"];
        return;
    }
    if (self.idCardTextField.text.length == 0) {
        [self shakeAnimationForView:self.idCardTextField markString:@"请填写身份证号码"];
        return;
    }
    if (![ZKUtil checkIsIdentityCard:self.idCardTextField.text]) {
        [self shakeAnimationForView:self.idCardTextField markString:@"身份证号码填写有误"];
        return;
    }
    if (self.cityCode.length == 0) {
        
        [self shakeAnimationForView:self.regionTextField markString:@"请选择地区"];
        return;
    }
    if (self.headerImage == nil && self.headerImageURL.length == 0) {
        [self shakeAnimationForView:self.photoImageView markString:@"请添加身份证正面照"];
        return;
    }
    if (self.emblemImage == nil && self.emblemImageURL.length == 0) {
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
- (void)setBaseData
{
    UserCertification *cer = [UserInfo account].certification;
    if (cer.ispass.integerValue != 0 ) {
        
        self.nameTextField.text = cer.nickname;
        self.idCardTextField.text = cer.idcard;
        self.regionTextField.text = cer.address;
        self.cityCode = cer.region;
        
        if (![cer.idcardimgb containsString:POST_IMAGE_URL]) {
            self.emblemImageURL = [NSString stringWithFormat:@"%@%@",POST_IMAGE_URL,cer.idcardimgb];
        }
        else
        {
            self.emblemImageURL = cer.idcardimgb;
        }
        
        if (![cer.idcardimgf containsString:POST_IMAGE_URL]) {
            self.headerImageURL = [NSString stringWithFormat:@"%@%@",POST_IMAGE_URL,cer.idcardimgf];
        }
        else
        {
            self.headerImageURL = cer.idcardimgf;
        }
        
        [ZKUtil downloadImage:self.photoImageView imageUrl:self.headerImageURL duImageName:@"ID_Card_Top"];
        [ZKUtil downloadImage:self.emblemImageView imageUrl:self.emblemImageURL duImageName:@"ID_Card_Back"];
    }
}
/**
 提交信息
 */
- (void)postUserInfo
{
    hudShopWUploadProgress(0.0, @"正在上传图片");
    
    dispatch_group_t group = dispatch_group_create();
    
    TBWeakSelf
    if (self.headerImageURL.length == 0 ) {
        
        // 上传封面
        dispatch_group_enter(group);
        [self uploadImage:self.headerImage success:^(NSString *url) {
            
            weakSelf.headerImageURL = url;
            dispatch_group_leave(group);
            hudShopWUploadProgress(0.3, @"正在上传图片");
        }];
        
    }
    
    if (self.emblemImageURL.length == 0) {
        
        // 上传背面
        dispatch_group_enter(group);
        [self uploadImage:self.emblemImage success:^(NSString *url) {
            
            weakSelf.emblemImageURL = url;
            dispatch_group_leave(group);
            hudShopWUploadProgress(0.6, @"正在上传图片");
        }];
    }
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (weakSelf.headerImageURL.length > 0 && weakSelf.emblemImageURL.length > 0) {
            
            [weakSelf submitCertificationList];
        }
        else
        {
            hudShowError(@"身份证图片上传失败");
        }
    });
}

/**
 提交认证信息
 */
- (void)submitCertificationList
{
    hudShopWUploadProgress(0.8, @"正在提交信息");
    
    NSDictionary *dic = @{@"id":[UserInfo account].userID,
                          @"name":self.nameTextField.text,
                          @"idcard":self.idCardTextField.text,
                          @"region":self.cityCode,
                          @"idcardimgf":self.headerImageURL,
                          @"idcardimgb":self.emblemImageURL,
                          @"interfaceId":@"294"};
    
    TBWeakSelf
    [[ZKPostHttp shareInstance] POST:POST_URL params:dic success:^(id  _Nonnull responseObject) {
        
        if ([[responseObject valueForKey:@"errcode"] isEqualToString:@"00000"]) {
            
            hudDismiss();
            UserInfo *info = [UserInfo account];
            info.certification.ispass = @"2";
            [UserInfo saveAccount:info];
            
            NSString *msg = @"申请提交成功\n我们会在2个工作日内给您回复";
            [WCUploadPromptView showPromptString:msg isSuccessful:YES clickButton:^{
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
        hudShowError(@"认证失败，请查看网络连接");
    }];
}
/**
 上传图片
 
 @param image 图片
 @param urlRes 结果
 */
- (void)uploadImage:(UIImage *)image success:(void(^)(NSString *url))urlRes
{
    
    [ZKPostHttp uploadImage:POST_IMAGE_URL Data:UIImageJPEGRepresentation(_headerImage, 0.7) success:^(id  _Nonnull responseObj) {
        NSDictionary *data = [responseObj valueForKey:@"data"];
        if (urlRes) {
            urlRes([data valueForKey:@"url"]);
        }
    } failure:^(NSError * _Nonnull error) {
        
        if (urlRes) {
            urlRes(@"");
        }
    }];
}
#pragma mark  ----TBChoosePhotosToolDelegate----
- (void)choosePhotosArray:(NSArray<UIImage*>*)images;
{
    UIImage *image = images.firstObject;
    if (self.photoType == PhotoTypeHeader) {
        
        self.photoImageView.image = image;
        self.headerImage = image;
        self.headerImageURL = @"";
    }
    else if (self.photoType == PhotoTypeEmblem)
    {
        self.emblemImageView.image = image;
        self.emblemImage = image;
        self.emblemImageURL = @"";
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
