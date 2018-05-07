//
//  AppDelegate.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/3.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "AppDelegate.h"
#import "UserInfo.h"
#import "IQKeyboardManager.h"
#import "HUD.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 设置键盘
    [self initSDK];
    // 提取用户信息
    UserInfo *info = [UserInfo account];
    // 判断用户是否登录过
    NSString *boardName = info.phone.length != 0 ?@"login":@"main";
    // 选择加载storboard
    UIStoryboard *board = [UIStoryboard storyboardWithName:boardName bundle:nil];
    
    UIViewController *viewController = [board instantiateInitialViewController];
    
    @try {
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = viewController;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
    } @catch (NSException *exception) {
        
        NSLog(@"控制器创建失败。。。");
        exit(0);
    }
    
    return YES;
}

-(void)initSDK
{
    // 设置键盘监听管理
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    [keyboardManager setEnable:YES];
    [keyboardManager setKeyboardDistanceFromTextField:0];
    [keyboardManager setEnableAutoToolbar:YES];
    [keyboardManager setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    [keyboardManager setPlaceholderFont:[UIFont systemFontOfSize:14]];
    [keyboardManager setShouldResignOnTouchOutside:YES];
    [keyboardManager setToolbarTintColor:[UIColor colorWithRed:247/255.0 green:160/255.0 blue:44/255.0 alpha:1]];
    //设置为文字
    [keyboardManager setToolbarDoneBarButtonItemText:@"完成"];
    // 设置hud
    hudConfig();

}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
