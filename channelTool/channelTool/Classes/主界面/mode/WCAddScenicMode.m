//
//  WCAddScenicMode.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/17.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCAddScenicMode.h"

@implementation WCAddScenicMode
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"shopspot" : [WCAddScenicImageMode class]};
}
- (NSMutableArray<WCAddScenicImageMode *> *)shopspot
{
    if (!_shopspot) {
        _shopspot = [NSMutableArray arrayWithCapacity:1];
    }
    return _shopspot;
}
@end

@implementation WCAddScenicImageMode
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end
