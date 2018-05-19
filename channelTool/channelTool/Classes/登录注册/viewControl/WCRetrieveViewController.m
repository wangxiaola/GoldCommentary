//
//  WCRetrieveViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/3.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCRetrieveViewController.h"
#import "WCResetPasswordViewController.h"
@interface WCRetrieveViewController ()

@property (nonatomic, weak) IBOutlet UITextField *phoneField;

@end

@implementation WCRetrieveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"找回密码";
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
// 下一步
- (IBAction)nextStep:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.phoneField.text.length == 0) {
        
        [self shakeAnimationForView:self.phoneField markString:@"请输入手机号码"];
        return;
    }
    if (![ZKUtil isMobileNumber:self.phoneField.text]) {
        
        [self shakeAnimationForView:self.phoneField markString:@"请输入正确的手机号码"];
        return;
    }
    [self performSegueWithIdentifier:@"setPassword" sender:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     WCResetPasswordViewController *vc = [segue destinationViewController];
     vc.phone = self.phoneField.text;
 }


@end
