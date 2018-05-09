//
//  WCWRecordTableViewCell.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/9.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCWRecordMode.h"
extern NSString *const WCWRecordTableViewCellID;
@interface WCWRecordTableViewCell : UITableViewCell

- (void)updataCellMode:(WCWRecordMode *)mode;
@end
