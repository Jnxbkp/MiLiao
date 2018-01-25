//
//  AuditFailureViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "AuditFailureViewController.h"
#import "IdentificationVController.h"
@interface AuditFailureViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@end

@implementation AuditFailureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (UI_IS_IPHONEX) {
        self.bgView.image = [UIImage imageNamed:@"画板 1 拷贝"];
    }
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"审核失败"];
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
- (IBAction)failure:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
    IdentificationVController *set = [story instantiateViewControllerWithIdentifier:@"IdentificationVController"];
    [self.navigationController pushViewController:set animated:YES];
}

@end
