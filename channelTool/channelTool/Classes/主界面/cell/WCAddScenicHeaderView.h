//
//  WCAddScenicHeaderView.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/17.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCAddScenicMode;
extern NSString *const WCAddScenicHeaderViewID;

@interface WCAddScenicHeaderView : UICollectionReusableView<UITextFieldDelegate>

- (void)updateHaaderViewData:(WCAddScenicMode *)mode indexSection:(NSInteger)section;

/**
 编辑结束后的回调
 */
@property (nonatomic, copy) void(^editEnd)(NSString *scenicName, NSString *siteName, NSInteger section);
@end
