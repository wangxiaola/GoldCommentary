//
//  WCAddScenicCollectionViewCell.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/17.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCAddScenicImageMode;
extern NSString *const WCAddScenicCollectionViewCellID;

@interface WCAddScenicCollectionViewCell : UICollectionViewCell

- (void)updataCellUI:(WCAddScenicImageMode *)mode;

@end
