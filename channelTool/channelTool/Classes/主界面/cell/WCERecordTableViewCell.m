//
//  WCERecordTableViewCell.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/9.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCERecordTableViewCell.h"
#import "ZKUtil.h"
NSString *const WCERecordTableViewCellID = @"WCERecordTableViewCellID";
@implementation WCERecordTableViewCell
{
    __weak IBOutlet UIImageView *headerImageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UILabel *amountLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)updataCellMode:(WCERecordMode *)mode;
{
    [ZKUtil downloadImage:headerImageView imageUrl:mode.headimg duImageName:@"header_default"];
    nameLabel.text = mode.username;
    titleLabel.text = mode.name;
    amountLabel.text = [NSString stringWithFormat:@"+%@元",mode.paymoney];
    timeLabel.text = mode.paytime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
