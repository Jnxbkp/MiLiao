//
//  EvaluateTagModel.h
//  MiLiao
//
//  Created by King on 2018/1/16.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 一对一视频结束后 获取到的评价标签模型
 */
@interface EvaluateTagModel : NSObject
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *tagColor;
@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, strong) NSString *tagSort;
@property (nonatomic, strong) NSString *tagStatus;
@end
