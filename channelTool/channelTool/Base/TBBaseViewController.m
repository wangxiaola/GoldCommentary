//
//  TBBaseViewController.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/2.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBBaseViewController ()

@end

@implementation TBBaseViewController
- (void)viewWillDisappear:(BOOL)animated;
{
    [super viewWillDisappear:animated];
    [UIView dismissMJNotifier];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;

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
 
 //通过segue判断要跳转到哪个页面
     if ([segue.identifier isEqualToString:@"NewVC"]) {
 
      XXXController * destinaVC = segue.destinationViewController;
     }
 
   [self performSegueWithIdentifier:@"NewVC" sender:nil];
}
*/

@end
