//
//  WCRetrieveViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/3.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCRetrieveViewController.h"

@interface WCRetrieveViewController ()

@property (nonatomic, weak) IBOutlet UITextField *phoneField;

@end

@implementation WCRetrieveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark  ----点击事件----
// 下一步
- (IBAction)nextStep:(id)sender {
    [self performSegueWithIdentifier:@"setPassword" sender:nil];
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
