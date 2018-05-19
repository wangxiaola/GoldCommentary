//
//  WCWRecordTableViewCell.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/9.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCWRecordTableViewCell.h"
NSString *const WCWRecordTableViewCellID = @"WCWRecordTableViewCellID";
@implementation WCWRecordTableViewCell
{
    __weak IBOutlet UILabel *stateLabel;
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UILabel *amountLabel;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)updataCellMode:(WCWRecordMode *)mode;
{
    
    stateLabel.text = mode.state.integerValue == 1?@"提现成功":@"提现中";
    timeLabel.text = mode.rtime;
    amountLabel.text = [NSString stringWithFormat:@"+%@元",mode.price];;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
