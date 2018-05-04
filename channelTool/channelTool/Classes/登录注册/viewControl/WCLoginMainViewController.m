//
//  WCLoginMainViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/3.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCLoginMainViewController.h"
#import "AppDelegate.h"

@interface WCLoginMainViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *phoneField;

@property (nonatomic, weak) IBOutlet UITextField *passwordField;

@end

@implementation WCLoginMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.passwordField.delegate = self;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
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
#pragma mark  ----点击事件----
// 开始登录
- (IBAction)loginSender:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (self.phoneField.text.length == 0) {
        
        [self shakeAnimationForView:self.phoneField markString:@"请输入手机号码"];
        return;
    }
    if (![ZKUtil isMobileNumber:self.phoneField.text]) {
        
        [self shakeAnimationForView:self.phoneField markString:@"请输入正确的手机号码"];
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
    [self requestLogin];
}
// 注册
- (IBAction)registeredSender:(UIButton *)sender {
    [self.view endEditing:YES];
    [self performSegueWithIdentifier:@"registered" sender:nil];
    
}
// 找回密码
- (IBAction)forgotPasswordSender:(UIButton *)sender {
    [self.view endEditing:YES];
    [self performSegueWithIdentifier:@"retrieve" sender:nil];
    
}
// 取消
- (IBAction)goHomeController:(UIBarButtonItem *)sender {
    
    UIWindow *window = APPDELEGATE.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}
#pragma mark  ----数据请求----
- (void)requestLogin
{
    [self.view endEditing:YES];
    
    hudShowLoading(@"正在登录");
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
