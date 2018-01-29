//
//  ToolObject.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/17.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolObject : NSObject

//获取有#号的16进制的颜色
+ (UIColor *)getColorStr:(NSString *)colorStr;

//alert框
+ (void)showOkAlertMessageString:(NSString *)messgeStr withViewController:(UIViewController *)viewController;

//时间戳转化
+ (NSString *)timeBeforeInfoWithString:(NSTimeInterval)timeIntrval;

//传入 秒  得到  xx分钟xx秒
+(NSString *)getMMSSFromSS:(NSString *)totalTime;
@end
