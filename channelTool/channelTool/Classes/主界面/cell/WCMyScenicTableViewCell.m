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
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
// 更新cell数据
- (void)updataCellData:(WCMyScenicMode *)mode;
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
