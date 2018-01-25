//
//  NSURLRequest+NSURLRequestWithIgnoreSSL.h
//  BabyFuture
//
//  Created by MAC on 2018/1/16.
//  Copyright © 2018年 lihuizhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (NSURLRequestWithIgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;
@end
