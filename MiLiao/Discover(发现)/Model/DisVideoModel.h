//
//  DisVideoModel.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/17.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "BaseModel.h"

@interface DisVideoModel : BaseModel

@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *updateDate;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *videoCount;
@property (nonatomic, strong) NSString *videoId;
@property (nonatomic, strong) NSString *videoName;
@property (nonatomic, strong) NSString *videoStatus;
@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic, strong) NSString *zanStatus;
@property (nonatomic, strong) NSString *videoUp;//赞数

@end

@interface DisVideoModelList : NSObject

@property (nonatomic, strong) NSArray *videoArr;

- (instancetype)initWithArray:(NSArray *)array;

@end

