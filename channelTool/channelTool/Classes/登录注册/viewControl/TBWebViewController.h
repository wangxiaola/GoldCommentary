//
//  TBWebViewController.h
//  Telecom
//
//  Created by 王小腊 on 2017/1/9.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBWebViewController : TBBaseViewController

@property (strong, nonatomic) NSString *urlString;

/**
 加载纯外部链接网页
 
 @param string URL地址
 */
- (void)loadWebURLSring:(NSString *)string;

/**
 加载本地链接网页
 
 @param string URL地址
 */
- (void)loadWebPathURLSring:(NSString *)string;

@end
