//
//  ZKNavigationController.m
//  guide
//
//  Created by 汤亮 on 15/10/6.
//  Copyright © 2015年 daqsoft. All rights reserved.
//

#import "ZKNavigationController.h"
#import "UIBarButtonItem+Custom.h"
#import "WCPublic.h"

@interface ZKNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation ZKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.enabled = YES;
}
+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBarTintColor:NAVIGATION_COLOR];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    [bar setTitleTextAttributes:attrs];
    [bar setTintColor:NAVIGATION_COLOR];
    bar.barStyle = UIBarStyleBlack;

}
#pragma mark  --UIViewController--
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem setRitWithTitel:@"" itemWithIcon:@"nav_back" target:self action:@selector(back)];
    }

    [super pushViewController:viewController animated:animated];
}

#pragma mark ------
- (void)back
{
    [self popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
