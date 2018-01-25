//
//  AppDelegate.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2017/12/29.
//  Copyright © 2017年 Jarvan-zhang. All rights reserved.
//
//
#import <UIKit/UIKit.h>
#import <AFNetworking.h>
//123
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign,nonatomic) BOOL enterBackgroundFlag;

- (AFHTTPSessionManager *)sharedHTTPSession;

@end

