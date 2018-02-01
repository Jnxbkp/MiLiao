//
//  UZNavigationController.m
//  fangchan
//
//  Created by cuibin on 16/3/25.
//  Copyright © 2016年 youzai. All rights reserved.
//

#import "YZNavigationController.h"

@interface YZNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation YZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:NavColor size:CGSizeMake(WIDTH, ML_TopHeight)] forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setBackgroundImage:[UIImage imageWithColor:ML_Color(255, 255, 255, 1.0) size:CGSizeMake(WIDTH, ML_TopHeight)] forBarMetrics:UIBarMetricsDefault];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
        //返回按钮
        UIButton*returnBtn = [YZNavgationBackButton backBtnWithViewController:viewController];
        returnBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        viewController.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:returnBtn]];
    }
    [super pushViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    return [super popToViewController:viewController animated:animated];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIViewController* topVC = self.topViewController;
    if ([topVC preferredStatusBarStyle]) {
        return [topVC preferredStatusBarStyle];
    }else{
        return UIStatusBarStyleLightContent;
    }
}
@end
