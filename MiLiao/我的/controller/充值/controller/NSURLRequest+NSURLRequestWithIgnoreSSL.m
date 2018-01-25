//
//  NSURLRequest+NSURLRequestWithIgnoreSSL.m
//  BabyFuture
//
//  Created by MAC on 2018/1/16.
//  Copyright © 2018年 lihuizhong. All rights reserved.
//

#import "NSURLRequest+NSURLRequestWithIgnoreSSL.h"

@implementation NSURLRequest (NSURLRequestWithIgnoreSSL)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end
