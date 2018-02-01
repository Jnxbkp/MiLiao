//
//  CallUSViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/24.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "CallUSViewController.h"

@interface CallUSViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation CallUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"联系我们"];
    NSString *bigv = [NSString stringWithFormat:@"%@",[YZCurrentUserModel sharedYZCurrentUserModel].isBigv];
    if ([bigv isEqualToString:@"3"]) {
        if (UI_IS_IPHONEX) {
            self.image.image = [UIImage imageNamed:@"网红1125"];
        }else{
            self.image.image = [UIImage imageNamed:@"网红"];

        }
    }else{
        if (UI_IS_IPHONEX) {
            self.image.image = [UIImage imageNamed:@"用户1125"];
        }else{
            self.image.image = [UIImage imageNamed:@"用户"];
    }
   
}
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
