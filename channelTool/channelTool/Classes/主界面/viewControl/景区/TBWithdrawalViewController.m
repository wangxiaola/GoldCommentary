//
//  TBWithdrawalViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/28.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBWithdrawalViewController.h"

@interface TBWithdrawalViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankCardLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;// 余额
@property (weak, nonatomic) IBOutlet UIButton *withdrawalButton;// 提现按钮
@property (strong, nonatomic) UserBankInfo *bankInfo;
@end

@implementation TBWithdrawalViewController
//视图将要出现
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"提现";
    self.view.backgroundColor = RGB(245, 245, 245);
    [self setBaseData];
}
- (void)setBaseData
{
    self.bankInfo = [UserInfo account].bankInfo;
    
    [self modifyWithdrawalButtonState:NO];
    [self.amountField becomeFirstResponder];
    self.amountField.delegate = self;
    
    self.bankNameLabel.text = self.bankInfo.bankname;
    NSString *card = [self.bankInfo.bankno substringWithRange:NSMakeRange(self.bankInfo.bankno.length-4, 4)];
    self.bankCardLabel.text = [NSString stringWithFormat:@"尾号%@储蓄卡",card];
    self.balanceLabel.text = [NSString stringWithFormat:@"可用余额%@元",self.money];
    
    
}
#pragma mark  ----funTool----

/**
 修改按钮状态
 
 @param state yes可点击
 */
- (void)modifyWithdrawalButtonState:(BOOL)state
{
    self.withdrawalButton.userInteractionEnabled = state?YES:NO; //控件不能点
    self.withdrawalButton.alpha = state?1:0.5; //变暗
}

/**
 修改按钮金额超出状态
 
 @param beyond YES
 */
- (void)modifyWithdrawalButtonIsBeyond:(BOOL)beyond
{
    [self.withdrawalButton setTitle:beyond?@"提现金额超出余额":@"确 认 提 现" forState:UIControlStateNormal];
    [self.withdrawalButton setTitleColor:beyond?[UIColor redColor]:[UIColor whiteColor] forState:UIControlStateNormal];
}
#pragma mark  ----按钮点击事件----
- (IBAction)allWithdrawalClick:(UIButton *)sender {
    
    self.amountField.text = [NSString stringWithFormat:@"%.2f",floor((self.money.doubleValue)*100)/100];
    [self modifyWithdrawalButtonState:self.amountField.text.length>0];
}
- (IBAction)withdrawalClick:(UIButton *)sender {
    
    [self.amountField resignFirstResponder];
    if (self.amountField.text.length == 0) {
        
        [UIView addMJNotifierWithText:@"请输入提现金额" dismissAutomatically:YES];
        return;
    }
    
    BOOL beyond = self.amountField.text.doubleValue > self.money.doubleValue;
    
    if (beyond) {
        [UIView addMJNotifierWithText:@"提现金额大于余额" dismissAutomatically:YES];
        return;
    }
    
    hudShowLoading(@"提现申请中");
    NSDictionary *dic = @{@"interfaceId":@"315",
                          @"phone":[UserInfo account].phone,
                          @"money":self.amountField.text};
    
    [[ZKPostHttp shareInstance] POST:POST_URL params:dic success:^(id  _Nonnull responseObject) {
        
        if ([[responseObject valueForKey:@"errcode"] isEqualToString:@"00000"]) {

            hudShowSuccess(@"提现申请成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            hudShowError([responseObject valueForKey:@"errmsg"]);
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        hudShowError(@"网络异常");
    }];
}
#pragma mark  ----UITextFieldDelegate----
// 禁止文本其它操作
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    return NO;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    [self modifyWithdrawalButtonState:toBeString.length > 0];
    if (![ZKUtil ismoney:toBeString] && toBeString.length>0)
    {
        return NO;
    }
    BOOL beyond = toBeString.doubleValue > self.money.doubleValue;
    [self modifyWithdrawalButtonIsBeyond:beyond];
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    [self modifyWithdrawalButtonState:self.amountField.text.length > 0];
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
