//
//  WCNetWorkAccessibity.m
//  channelTool
//
//  Created by 王小腊 on 2018/7/27.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCNetWorkAccessibity.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <UIKit/UIKit.h>

@interface WCNetWorkAccessibity()
{
    UIAlertController *_alertController;
}

@property (nonatomic, strong) AFNetworkReachabilityManager *manager;

@end

@implementation WCNetWorkAccessibity

+ (WCNetWorkAccessibity *)sharedInstance {
    static WCNetWorkAccessibity * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

+ (void)openNetworkMonitoring;
{
    [self sharedInstance].manager = [AFNetworkReachabilityManager sharedManager];
    [[self sharedInstance].manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        [[self sharedInstance] hideNetworkRestrictedAlert];

        if ([self sharedInstance].networkReachabilityStatusBlock) {
            
             [self sharedInstance].networkReachabilityStatusBlock((NSInteger)status);
        }
       
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未识别的网络");
                                [[self sharedInstance] showNetworkRestrictedAlert];
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"不可达的网络(未连接)");
                                [[self sharedInstance] showNetworkRestrictedAlert];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"2G,3G,4G...的网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi的网络");
                break;
            default:
                break;
        }
    }];
    [[self sharedInstance].manager startMonitoring];
}
+ (void)startMonitoring;
{
    [[self sharedInstance].manager startMonitoring];
}
+ (void)stopMonitoring;
{    [[self sharedInstance].manager stopMonitoring];
    
}
- (void)showNetworkRestrictedAlert {
    if (self.alertController.presentingViewController == nil && ![self.alertController isBeingPresented]) {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.alertController animated:YES completion:nil];
    }
    
}

- (void)hideNetworkRestrictedAlert {
    
    if (self.alertController.presentingViewController != nil && [self.alertController isBeingPresented]) {
        [_alertController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIAlertController *)alertController {
    if (!_alertController) {
        
        _alertController = [UIAlertController alertControllerWithTitle:@"网络连接失败" message:@"检测到网络权限可能未开启，您可以在“设置”中检查蜂窝移动网络" preferredStyle:UIAlertControllerStyleAlert];
        
        [_alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self hideNetworkRestrictedAlert];
        }]];
        
        [_alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        }]];
    }
    return _alertController;
}
@end
