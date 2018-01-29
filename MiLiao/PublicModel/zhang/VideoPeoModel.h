//
//  VideoPeoModel.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/29.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "BaseModel.h"

@interface VideoPeoModel : BaseModel

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *fansNum; //喜欢数
@property (nonatomic, strong) NSString *likeStatus;
@property (nonatomic, strong) NSString *videoCount;//观看数
@property (nonatomic, strong) NSString *videoId;
@property (nonatomic, strong) NSString *videoName;
@property (nonatomic, strong) NSString *videoUp; //赞数量
@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, strong) NSString *zanStatus;
@property (nonatomic, strong) NSString *headUrl;

@end
