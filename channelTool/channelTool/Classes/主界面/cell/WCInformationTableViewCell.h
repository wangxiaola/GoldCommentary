//
//  WCInformationTableViewCell.h
//  channelTool
//
//  Created by 王小腊 on 2018/8/31.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCInformationListMode;

extern NSString *const WCInformationTableViewCellID;

@interface WCInformationTableViewCell : UITableViewCell
// 更新数据
- (void)updataCellData:(WCInformationListMode *)mode;

/**
 点击删除
 */
@property (nonatomic, copy) void(^deleteInformation)(WCInformationListMode *mode);

@end
