//
//  WCUploadPromptView.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/9.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCUploadPromptView.h"
#import <Masonry/Masonry.h>

@implementation WCUploadPromptView

/**
 弹出提示框
 
 @param msg 提示信息
 @param successful 是否成功
 @param clickEnd 点击按钮
 */
+ (void)showPromptString:(NSString *)msg isSuccessful:(BOOL)successful clickButton:(void(^)(void))clickEnd;
{
    WCUploadPromptView *promptView = [[WCUploadPromptView alloc] init];
    promptView.frame = [UIApplication sharedApplication].delegate.window.bounds;
    promptView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [[[UIApplication sharedApplication].delegate window] addSubview:promptView];
    
    if (!msg) {
        msg = @"数据异常";
    }
    promptView.clickEnd = clickEnd;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 6;
    [promptView addSubview:contentView];
//    updata_successful
//    updata_error
    UIImageView *promptImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:successful?@"updata_successful":@"updata_error"]];
    [contentView addSubview:promptImageView];
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.textColor = [UIColor grayColor];
    promptLabel.numberOfLines = 0;
    promptLabel.text = msg;
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:promptLabel];
    // 修改行间距
    [promptView changeLineSpaceForLabel:promptLabel WithSpace:6];

    UIButton *hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hideButton setTitle:@"知 道 了" forState:(UIControlStateNormal)];
    hideButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [hideButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [hideButton addTarget:promptView action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    hideButton.layer.cornerRadius = 4;
    hideButton.backgroundColor = [UIColor colorWithRed:247/255.0 green:160/255.0 blue:44/255.0 alpha:1];
    [contentView addSubview:hideButton];
    
    CGFloat windowWidth = CGRectGetWidth(promptView.frame)*0.7;
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(promptView);
        make.width.mas_equalTo(windowWidth);
    }];
    
    [promptImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_centerX);
        make.top.equalTo(contentView.mas_top).offset(20);
    }];
    
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(24);
        make.right.equalTo(contentView.mas_right).offset(-24);
        make.top.equalTo(promptImageView.mas_bottom).offset(20);
    }];
    
    [hideButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(20);
        make.right.equalTo(contentView.mas_right).offset(-20);
        make.top.equalTo(promptLabel.mas_bottom).offset(20);
        make.height.equalTo(@38);
        make.bottom.equalTo(contentView.mas_bottom).offset(-20);
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

- (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space
{
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}
-(void)hideView{
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        if (self.clickEnd) {
            self.clickEnd();
        }
        [self removeFromSuperview];
    }];
}
@end
