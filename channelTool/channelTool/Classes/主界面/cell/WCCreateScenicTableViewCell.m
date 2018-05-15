//
//  WCCreateScenicTableViewCell.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/15.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCCreateScenicTableViewCell.h"
#import "WCPublic.h"
@implementation WCCreateScenicTableViewCell

{
    ScenicCellStyle _cellStyle;
    UIView *_baseView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellStyle:(ScenicCellStyle)cellStyle;
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _cellStyle = cellStyle;
        
        _baseView = [[UIView alloc] init];
        _baseView.layer.cornerRadius = 6;
        _baseView.backgroundColor = RGB(237, 241, 248);
        [self.contentView addSubview:_baseView];;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textColor = [UIColor blackColor];
        [_baseView addSubview:nameLabel];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
