//
//  WCMyScenicTableViewCell.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/5.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCMyScenicTableViewCell.h"
#import "WCMyScenicMode.h"

NSString *const WCMyScenicTableViewCellID = @"WCMyScenicTableViewCellID";

@implementation WCMyScenicTableViewCell
{
    __weak IBOutlet UIImageView *headerImageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *scenicNumberLabel;
    __weak IBOutlet UILabel *earningsLabel;//收益
    __weak IBOutlet UILabel *audienceNumberLabel;//观众
    __weak IBOutlet UILabel *buyNumberLabel;// 购买状态
    __weak IBOutlet UIButton *bianjiButton;
    __weak IBOutlet UIButton *shareButton;
    __weak IBOutlet NSLayoutConstraint *bottonViewHeight;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    bianjiButton.layer.cornerRadius = 6;
    bianjiButton.layer.borderColor = [UIColor colorWithRed:247/255.0 green:160/255.0 blue:44/255.0 alpha:1].CGColor;
    bianjiButton.layer.borderWidth = 1;
    
    shareButton.layer.cornerRadius = 6;
    shareButton.layer.borderColor = [UIColor colorWithRed:247/255.0 green:160/255.0 blue:44/255.0 alpha:1].CGColor;
    shareButton.layer.borderWidth = 1;
    
    
    
    
}
// 更新cell数据
- (void)updataCellData:(WCMyScenicMode *)mode;
{
    
}
- (IBAction)bianjiButtonClick:(UIButton *)sender {
}
- (IBAction)shareButtonClick:(UIButton *)sender {
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
