//
//  WCFeedbackViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/7.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCFeedbackViewController.h"
#import "IQTextView.h"

@interface WCFeedbackViewController ()
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) IQTextView *textView;
@end

@implementation WCFeedbackViewController

- (IQTextView *)textView
{
    if (!_textView)
    {
        _textView = [[IQTextView alloc] init];
        _textView.placeholder = @"写下你对客户端发现的功能建议或发现的系统问题，么么哒!";
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.textColor = [UIColor blackColor];
        _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _textView.backgroundColor = [UIColor whiteColor];
    }
    return _textView;
}
- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [NSMutableDictionary params];
        [_params setValue:@"188" forKey:@"interfaceId"];
        [_params setValue:@"user" forKey:@"cfrom"];
        [_params setValue:@"" forKey:@"info"];
        [_params setValue:[UserInfo account].userID forKey:@"did"];
        
    }
    return _params;
}

// 提交按钮

- (UIButton *)commitBtn
{
    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,  self.view.bounds.size.height - 200, self.view.bounds.size.width - 16, 46)];
        _commitBtn.backgroundColor = NAVIGATION_COLOR;
        _commitBtn.layer.masksToBounds = YES;
        _commitBtn.layer.cornerRadius = 4.0;
        _commitBtn.clipsToBounds = YES;
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(commitBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_commitBtn setTitle:@"提 交" forState:UIControlStateNormal];
        //适配系统
        if (@available(iOS 9.0, *)) {
            _commitBtn.titleLabel.font = [UIFont monospacedDigitSystemFontOfSize:16 weight:0.2];
        } else if (@available(iOS 8.2, *)) {
            _commitBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:0.2];
        }
    }
    return _commitBtn;
}
#pragma mark  ----视图创建----
- (void)createViews
{
    UIView *linView = [[UIView alloc] init];
    linView.backgroundColor = NAVIGATION_COLOR;
    [self.view addSubview:linView];
    
    UILabel *tsLabel = [[UILabel alloc] init];
    tsLabel.font = [UIFont systemFontOfSize:15];
    tsLabel.text = @"反馈内容";
    [self.view addSubview:tsLabel];
    
    UIImage *image = [UIImage imageNamed:@"infoTextView"];
    NSInteger leftCapWidth = image.size.width * 0.4;
    NSInteger topCapHeight = image.size.height * 0.5;
    UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    
    UIImageView *textBackImageView = [[UIImageView alloc] initWithImage:newImage];
    textBackImageView.userInteractionEnabled = YES;
    [self.view addSubview:textBackImageView];
    
    [textBackImageView addSubview:self.textView];
    [self.view addSubview:self.commitBtn];
    
    MJWeakSelf
    [linView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(12);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(16);
    }];
    
    [tsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(linView.mas_centerY);
        make.left.equalTo(linView.mas_right).offset(6);
    }];
    
    [textBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(linView.mas_bottom).offset(8);
        make.right.equalTo(weakSelf.view.mas_right).offset(-12);
        make.left.equalTo(weakSelf.view.mas_left).offset(12);
        make.height.mas_equalTo(200);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(textBackImageView.mas_right).offset(-1);
        make.left.equalTo(textBackImageView.mas_left).offset(1);
        make.top.equalTo(textBackImageView.mas_top).offset(10);
        make.bottom.equalTo(textBackImageView.mas_bottom).offset(-1);
    }];
    
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.view.mas_left).offset(12);
        make.right.equalTo(weakSelf.view.mas_right).offset(-12);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-100);
    }];
}
//视图将要出现
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"意见反馈";
    self.view.backgroundColor = RGB(245,245,245);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createViews];
    
}
#pragma mark --- 点击事件
- (void)commitBtnEvent:(UIButton *)buttn {
    
    
    if (self.textView.text.length == 0)
    {
        hudShowError(@"请填写意见反馈信息");
        return ;
    }
    [self.params setValue:self.textView.text forKey:@"info"];
    MJWeakSelf
    [[ZKPostHttp shareInstance] POST:@"" params:self.params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"errcode"] isEqual:@"00000"]) {
            hudShowSuccess(responseObject[@"errmsg"]);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            hudShowError(responseObject[@"errmsg"]);
        }
    } failure:^(NSError * _Nonnull error) {
        hudShowError(@"意见反馈提交失败");
    }];
    
}

#pragma mark --- 回收键盘

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
