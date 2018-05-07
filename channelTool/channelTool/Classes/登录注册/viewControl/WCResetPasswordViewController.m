//
//  WCResetPasswordViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/3.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCResetPasswordViewController.h"
#import "TBCountdownSingle.h"

@interface WCResetPasswordViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *verificationField;

@property (nonatomic, weak) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIButton *verificationButton;
// 验证码
@property (nonatomic, copy) NSString *verificationString;

@end

@implementation WCResetPasswordViewController
//视图将要出现
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.verificationButton.layer.cornerRadius = 6;
    self.passwordField.delegate = self;
    
    // 判断是否已经获取了验证码
    int num = [TBCountdownSingle sharedInstance].setPasswordTimeNumber;
    if (num > 0) {
        [self startTheDate:num];
        self.verificationString = [ZKUtil getUserDataForKey:Verification_code];
    }
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
 开始计时
 
 @param number 秒
 */
- (void)startTheDate:(int)number
{
    [[TBCountdownSingle sharedInstance] setUser:NO];
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
// 完成
- (IBAction)complete:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
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
    [self resetPassword];
}
// 获取验证码
- (IBAction)verificationButton:(UIButton *)sender {
    
    [self requestVerificationCode];
}
#pragma mark  ----网络请求----
//验证码请求
- (void)requestVerificationCode
{
    [self.view endEditing:YES];
    
    hudShowLoading(@"正在请求");
    [[ZKPostHttp shareInstance] POST:@"" params:@{} success:^(id  _Nonnull responseObject) {
        
        hudDismiss();
    } failure:^(NSError * _Nonnull error) {
        hudShowError(@"网络异常！");
    }];
    [self startTheDate:60];
    //   [ZKUtil cacheUserValue:self.verificationString key:Verification_code];
}
//重置密码
- (void)resetPassword
{
    hudShowLoading(@"正在重置");
    [[ZKPostHttp shareInstance] POST:@"" params:@{} success:^(id  _Nonnull responseObject) {
        
        hudDismiss();
    } failure:^(NSError * _Nonnull error) {
        hudShowError(@"网络异常！");
    }];
}
#pragma mark  ----UITextFieldDelegate----
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""] || string.length == 0)
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
