//
//  WCAuthenticationPopupsView.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/7.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCAuthenticationPopupsView.h"
#import "WCAttributeTouchLabel.h"
#import "ZKUtil.h"
#import <Masonry/Masonry.h>
@implementation WCAuthenticationPopupsView

+ (void)showPromptPhone;
{
    [WCAuthenticationPopupsView createUIMsgString:@"您好，如果要删除景区，请电话联系我们客服，谢谢。\n客服电话：028-85127080" clickStrig:@"028-85127080" isPhone:YES];
}
+ (void)show;
{
    
    [WCAuthenticationPopupsView createUIMsgString:@"您现在还没通过实名认证，还不能创建景区哦，请点击“我的-实名认证”进行验证吧。" clickStrig:@"我的-实名认证" isPhone:NO];
}
+ (void)createUIMsgString:(NSString *)msg clickStrig:(NSString *)clickStr isPhone:(BOOL)isPhone;
{
    WCAuthenticationPopupsView *view = [[WCAuthenticationPopupsView alloc] init];
    view.frame = [UIApplication sharedApplication].delegate.window.bounds;
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [[[UIApplication sharedApplication].delegate window] addSubview:view];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.layer.cornerRadius = 6;
    contentView.clipsToBounds = YES;
    [view addSubview:contentView];
    
    UIImageView *headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup_ts"]];
    [contentView addSubview:headerView];
    
    UIView *infoView = [[UIView alloc] init];
    infoView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:infoView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancelButton addTarget:view action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:cancelButton];
    
    UILabel *makeLabel = [[UILabel alloc] init];
    makeLabel.textColor = [UIColor colorWithRed:247/255.0 green:160/255.0 blue:44/255.0 alpha:1];
    //适配系统
    if (@available(iOS 9.0, *)) {
        makeLabel.font = [UIFont monospacedDigitSystemFontOfSize:18 weight:0.2];
    } else if (@available(iOS 8.2, *)) {
        makeLabel.font = [UIFont systemFontOfSize:18 weight:0.2];
    }
    [infoView addSubview:makeLabel];
    
    WCAttributeTouchLabel *infoLabel = [[WCAttributeTouchLabel alloc] init];
    [infoView addSubview:infoLabel];

    [infoLabel setContenString:msg clickString:clickStr];
    if (!isPhone) {

        makeLabel.text = @"请进行实名认证";
    }
    else
    {
         makeLabel.text = @"温馨提示";
        
        [infoLabel setEventBlock:^(NSString *string) {
            
            [view hideView];
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",string];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[[UIApplication sharedApplication].delegate window] addSubview:callWebview];
            
        }];
        
    }
   
    CGFloat windowWidth = CGRectGetWidth(view.frame)*0.6;
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(view);
        make.width.mas_equalTo(windowWidth);
    }];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(contentView);
    }];
    
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(contentView);
        make.top.equalTo(headerView.mas_bottom);
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(infoView);
        make.width.height.equalTo(@35);
    }];
    
    [makeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoView.mas_top).offset(50);
        make.centerX.equalTo(infoView.mas_centerX);
    }];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(makeLabel.mas_bottom).offset(25);
        make.left.equalTo(infoView.mas_left).offset(10);
        make.right.equalTo(infoView.mas_right).offset(-10);
        make.bottom.equalTo(infoView.mas_bottom).offset(-50);
    }];
    
    contentView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            contentView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];
    }];
}
-(void)hideView{
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}
@end
