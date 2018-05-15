//
//  WCUploadPromptView.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/9.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 上传提示视图
 */
@interface WCUploadPromptView : UIView

@property (nonatomic, copy) void(^clickEnd)(void);

/**
 弹出提示框

 @param msg 提示信息
 @param successful 是否成功
 @param clickEnd 点击按钮
 */
+ (void)showPromptString:(NSString *)msg isSuccessful:(BOOL)successful clickButton:(void(^)(void))clickEnd;
- (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

@end
