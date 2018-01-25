//
//  NSString+CYValidation.h
//  ChuanYinProject
//
//  Created by 腾云 on 15-1-12.
//  Copyright (c) 2015年 Zhai Qingchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CYValidation)
/*邮箱验证*/
-(BOOL)isValidateEmail;

/*手机号码验证*/
-(BOOL) isValidateMobile;

/*密码验证*/
-(BOOL) isValidatePassword;

/*判断是不是纯数字*/
-(BOOL)isNumText;

/*判断是不是数字(包括点不带小数点)*/
-(BOOL)isDistanceNumText;
/**
 判断文件是否存在
 @param _path 文件路径
 @returns 存在返回yes
 */
- (BOOL)fileExistsAtPath;

@end
