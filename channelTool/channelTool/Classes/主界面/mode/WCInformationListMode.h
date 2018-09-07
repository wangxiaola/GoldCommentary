//
//  WCInformationListMode.h
//  channelTool
//
//  Created by 王小腊 on 2018/8/31.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCInformationListMode : NSObject

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *addtime;
@property (nonatomic, strong) NSString *allimg;
@property (nonatomic, strong) NSString *headimg;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *shopid;// 景区id
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, assign) NSInteger type;// 0服务点 1厕所

@end
