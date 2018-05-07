//
//  WCPersonalHeaderView.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/7.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCPersonalHeaderView.h"

@implementation WCPersonalHeaderView

+ (WCPersonalHeaderView *)loadNibViewStyle:(PersonalHeaderViewStyle)style;
{
   WCPersonalHeaderView *view = [[NSBundle mainBundle] loadNibNamed:@"WCPersonalHeaderView" owner:nil options:nil].lastObject;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, width, width*9/16);
    view.backgroundColor = [UIColor whiteColor];
    view.viewStyle = style;
    view.headerImageView.layer.masksToBounds = YES;
    view.headerImageView.layer.cornerRadius = 45;
    
    if (style == PersonalHeaderViewStyleDefault) {
        
        [view.editorButton setImage:[UIImage imageNamed:@"user_ editor"] forState:UIControlStateNormal];
        [view.editorButton setTitle:@"" forState:UIControlStateNormal];
    }
    else if (style == PersonalHeaderViewStyleEditor){
        
        [view.editorButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [view.editorButton setTitle:@"完成" forState:UIControlStateNormal];
        view.nameLabel.text = @"点击修改头像";
        
        view.headerImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(headerClick)];
        [view.headerImageView addGestureRecognizer:ges];
        
    }
    
    
    return view;
}
- (IBAction)backClick:(UIButton *)sender {
    if (self.goBack) {
        self.goBack();
    }
}
- (IBAction)editorClick:(UIButton *)sender {
    
    if (self.viewStyle == PersonalHeaderViewStyleDefault) {
        
        if (self.editor) {
            self.editor();
        }
    }
    else if (self.viewStyle == PersonalHeaderViewStyleEditor)
    {
        if (self.complete) {
            self.complete();
        }
    }
}
- (void)headerClick
{
    if (self.updataHeaderPortrait) {
        self.updataHeaderPortrait();
    }
}
@end
