//
//  WCRegistrationViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/3.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCRegistrationViewController.h"
#import "TBCountdownSingle.h"

@interface WCRegistrationViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *phoneField;

@property (nonatomic, weak) IBOutlet UITextField *verificationField;

@property (nonatomic, weak) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIButton *verificationButton;
// 验证码
@property (nonatomic, copy) NSString *verificationString;
@end

@implementation WCRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.verificationButton.layer.cornerRadius = 6;
    self.passwordField.delegate = self;
    
    // 判断是否已经获取了验证码
    int num = [TBCountdownSingle sharedInstance].verifyTimeNumber;
    if (num > 0) {
        [self startTheDate:num];
         self.verificationString = [ZKUtil getUserDataForKey:Verification_code];
         self.phoneField.text    = [ZKUtil getUserDataForKey:Verification_phone];
    }
}
#pragma mark  ----fun tool----

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
  开始计时

 @param number 秒
 */
- (void)startTheDate:(int)number
{
    [[TBCountdownSingle sharedInstance] setUser:YES];
    TBWeakSelf
    [[TBCountdownSingle sharedInstance] startTheDatelength:number timeDate:^(NSString *numberString) {
        
        [weakSelf.verificationButton setTitle:[NSString stringWithFormat:@"还剩%@s",numberString] forState:UIControlStateNormal];
        weakSelf.verificationButton.userInteractionEnabled = NO;
        
    } endTime:^{
        
        //设置界面的按钮显示 根据自己需求设置
        [weakSelf.verificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        weakSelf.verificationButton.userInteractionEnabled = YES;
    }];
}
#pragma mark  ----点击事件----
// 注册
- (IBAction)registration:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (self.phoneField.text.length == 0) {
        
        [self shakeAnimationForView:self.phoneField markString:@"请输入手机号码"];
        return;
    }
    if (![ZKUtil isMobileNumber:self.phoneField.text]) {
        
        [self shakeAnimationForView:self.phoneField markString:@"请输入正确的手机号码"];
        return;
    }
    if (![self.verificationField.text isEqualToString:self.verificationString]) {
        
        [self shakeAnimationForView:self.verificationField markString:@"验证码有误"];
        return;
    }
    if (self.passwordField.text.length == 0) {
        [self shakeAnimationForView:self.passwordField markString:@"请输入登录密码"];
        return;
    }
    NSInteger number = self.passwordField.text.length;
    if (number>12 || number<6) {
        
        [self shakeAnimationForView:self.passwordField markString:@"登录密码为6-12位"];
        return;
    }
    [self requestRegistration];
}
// 协议
- (IBAction)agreement:(UIButton *)sender {
    
    
}
// 获取验证码
- (IBAction)verificationButton:(UIButton *)sender {
    
    [self requestVerificationCode];
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
        [textField resignFirstResponder];
        textField.text = [toBeString substringToIndex:12];
        [self shakeAnimationForView:self.passwordField markString:@"密码字数不能超过12个"];
        return NO;
    }
    
    return YES;
}
#pragma mark  ----请求注册----
- (void)requestRegistration
{
    [self.view endEditing:YES];
    
    hudShowLoading(@"正在登录");
    [[ZKPostHttp shareInstance] POST:@"" params:@{} success:^(id  _Nonnull responseObject) {
        
        hudDismiss();
    } failure:^(NSError * _Nonnull error) {
        hudShowError(@"网络异常！");
    }];
}
// 请求验证码
- (void)requestVerificationCode
{
    [self.view endEditing:YES];
    
    hudShowLoading(@"正在获取验证码");
    [[ZKPostHttp shareInstance] POST:@"" params:@{} success:^(id  _Nonnull responseObject) {
        
        hudDismiss();
    } failure:^(NSError * _Nonnull error) {
        hudShowError(@"网络异常！");
    }];
    [self startTheDate:60];
//    [ZKUtil cacheUserValue:self.verificationString key:Verification_code];
//    [ZKUtil cacheUserValue:self.phoneField.text key:Verification_phone];
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
