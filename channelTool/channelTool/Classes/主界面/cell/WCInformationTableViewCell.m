//
//  WCInformationTableViewCell.m
//  channelTool
//
//  Created by 王小腊 on 2018/8/31.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCInformationTableViewCell.h"
#import "WCInformationListMode.h"
#import "ZKUtil.h"
NSString *const WCInformationTableViewCellID = @"WCInformationTableViewCellID";

@implementation WCInformationTableViewCell
{
    WCInformationListMode *_data;
    __weak IBOutlet UIImageView *headerImageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *adderssLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
}
- (void)updataCellData:(WCInformationListMode *)mode;
{
    _data = mode;
    
    [ZKUtil downloadImage:headerImageView imageUrl:mode.headimg duImageName:@"popup_ts"];
    nameLabel.text = mode.name;
    adderssLabel.text = mode.address;
}

/**
 点击删除

 @param sender sender
 */
- (IBAction)deleteInformationClick:(UIButton *)sender {
    
    if (self.deleteInformation) {
        self.deleteInformation(_data);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
