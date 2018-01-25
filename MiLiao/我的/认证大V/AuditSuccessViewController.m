//
//  AuditSuccessViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "AuditSuccessViewController.h"
#import "SettingTableViewController.h"
@interface AuditSuccessViewController ()
{
    NSUserDefaults *_userDefaults;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@end

@implementation AuditSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    if (UI_IS_IPHONEX) {
        self.bgView.image = [UIImage imageNamed:@"画板 1 拷贝 2"];
    }
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"审核成功"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
}
- (IBAction)success:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
    SettingTableViewController *set = [story instantiateViewControllerWithIdentifier:@"SettingTableViewController"];
//    YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:set];

    [self.navigationController pushViewController:set animated:YES];
    
    
//    [self presentViewController:set animated:NO completion:^{
////
////
////
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
