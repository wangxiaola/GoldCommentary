//
//  LoginViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/3.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "LoginNavigationController.h"
#import "UIButton+ImageTitleStyle.h"

@interface LoginNavigationController ()

@end

@implementation LoginNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

}
+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    
    bar.barStyle = UIBarStyleBlack;
    bar.translucent = YES;
    bar.tintColor = [UIColor colorWithRed:247/255.0 green:160/255.0 blue:44/255.0 alpha:1];
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
        UIImage *image = [UIImage imageNamed:@"nav_back"];
        [button setImage:image forState:UIControlStateNormal];
        button.frame = (CGRect){CGPointZero, CGSizeMake(image.size.width+titleSize.width, 30)};
        [button setButtonImageTitleStyle:ButtonImageTitleStyleDefault padding:2];

        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];;
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
