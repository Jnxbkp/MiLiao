//
//  MLTabBarController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2017/12/29.
//  Copyright © 2017年 Jarvan-zhang. All rights reserved.
//

#import "MLTabBarController.h"
#import "MLHomeViewController.h"
#import "MLDiscoverViewController.h"
#import "MeViewController.h"
#import "HLTabBar.h"
#import "ViewController.h"

#import "ChatListController.h"

@interface MLTabBarController ()<UITabBarControllerDelegate>

@end

@implementation MLTabBarController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *isV = @"no";

//    UIView *view = [[UIView alloc]init];
//    view.backgroundColor = [UIColor whiteColor];
//    view.frame = self.tabBar.bounds;
//    [[UITabBar appearance] insertSubview:view atIndex:0];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isBigV = [userDefaults objectForKey:@"isBigV"];
    self.delegate = self;
    
//    if ([isBigV isEqualToString:@"3"]) {
        [self InitMiddleView];
//    } else {
//
//    }
    
    [self addChildViewController:[[MLHomeViewController alloc]init] title:nil imageName:@"tab_main_nomal" navigationIsHidden:@"no"];
    
    NSString *isHidden = [userDefaults objectForKey:@"isHidden"];
    NSLog(@"-------><<<>><<><>-%@",isHidden);
    if ([isHidden isEqualToString:@"yes"]) {
       
    } else {
        [self addChildViewController:[[MLDiscoverViewController alloc]init] title:nil imageName:@"tab_discover_nomal" navigationIsHidden:@"no"];
    }
    
    [self addChildViewController:[[ChatListController alloc] init] title:nil imageName:@"tab_message_nomal" navigationIsHidden:@"no"];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
    MeViewController *meViewController = [story instantiateViewControllerWithIdentifier:@"MeViewController"];
    [self addChildViewController:meViewController title:nil imageName:@"wode" navigationIsHidden:@"yes"];
    
}
- (void)InitMiddleView
{
    HLTabBar *tabBar = [[HLTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
    [tabBar setDidMiddBtn:^{
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ViewController *VC = [story instantiateViewControllerWithIdentifier:@"ViewController"];
        UINavigationController *ANavigationController = [[UINavigationController alloc] initWithRootViewController:VC];
        ANavigationController.navigationBarHidden = YES;
        [self presentViewController:ANavigationController animated:YES completion:nil];

    }];
}
- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title imageName:(NSString *)imageName navigationIsHidden:(NSString *)isHidden {
    
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.image = image;
    
    NSString *selectedImageName = [NSString string];
    if ([imageName isEqualToString:@"tab_main_nomal"]) {
        selectedImageName = @"tab_main";
    } else if ([imageName isEqualToString:@"tab_discover_nomal"]) {
        selectedImageName = @"tab_discover";
    } else if ([imageName isEqualToString:@"tab_message_nomal"]) {
        selectedImageName = @"tab_message";
    } else if ([imageName isEqualToString:@"wode"]) {
        selectedImageName = @"wode2";
    } 
    
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = selectedImage;
    
    
    YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:childController];
    if ([isHidden isEqualToString:@"yes"]) {
        nav.navigationBarHidden = YES;
    }
    [self addChildViewController:nav];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSString *itemSelect = [NSString string];
    if (tabBarController.selectedIndex == 0) {
        itemSelect = @"Home";
    } else if (tabBarController.selectedIndex == 1) {
        itemSelect = @"Shop";
    } else if (tabBarController.selectedIndex == 2) {
        NSLog(@"----------------%@",viewController.view.subviews);
    } else {
        
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
