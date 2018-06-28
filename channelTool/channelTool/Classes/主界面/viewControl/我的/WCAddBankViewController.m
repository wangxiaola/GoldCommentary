//
//  WCAddBankViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/26.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCAddBankViewController.h"
#import "WCUploadPromptView.h"
#import "TBMoreReminderView.h"
@interface WCAddBankViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankIDTextField;
@property (weak, nonatomic) IBOutlet UIButton *bindingButton;

@end

@implementation WCAddBankViewController
//视图将要出现
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = BACKLIST_COLOR;
     self.navigationItem.title = @"收款银行";
    self.bankIDTextField.delegate = self;
    [self setBaseData];
}
#pragma mark  ----fun tool----
// 赋值
- (void)setBaseData
{
   UserBankInfo *bankInfo = [UserInfo account].bankInfo;
    
    if (bankInfo.isbank == 1) {
        
        self.nameTextField.text = bankInfo.bankuser;
        self.bankNameTextField.text = bankInfo.bankname;
        self.bankIDTextField.text = bankInfo.bankno;

        [self.bindingButton setTitle:@"更 新 卡 号" forState:UIControlStateNormal];
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
#pragma mark  ----Validation data legal----

- (IBAction)validationDataLegal:(UIButton *)sender {
    
    if (self.nameTextField.text.length == 0) {
        [self shakeAnimationForView:self.nameTextField.superview markString:self.nameTextField.placeholder];
        return;
    }
    if (self.bankNameTextField.text.length == 0) {
        [self shakeAnimationForView:self.bankNameTextField.superview markString:self.bankNameTextField.placeholder];
        return;
    }
    if (self.bankIDTextField.text.length == 0) {
        [self shakeAnimationForView:self.bankIDTextField.superview markString:self.bankIDTextField.placeholder];
        return;
    }
    if (![ZKUtil isValidCardNumber:self.bankIDTextField.text]) {
        [self shakeAnimationForView:self.bankIDTextField.superview markString:@"银行卡号填写有误，请查看。"];
        return;
        
    }
    // 如果已经绑定要提示用户
    UserBankInfo *bankInfo = [UserInfo account].bankInfo;
    if (bankInfo.isbank == 0 ) {
        
        [self bindingBankInfo];
    }
    else
    {
        TBMoreReminderView *moreView =  [[TBMoreReminderView alloc] initShowPrompt:@"亲，你已经绑定了银行卡，是否要重新绑定？"];
        [moreView showHandler:^{
            
            [self bindingBankInfo];
        }];
    }
}
#pragma mark  ----数据请求----
- (void)bindingBankInfo
{
    NSString *bankno = self.bankIDTextField.text;
    NSDictionary *bankDic = @{@"interfaceId":@"313",
                              @"id":[UserInfo account].userID,
                              @"bankno":bankno,
                              @"bankname":self.bankNameTextField.text,
                              @"bankuser":self.nameTextField.text};
    
    hudShowLoading(@"正在绑定");
    TBWeakSelf
    [[ZKPostHttp shareInstance] POST:POST_URL params:bankDic success:^(id  _Nonnull responseObject) {
        
        if ([[responseObject valueForKey:@"errcode"] isEqualToString:@"00000"]) {
            
            UserBankInfo *bank= [UserBankInfo mj_objectWithKeyValues:bankDic];
            bank.isbank = 1;
            UserInfo *info = [UserInfo account];
            info.bankInfo = bank;
            
            [UserInfo saveAccount:info];
            
            NSString *msg = @"银行信息绑定成功";
            hudShowSuccess(msg);
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            hudDismiss();
            [UIView addMJNotifierWithText:[responseObject valueForKey:@"errmsg"] dismissAutomatically:YES];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        hudShowError(@"网络异常");
    }];
}

#pragma mark  ----UITextFieldDelegate----
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.bankIDTextField) {
        // 4位分隔银行卡卡号
        NSString *text = [textField text];
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"%@",text);
        //    text为输入框内的文本，没有“ ”的内容
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        if ([newString stringByReplacingOccurrencesOfString:@" " withString:@""].length >= 21) {
            return NO;
        }
        [textField setText:newString];
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
