//
//  UZNavgationBackButton.m
//  fangchan
//
//  Created by cuibin on 16/3/28.
//  Copyright © 2016年 youzai. All rights reserved.
//

#import "YZNavgationBackButton.h"
//#import "YZPaySuccessTableViewController.h"
//#import "OrderJudgeViewController.h"

@interface YZNavgationBackButton()

@property (nonatomic, weak)UIViewController *viewController;

@end

@implementation YZNavgationBackButton
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
        self.frame = CGRectMake(0, 0, 44, 44);
        [self addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
+ (instancetype)backBtn{
    YZNavgationBackButton * btn = [[self alloc] init];
    [btn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 44, 44);
    return btn;
}
+ (instancetype)backBtnWithViewController:(UIViewController *)viewController {
    YZNavgationBackButton *btn = [[self alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btn.viewController = viewController;
    return btn;
}

- (void)backAction:(UIButton *)btn {
    if (self.viewController == nil) {
        return;
    }
    UINavigationController *nav = self.viewController.navigationController;
    
    if (nav) {
        if (nav.viewControllers.count > 1) {
            [nav popViewControllerAnimated:YES];
        }else {
            [self.viewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
}

@end
