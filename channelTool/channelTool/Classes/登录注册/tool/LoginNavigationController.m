//
//  LoginViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/3.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "LoginNavigationController.h"
#import "UIButton+ImageTitleStyle.h"
#import "WCPublic.h"
@interface LoginNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation LoginNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;

    
}
+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    
    bar.barStyle = UIBarStyleBlack;
    bar.translucent = YES;
    bar.tintColor = [UIColor whiteColor];
}
#pragma mark  --UIViewController--
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont  boldSystemFontOfSize:16];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        CGSize titleSize = [@"返回" sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:button.titleLabel.font.fontName size:button.titleLabel.font.pointSize]}];
        titleSize.height = 24;
        titleSize.width += 6;
        
        button.frame = CGRectMake(0, 0, titleSize.width, titleSize.height);
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [UIImage imageNamed:@"login_back"];
        [button setImage:image forState:UIControlStateNormal];
        button.frame = (CGRect){CGPointZero, CGSizeMake(image.size.width+titleSize.width, 30)};
        [button setButtonImageTitleStyle:ButtonImageTitleStyleDefault padding:2];

        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];;
    }
    
    [super pushViewController:viewController animated:animated];
}
#pragma mark --UIGestureRecognizer---
// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}
#pragma mark ------
- (void)back
{
    [self popViewControllerAnimated:YES];
}
- (void)handleNavigationTransition:(UIPanGestureRecognizer *)zer
{
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
