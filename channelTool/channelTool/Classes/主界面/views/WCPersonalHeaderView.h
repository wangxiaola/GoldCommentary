//
//  WCPersonalHeaderView.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/7.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 header视图样式

 - PersonalHeaderViewStyleDefault: 默认
 - PersonalHeaderViewStyleEditor: 编辑
 */
typedef NS_ENUM(NSInteger, PersonalHeaderViewStyle) {
    PersonalHeaderViewStyleDefault = 0,
    PersonalHeaderViewStyleEditor
    
};
@interface WCPersonalHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *editorButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**
 返回点击
 */
@property (nonatomic, copy) void (^goBack)(void);

/**
 完成按钮点击
 */
@property (nonatomic, copy) void (^complete)(void);

/**
 编辑按钮点击
 */
@property (nonatomic, copy) void (^editor)(void);

/**
 编辑头像
 */
@property (nonatomic, copy) void (^updataHeaderPortrait)(void);


@property (nonatomic) PersonalHeaderViewStyle viewStyle;

+ (WCPersonalHeaderView *)loadNibViewStyle:(PersonalHeaderViewStyle)style;

@end
