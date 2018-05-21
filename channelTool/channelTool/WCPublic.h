//
//  JKPublic.h
//  GeekIsland
//
//  Created by 汤亮 on 16/4/27.
//  Copyright © 2016年 LiDinggui. All rights reserved.
//

#ifndef _WCPUBLIC_H_
#define _WCPUBLIC_H_

#import <Foundation/Foundation.h>

#import "ZKUtil.h"
#import "ZKPostHttp.h"
#import "HUD.h"
#import "MJUpdateUI.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "UserInfo.h"
#import "NSDictionary+FixedParams.h"
#import "UIView+MJAlertView.h"

FOUNDATION_EXPORT NSString *const POST_URL;
FOUNDATION_EXPORT NSString *const POST_IMAGE_URL;
//FOUNDATION_EXPORT NSString *const IMAGE_URL;

FOUNDATION_EXPORT NSString *const Verification_code;// 验证码保存
FOUNDATION_EXPORT NSString *const Verification_phone;// 验证手机号保存

FOUNDATION_EXPORT NSString *const MAP_KEY;

/**
 *  微信
 *
 */
#define weixinID @"wx071c2201ad28845c"
#define weixinSecret @"e96c5edc5384dba650fd0378411f104a"



#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define iOS11_0Later ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)

#define NAVIGATION_COLOR [UIColor colorWithRed:247/255.0 green:160/255.0 blue:44/255.0 alpha:1]
#define BODER_COLOR [UIColor colorWithRed:223/255.0 green:224/255.0 blue:225/255.0 alpha:1]
// 列表浅灰色背景
#define BACKLIST_COLOR RGB(245, 245, 245)

// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue,alphaValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:(float)(alphaValue)]

// 循环引用
#define MDStrongify(object) __strong typeof(object) object = weak##object;
/**
 弱引用
 */
#define TBWeakSelf __weak typeof(self) weakSelf = self;

/**
 *  沙盒Cache路径
 */
#define kCachePath ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject])

#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]


// 找widow
#define APPDELEGATE     [[UIApplication sharedApplication] delegate]
// 屏幕
#define _SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define _SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define GET_SCREEN_SCALE(scale) CGFloat scale = _SCREEN_WIDTH /375.0f;

#ifdef DEBUG

#define MMLog( s, ... ) NSLog( @"< %@ > ( 第%d行 ) %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else

#define MMLog( s, ... )

#endif

#endif
