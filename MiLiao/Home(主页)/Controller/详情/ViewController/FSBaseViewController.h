//
//  FSBaseViewController.h
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoUserModel;

@interface FSBaseViewController : UIViewController
@property (nonatomic, strong) VideoUserModel *videoUserModel;
@property (nonatomic,strong)NSString *user_id;

@property (nonatomic, strong)NSString *kind;

@end
