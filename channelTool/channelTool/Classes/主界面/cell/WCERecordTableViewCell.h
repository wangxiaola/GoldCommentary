//
//  WCERecordTableViewCell.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/9.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCERecordMode.h"

extern NSString *const WCERecordTableViewCellID;

@interface WCERecordTableViewCell : UITableViewCell

- (void)updataCellMode:(WCERecordMode *)mode;

@end
