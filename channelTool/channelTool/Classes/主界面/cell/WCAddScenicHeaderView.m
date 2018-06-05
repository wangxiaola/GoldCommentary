//
//  WCAddScenicHeaderView.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/17.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCAddScenicHeaderView.h"
#import "WCAddScenicMode.h"
#import "UIView+MJAlertView.h"

NSString *const WCAddScenicHeaderViewID = @"WCAddScenicHeaderViewID";

@implementation WCAddScenicHeaderView
{
    
    __weak IBOutlet UITextField *scenicNameField;
    __weak IBOutlet UILabel *siteNumberLabel;
    __weak IBOutlet UITextField *siteNameField;
    __weak IBOutlet UILabel *scenicNumberLabel;
    
    NSInteger indexSection;
}

- (void)updateHaaderViewData:(WCAddScenicMode *)mode indexSection:(NSInteger)section;
{
    indexSection = section;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    NSString *number = [formatter stringFromNumber:[NSNumber numberWithInteger:section+1]];// 第一

    siteNumberLabel.text = [NSString stringWithFormat:@"第%@站：",number];
    
    NSString *nameP = (section == 1?@"描述一下旅游出发点，如：请从游客中心出发参观":[NSString stringWithFormat:@"若有第%@站，请叙述一下到下一个站点的路程、方向",number]);
    NSString *siteP = (section == 1?[NSString stringWithFormat:@"第%@个游览站点，如片区名、展览馆、景区名",number]:[NSString stringWithFormat:@"若有第%@站请填写站点名",number]);
    scenicNameField.placeholder = nameP;
    siteNameField.placeholder = siteP;
    
        
    scenicNameField.text = mode.info? :@"";
    siteNameField.text = mode.name? :@"";
    scenicNumberLabel.text = mode.total == 0 ?@"":[NSString stringWithFormat:@"(共有%ld个景点)",mode.total];
    
}
#pragma mark  ----UITextFieldDelegate----
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//
//    if ([string isEqualToString:@"\n"])
//    { //按下return
//        [textField resignFirstResponder];
//        return YES;
//    }
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//
//    if (toBeString.length > 20) {
//        [textField resignFirstResponder];
//        textField.text = [toBeString substringToIndex:20];
//
//        [UIView addMJNotifierWithText:@"字数不能超过20" dismissAutomatically:YES];
//        return NO;
//    }
//
//    return YES;
//}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if (self.editEnd) {
        self.editEnd(scenicNameField.text, siteNameField.text, indexSection);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    scenicNameField.delegate = self;
    siteNameField.delegate = self;
}

@end
