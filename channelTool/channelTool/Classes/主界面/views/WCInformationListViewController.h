//
//  WCInformationListViewController.h
//  channelTool
//
//  Created by 王小腊 on 2018/8/31.
//  Copyright © 2018年 王小腊. All rights reserved.
//


#import "TBBaseClassTableViewController.h"


/**
 列表类型

 - InformationListToiletServicePlace: 服务场所
 - InformationListToilet: 厕所
 */
typedef NS_ENUM(NSInteger, InformationListType) {
    
   
    InformationListToiletServicePlace = 0,
    InformationListToilet
};

/**
 采集信息列表
 */
@interface WCInformationListViewController : TBBaseClassTableViewController

@property (nonatomic) InformationListType listType;

@property (nonatomic, strong) NSString *scenicID;
@end
