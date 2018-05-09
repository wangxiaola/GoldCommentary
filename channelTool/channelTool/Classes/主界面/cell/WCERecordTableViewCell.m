//
//  WCERecordTableViewCell.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/9.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCERecordTableViewCell.h"
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
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
