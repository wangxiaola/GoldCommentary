//
//  WCVoiceChoiceMode.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/21.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WCVoiceChoiceMode : NSObject

@property (nonatomic, copy) NSString *songTitle;//标题
@property (nonatomic, copy) NSString *albumTitle;//专辑
@property (nonatomic, copy) NSString *artist;//主唱
@property (nonatomic, strong) NSURL *assetURL;//地址
@property (nonatomic, strong) NSNumber *time;//时间
@property (nonatomic, strong) UIImage*artwork;//封面

@end
