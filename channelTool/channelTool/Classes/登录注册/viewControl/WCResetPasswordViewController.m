//
//  WCResetPasswordViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/3.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCResetPasswordViewController.h"

@interface WCResetPasswordViewController ()

@property (nonatomic, weak) IBOutlet UITextField *verificationField;

@property (nonatomic, weak) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIButton *verificationButton;

@end

@implementation WCResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.verificationButton.layer.cornerRadius = 6;
}
#pragma mark  ----点击事件----
// 完成
- (IBAction)complete:(UIButton *)sender {
}
// 获取验证码
- (IBAction)verificationButton:(UIButton *)sender {
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
