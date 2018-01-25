//
//  NSString+CYValidation.m
//  ChuanYinProject
//
//  Created by 腾云 on 15-1-12.
//  Copyright (c) 2015年 Zhai Qingchao. All rights reserved.
//

#import "NSString+CYValidation.h"

@implementation NSString (CYValidation)
/*邮箱验证*/
-(BOOL)isValidateEmail
{
    NSString *emailRegex = @"^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPredicate evaluateWithObject:self];
}

//手机号码验证
-(BOOL) isValidateMobile
{
    //手机号以13，14, 15, 17, 18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^(\\+\\d+)?1[34578]\\d{9}$";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phonePredicate evaluateWithObject:self];
}

/*密码验证*/
-(BOOL) isValidatePassword
{
    NSString *passwordRegex = @"^[a-zA-Z0-9@#$%^&*()_+]{6,20}$";
    NSPredicate *passwordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passwordPredicate evaluateWithObject:self];
}

/*判断是不是纯数字*/
-(BOOL)isNumText
{
    NSString * regex = @"^[0-9]+$";
    
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
    
}
/*判断是不是数字(包括点不带小数点)*/
-(BOOL)isDistanceNumText
{
    NSString * regex = @"^\\d+\\.?\\d+$|^\\d+$";
    
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}
/**
 判断文件是否存在
 @param _path 文件路径
 @returns 存在返回yes
 */
- (BOOL)fileExistsAtPath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:self];
}

@end
