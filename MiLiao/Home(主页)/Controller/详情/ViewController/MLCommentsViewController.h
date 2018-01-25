//
//  testViewController.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/3.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoUserModel;

@interface MLCommentsViewController : UIViewController

@property (nonatomic, assign) BOOL vcCanScroll;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) NSString *str;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) VideoUserModel *videoUserModel;

@end
