//
//  NSStringSize.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/1.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "NSStringSize.h"

@implementation NSStringSize

+ (CGSize)getNSStringHeight:(NSString *)str withName:(NSString *)name Font:(float)font {
    if ([str isKindOfClass:[NSString class]]&&str.length > 0) {
        CGSize maxSize = CGSizeMake(WIDTH - 30, 8000);
        NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:name size:font]};
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        CGSize labelSzie = [str boundingRectWithSize:maxSize options:options attributes:dic context:nil].size;
        return labelSzie;
    } else {
        return CGSizeMake(0 , 0);
    }
    
}
+ (CGSize)getNSStringHeight:(NSString *)str Font:(float)font {

    if ([str isKindOfClass:[NSString class]]&&str.length > 0) {
        CGSize maxSize = CGSizeMake(WIDTH , 8000);
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        CGSize labelSzie = [str boundingRectWithSize:maxSize options:options attributes:dic context:nil].size;
        return labelSzie;
    } else {
       return CGSizeMake(0 , 0);
    }
    
}
+ (CGSize)getNSStringHeight:(NSString *)str Font:(float)font maxSize:(CGSize)maxSize {
    if ([str isKindOfClass:[NSString class]]&&str.length > 0) {
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize: font]};
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        CGSize labelSzie = [str boundingRectWithSize:maxSize options:options attributes:dic context:nil].size;
        return labelSzie;
    } else {
        return CGSizeMake(0 , 0);
    }
    
}
//详情资料介绍
+ (CGSize)detailString:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]&&str.length > 0) {
        CGSize maxSize = CGSizeMake(WIDTH-40, 1000);
        CGSize labelSzie;
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 4.0f;
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSKernAttributeName:@0.5f,NSParagraphStyleAttributeName:paraStyle};
        labelSzie = [str boundingRectWithSize:maxSize options:options attributes:dic context:nil].size;
        return labelSzie;
    } else {
        return CGSizeMake(0 , 0);
    }
    
}
@end
