//
//  NSStringSize.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/1.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSStringSize : NSObject

+ (CGSize)getNSStringHeight:(NSString *)str withName:(NSString *)name Font:(float)font;

+ (CGSize)getNSStringHeight:(NSString *)str Font:(float)font;

+ (CGSize)getNSStringHeight:(NSString *)str Font:(float)font maxSize:(CGSize)maxSize;

//详情资料介绍
+ (CGSize)detailString:(NSString *)str;
@end
