//
//  ToolObject.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/17.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "ToolObject.h"

@implementation ToolObject

+ (UIColor *)getColorStr:(NSString *)colorStr {
    UIColor *color;
    if ([colorStr isKindOfClass:[NSString class]]&&colorStr.length > 0) {
        if ([colorStr rangeOfString:@"#"].location == NSNotFound) {
            color = [UIColor colorWithHexString:colorStr];
        } else {
            color = [UIColor colorWithHexString:[colorStr  substringFromIndex:1]];
        }
    }
    return color;
}

+ (void)showOkAlertMessageString:(NSString *)messgeStr withViewController:(UIViewController *)viewController {
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:messgeStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertCon addAction:okAction];
    [viewController presentViewController:alertCon animated:YES completion:nil];
}

+ (NSString *)timeBeforeInfoWithString:(NSTimeInterval)timeIntrval {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //获取此时时间戳长度
    NSTimeInterval nowTimeinterval = [[NSDate date] timeIntervalSince1970];
    int timeInt = nowTimeinterval - timeIntrval; //时间差
//    NSLog(@"--------------%f-----%f-----%d",nowTimeinterval,timeIntrval,timeInt);
    4744150394017690935;
    4789036155158986752;
    int year = timeInt / (3600 * 24 * 30 *12);
    int month = timeInt / (3600 * 24 * 30);
    int day = timeInt / (3600 * 24);
    int hour = timeInt / 3600;
    int minute = timeInt / 60;
    int second = timeInt;
    if (year > 0) {
        return [NSString stringWithFormat:@"%d年以前",year];
    }else if(month > 0){
        return [NSString stringWithFormat:@"%d个月以前",month];
    }else if(day > 0){
        return [NSString stringWithFormat:@"%d天以前",day];
    }else if(hour > 0){
        return [NSString stringWithFormat:@"%d小时以前",hour];
    }else if(minute > 0){
        return [NSString stringWithFormat:@"%d分钟以前",minute];
    }else{
        return [NSString stringWithFormat:@"刚刚"];
    }
}
@end
