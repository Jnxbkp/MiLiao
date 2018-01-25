//
//  InReviewViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "InReviewViewController.h"

@interface InReviewViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@end

@implementation InReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (UI_IS_IPHONEX) {
        self.bgView.image = [UIImage imageNamed:@"画板 1"];
    }
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"审核中"];
    
}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
//}

- (IBAction)go:(id)sender {
//    self.tabBarController.hidesBottomBarWhenPushed=NO;
//    self.tabBarController.selectedIndex=0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KSwitchRootViewControllerNotification" object:nil];

}



@end
