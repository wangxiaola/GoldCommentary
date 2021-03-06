//
//  WCAddScenicCollectionViewCell.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/17.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCAddScenicCollectionViewCell.h"
#import "WCAddScenicMode.h"
#import "ZKUtil.h"
NSString *const WCAddScenicCollectionViewCellID = @"WCAddScenicCollectionViewCellID";

@implementation WCAddScenicCollectionViewCell
{
    
    __weak IBOutlet UIImageView *headerImageView;
    __weak IBOutlet UILabel *scenicNameLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)updataCellUI:(WCAddScenicImageMode *)mode;
{
    if (mode) {
        NSString *url = [mode.allimg componentsSeparatedByString:@","].firstObject;
        [ZKUtil downloadImage:headerImageView imageUrl:url duImageName:@"popup_ts"];
        scenicNameLabel.text = mode.name;
    }
    else
    {
       headerImageView.image = [UIImage imageNamed:@"addScenic"];
       scenicNameLabel.text = @"";
    }
}
@end
