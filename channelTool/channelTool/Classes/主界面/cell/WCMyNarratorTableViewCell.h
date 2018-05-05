//
//  WCMyNarratorTableViewCell.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/5.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCMyNarratorMode;

extern NSString *const WCMyNarratorTableViewCellID;

@interface WCMyNarratorTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^updataCell)(NSInteger section);

// 更新cell数据
- (void)updataCellData:(WCMyNarratorMode *)mode;

@end
