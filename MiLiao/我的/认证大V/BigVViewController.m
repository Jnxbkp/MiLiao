//
//  BigVViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "BigVViewController.h"

@interface BigVViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@end

@implementation BigVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (UI_IS_IPHONEX) {
        self.bgView.image = [UIImage imageNamed:@"画板 1 拷贝 3"];
    }
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"大咪认证"];
}

- (IBAction)btn:(id)sender {
}


@end
