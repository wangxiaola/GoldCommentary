//
//  WCInfoModifyViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/7.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCInfoModifyViewController.h"
#import "WCPersonalHeaderView.h"
#import "TBChoosePhotosTool.h"

@interface WCInfoModifyViewController ()<UITextFieldDelegate,TBChoosePhotosToolDelegate>

@property (nonatomic, strong) WCPersonalHeaderView *headerView;
@property (nonatomic, strong) TBChoosePhotosTool *photosTool;
@property (nonatomic, strong) UIImage *headerImage;
@end

@implementation WCInfoModifyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
}
#pragma mark  ----视图创建----
- (void)createViews
{
    self.view.backgroundColor = BACKLIST_COLOR;
    self.headerView = [WCPersonalHeaderView loadNibViewStyle:PersonalHeaderViewStyleEditor];
    [self.view addSubview:self.headerView];
    
    UIView *contenView = [[UIView alloc] init];
    contenView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contenView];
    
    UILabel *nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.text = @"昵称：";
    nickNameLabel.textAlignment = NSTextAlignmentRight;
    nickNameLabel.font = [UIFont systemFontOfSize:14];
    [contenView addSubview:nickNameLabel];
    
    UITextField *nickNameField = [[UITextField alloc] init];
    nickNameField.placeholder = @"请输入新的昵称";
    nickNameField.textAlignment = NSTextAlignmentLeft;
    nickNameField.borderStyle = UITextBorderStyleNone;
    nickNameField.textColor = [UIColor blackColor];
    nickNameField.font = [UIFont systemFontOfSize:14];
    nickNameField.returnKeyType = UIReturnKeyDone;
    nickNameField.keyboardType = UIKeyboardTypeDefault;
    nickNameField.delegate = self;
    [contenView addSubview:nickNameField];
    
    UIView *linView = [[UIView alloc] init];
    linView.backgroundColor = BODER_COLOR;
    [contenView addSubview:linView];
    
    TBWeakSelf
    [self.headerView setGoBack:^{
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    }];
    [self.headerView setComplete:^{
        
        [weakSelf complete];
    }];
    [self.headerView setUpdataHeaderPortrait:^{
        
        [weakSelf updataHeaderPortrait];
    }];
    
    [contenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.headerView.mas_bottom).offset(16);
    }];
    
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.left.equalTo(contenView.mas_left);
        make.height.equalTo(@30);
        make.top.equalTo(contenView.mas_top).offset(20);
    }];
    
    [nickNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickNameLabel.mas_right);
        make.centerY.equalTo(nickNameLabel.mas_centerY);
        make.height.equalTo(nickNameLabel.mas_height);
        make.right.equalTo(contenView.mas_right).offset(10);
    }];
    
    [linView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(nickNameField);
        make.top.equalTo(nickNameField.mas_bottom);
        make.height.equalTo(@0.5);
    }];
}
#pragma mark  ----事件处理----
- (void)complete
{
    
}
- (void)updataHeaderPortrait
{
    self.photosTool = nil;
    self.photosTool = [[TBChoosePhotosTool alloc] init];
    self.photosTool.delegate = self;
    [self.photosTool showHeadToChooseViewController:nil];
    
}
#pragma mark  ----UITextFieldDelegate----
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"])
    { //按下return
        [textField resignFirstResponder];
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length > 8) {
        [textField resignFirstResponder];
        textField.text = [toBeString substringToIndex:8];
        [UIView addMJNotifierWithText:@"昵称字数不能超过8个" dismissAutomatically:YES];
        return NO;
    }
    
    return YES;
}
#pragma mark  ----TBChoosePhotosToolDelegate----
- (void)choosePhotosArray:(NSArray<UIImage*>*)images;
{
    UIImage *image = images.firstObject;
    if ([image isKindOfClass:[UIImage class]]) {
      
        self.headerImage = image;
        self.headerView.headerImageView.image = image;
    }
    else
    {
        [UIView addMJNotifierWithText:@"图片异常" dismissAutomatically:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    _photosTool.delegate = nil;
    _photosTool = nil;
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
