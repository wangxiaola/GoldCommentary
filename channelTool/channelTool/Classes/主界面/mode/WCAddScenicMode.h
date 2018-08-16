//
//  WCAddScenicMode.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/17.
//  Copyright © 2018年 王小腊. All rights reserved.
//
/*
 addtime = "<null>";
 allimg = "<null>";
 basicVoc = "<null>";
 hotLevel = 1;
 id = 7;
 info = 4574242;
 label = "<null>";
 name = "\U666f\U533a\U666f\U70b91";
 ontime = "<null>";
 pname = 6;
 routetime = 1;
 scort = "6,7";
 sort = 1;
 source = "<null>";
 state = 1;

 */
#import <Foundation/Foundation.h>
@class WCAddScenicImageMode;

@interface WCAddScenicMode : NSObject

@property (nonatomic, strong) NSMutableArray <WCAddScenicImageMode *>*shopspot;

@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *allimg;
@property (nonatomic, copy) NSString *basicVoc;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ontime;
@property (nonatomic, copy) NSString *pname;
@property (nonatomic, copy) NSString *routetime;
@property (nonatomic, copy) NSString *scort;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, assign) NSInteger total;
@end

@interface WCAddScenicImageMode : NSObject

@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *allimg;
@property (nonatomic, copy) NSString *basicVoc;
@property (nonatomic, copy) NSString *hotLevel;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ontime;
@property (nonatomic, copy) NSString *pname;
@property (nonatomic, copy) NSString *routetime;
@property (nonatomic, copy) NSString *scort;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *psort;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *scenicID;// 景区id
@property (nonatomic, assign) NSInteger rows;// 第几个景点
@property (nonatomic, copy) NSString *scenicInfo;// 景区介绍
@end

