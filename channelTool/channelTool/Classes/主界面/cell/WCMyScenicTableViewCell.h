//
//  WCMyScenicTableViewCell.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/5.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCMyScenicMode;


extern NSString *const WCMyScenicTableViewCellID;

@interface WCMyScenicTableViewCell : UITableViewCell
// 更新cell数据
- (void)updataCellData:(WCMyScenicMode *)mode;

@end
