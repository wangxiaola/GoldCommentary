//
//  WCCreateScenicTableViewCell.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/15.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 景区cell样式

 - ScenicCellStyleScenicName: 景区名称
 - ScenicCellStyleLevel: 景区等级
 - ScenicCellStyleAdderss: 景区地址
 - ScenicCellStyleTime: 开发时间
 - ScenicCellStyleTickets: 门票
 - ScenicCellStyleInfo: 简介
 - ScenicCellStyleTimeLength: 游览时长
 - ScenicCellStyleHeadName: 负责人姓名
 - ScenicCellStyleHeadPhone: 负责人电话
 */
typedef NS_ENUM(NSInteger, ScenicCellStyle) {
    
    ScenicCellStyleScenicName = 0,
    ScenicCellStyleLevel         ,
    ScenicCellStyleAdderss       ,
    ScenicCellStyleTime          ,
    ScenicCellStyleTickets       ,
    ScenicCellStyleInfo          ,
    ScenicCellStyleTimeLength    ,
    ScenicCellStyleHeadName      ,
    ScenicCellStyleHeadPhone
    
    
};

@interface WCCreateScenicTableViewCell : UITableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellStyle:(ScenicCellStyle)cellStyle;

@end
