//
//  AppDelegate.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/3.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "AppDelegate.h"
#import "WCPublic.h"
#import "TBUpdateTooltipView.h"
#import "IQKeyboardManager.h"
#import "WCNetWorkAccessibity.h"
#import <WXApi.h>

@interface AppDelegate ()<WXApiDelegate>

@end
BMKMapManager* _mapManager;
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 设置键盘
    [self initSDK];
    [WCNetWorkAccessibity openNetworkMonitoring];
    // 版本更新
    [self versionInformationQuery];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    // 提取用户信息
    UserInfo *info = [UserInfo account];
    // 判断用户是否登录过
    NSString *boardName = info.phone.length == 0 ?@"login":@"main";
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

    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];

    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_COMMON]) {
        NSLog(@"经纬度类型设置成功");
    } else {
        NSLog(@"经纬度类型设置失败");
    }
    BOOL ret = [_mapManager start:MAP_KEY generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    // 微信注册
    [WXApi registerApp:weixinID enableMTA:NO];
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"进入后台");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"进入前台");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}
#pragma mark  ----WXApiDelegate----
/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 */
- (void) onReq:(BaseReq*)req;

{
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 */
- (void) onResp:(BaseResp*)resp;
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (resp.errCode == WXSuccess)
        {
            [UIView addMJNotifierWithText:@"分享成功" dismissAutomatically:YES];
        }
        else{
            [UIView addMJNotifierWithText:@"分享失败" dismissAutomatically:YES];
        }
        
    }
}
/**
 更新查询
 */
- (void)versionInformationQuery
{
    NSString *appItunesUrlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@",TELECOM_ID];
    NSURL *urlS = [NSURL URLWithString:appItunesUrlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlS cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (data.length > 0) {
            //有返回数据
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:Nil];
            
            NSArray *results = [dic objectForKey:@"results"];

            if (results.count >0)
            {
                //appStore 版本
                NSString *newVersion = [[[dic objectForKey:@"results"] objectAtIndex:0]objectForKey:@"version"];
                NSString *updateContent = [NSString stringWithFormat:@"更新说明: %@",[[[dic objectForKey:@"results"] objectAtIndex:0]objectForKey:@"releaseNotes"]];
                //本地版本
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                
                if (newVersion && ([newVersion compare:currentVersion] == 1))
                {
                    TBUpdateTooltipView *updataView = [[TBUpdateTooltipView alloc] initShowPrompt:updateContent];
                    [updataView show];
                    
                    
                }
            }
            
        }
        
    }];
    
}

@end
