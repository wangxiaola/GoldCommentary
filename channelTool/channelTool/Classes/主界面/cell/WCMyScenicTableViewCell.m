//
//  WCMyScenicTableViewCell.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/5.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCMyScenicTableViewCell.h"
#import "WCMyScenicMode.h"
#import "WCPublic.h"
NSString *const WCMyScenicTableViewCellID = @"WCMyScenicTableViewCellID";

@implementation WCMyScenicTableViewCell
{
    __weak IBOutlet UIImageView *headerImageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *scenicNumberLabel;
    __weak IBOutlet UILabel *earningsLabel;//收益
    __weak IBOutlet UILabel *audienceNumberLabel;//观众
    __weak IBOutlet UILabel *buyNumberLabel;// 购买状态 0审核中 1成功 2未通过
    __weak IBOutlet UIButton *bianjiButton;
    __weak IBOutlet UIButton *shareButton;
    __weak IBOutlet NSLayoutConstraint *bottonViewHeight;
    
    WCMyScenicMode *_scenicMode;
    
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
    _scenicMode = mode;
    [ZKUtil downloadImage:headerImageView imageUrl:mode.logo duImageName:@"popup_ts"];
    nameLabel.text = mode.name;
    scenicNumberLabel.text = [NSString stringWithFormat:@"景点数：%@个 讲解音频：%@个",mode.scenicnum,mode.voicenum];
    NSString *earnings = [ZKUtil isBlankString:mode.earnings] == NO?mode.earnings:@"0";
    earningsLabel.text = [NSString stringWithFormat:@"收益：￥%@",earnings];
    audienceNumberLabel.text = [NSString stringWithFormat:@"%@",mode.listen];
    
    switch (mode.state.integerValue) {
        case 0://正在审核
            buyNumberLabel.text = @"审核中";
            buyNumberLabel.textColor = [UIColor redColor];
              bottonViewHeight.constant = 0.01f;
            break;
        case 1://审核成功
            if (mode.buynum.integerValue == 0) {
                buyNumberLabel.text = @"创建成功";
                buyNumberLabel.textColor = RGB(83, 130, 0);
            }
            else
            {
                buyNumberLabel.text = [NSString stringWithFormat:@"%@人购买",mode.buynum];
                buyNumberLabel.textColor = RGB(83, 130, 0);
            }
            bottonViewHeight.constant = 40.0f;
            break;
        case 2://审核失败
            buyNumberLabel.text = @"审核失败";
            buyNumberLabel.textColor = [UIColor redColor];
            bottonViewHeight.constant = 0.01f;
            break;
            
        default:
            break;
    }
    [self layoutIfNeeded];
    
}
- (IBAction)bianjiButtonClick:(UIButton *)sender {
    
    if (self.editorSecnicInfo) {
        self.editorSecnicInfo(_scenicMode);
    }
}
- (IBAction)shareButtonClick:(UIButton *)sender {
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
