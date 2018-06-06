//
//  WCMyNarratorTableViewCell.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/5.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCMyNarratorTableViewCell.h"
#import "WCMyNarratorMode.h"
#import "WCPublic.h"

NSString *const WCMyNarratorTableViewCellID = @"WCMyNarratorTableViewCellID";
@implementation WCMyNarratorTableViewCell

{
    __weak IBOutlet UIImageView *headerImageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *stateLabel;
    __weak IBOutlet UIView *bottomView;
    __weak IBOutlet UIButton *moreButton;
    __weak IBOutlet NSLayoutConstraint *bottomHeight;
    WCMyNarratorMode *_mode;
    NSMutableArray *titeArray;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    titeArray = [NSMutableArray arrayWithCapacity:1];
}
// 更新cell数据
- (void)updataCellData:(WCMyNarratorMode *)mode;
{
    _mode = mode;
    [titeArray removeAllObjects];
    [ZKUtil downloadImage:headerImageView imageUrl:mode.headimg duImageName:@"header_default"];
    nameLabel.text = mode.name;
    stateLabel.text = [NSString stringWithFormat:@"%@人购买  讲解音频：%@个",mode.buynum,mode.voicenum];
    // 先删除所有的子视图
    [bottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    bottomHeight.constant = mode.isShowAll == YES ?mode.cellHeight:20;
    
    NSString *imageName = _mode.isShowAll?@"select_level_top":@"select_level";
    [moreButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    CGFloat viewWidth = CGRectGetWidth(bottomView.frame);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (mode.forLabels.count == 0) {
       
            for (NSDictionary *dic in mode.label) {
                
                [titeArray addObject:dic[@"name"]];
            }
            mode.forLabels = titeArray.copy;
        
        }
        else
        {
            [titeArray addObjectsFromArray:mode.forLabels];
        }
        
        if (mode.forLabels.count == 0) {
            
            bottomHeight.constant = 0.01;
        }
      

        CGFloat buttonX = 0;
        CGFloat buttonY = 0;
        CGFloat buttonLin = 4;
        // 是否继续创建标签
        BOOL isAddTag = YES;
        UIFont *font = [UIFont systemFontOfSize:12];
        for (int i = 0; i<titeArray.count; i++) {
            
            NSString *str = mode.forLabels[i];
            
            CGFloat strWidth = [ZKUtil contentLabelSize:CGSizeMake(MAXFLOAT, 20) labelFont:font labelText:str].width + 10;
            
            if (buttonX+buttonLin*2+strWidth > viewWidth) {
                
                if (mode.isShowAll == NO) {
                    
                    isAddTag = NO;
                }
                buttonY += 20;
                buttonX = 0;
            }
            
            CGRect rect = CGRectMake(buttonX, buttonY+2, strWidth, 16);
            // 更新x坐标
            buttonX += strWidth + buttonLin*2;
            
            if (isAddTag == YES) {
                [self addLabelText:str labelRect:rect];
            }
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
       
            // 计算标签高度
            mode.cellHeight = buttonY + 20;
            // 如果只有一行就隐藏更多按钮
            moreButton.hidden = mode.cellHeight > 20 ? NO:YES;
        });

    });
    
}
- (void)addLabelText:(NSString *)str labelRect:(CGRect)rect
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        UILabel *label = [[UILabel alloc] initWithFrame:rect];
        label.text = str;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = NAVIGATION_COLOR;
        label.font = [UIFont systemFontOfSize:10];
        label.layer.borderColor = NAVIGATION_COLOR.CGColor;
        label.layer.borderWidth = 0.5;
        label.layer.cornerRadius = 2;
        [bottomView addSubview:label];
    }];
    
}
// 显示更多
- (IBAction)moreClick:(UIButton *)sender {
    
    _mode.isShowAll = !_mode.isShowAll;

    NSString *imageName = _mode.isShowAll?@"select_level_top":@"select_level";
    [moreButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if (self.updataCell) {
        self.updataCell(_mode.section);
    }
}
//- (void)setFrame:(CGRect)frame
//{
//    static CGFloat margin = 10;
//    frame.origin.x = margin;
//    frame.size.width -= 2 * frame.origin.x;
//    [super setFrame:frame];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
