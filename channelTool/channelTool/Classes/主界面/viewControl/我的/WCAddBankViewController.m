//
//  WCAddBankViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/26.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCAddBankViewController.h"
#import "WCUploadPromptView.h"
@interface WCAddBankViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankIDTextField;

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
    [self setBaseData];
}
#pragma mark  ----fun tool----
- (void)setBaseData
{
   UserBankInfo *bankInfo = [UserInfo account].bankInfo;
    
    if (bankInfo.isbank == 1) {
        
        self.nameTextField.text = bankInfo.bankuser;
        self.bankNameTextField.text = bankInfo.bankname;
        self.bankIDTextField.text = bankInfo.bankno;
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
    if ([self isBankCard:self.bankIDTextField.text]) {
        [self shakeAnimationForView:self.bankIDTextField.superview markString:@"银行卡号填写有误，请查看。"];
        return;
        
    }
    [self bindingBankInfo];
}
#pragma mark  ----数据请求----
- (void)bindingBankInfo
{
    NSDictionary *bankDic = @{@"interfaceId":@"313",
                              @"id":[UserInfo account].userID,
                              @"bankno":self.bankIDTextField.text,
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
#pragma mark 判断银行卡号是否合法
-(BOOL)isBankCard:(NSString *)cardNumber{
    if(cardNumber.length==0){
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++){
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c)){
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--){
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo){
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
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
