//
//  DisVideoModel.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/17.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "DisVideoModel.h"

@implementation DisVideoModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        
        self.createDate = [NSString stringWithFormat:@"%@",[dict objectForKey:@"createDate"]];
        self.Id = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        self.remark = [dict objectForKey:@"remark"];
        self.updateDate = [dict objectForKey:@"updateDate"];
        self.userId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]];
        self.videoCount = [NSString stringWithFormat:@"%@",[dict objectForKey:@"videoCount"]];
        self.videoId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"videoId"]];
      
        self.videoName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"videoName"]];
        self.videoStatus = [NSString stringWithFormat:@"%@",[dict objectForKey:@"videoStatus"]];
        self.videoUrl = [NSString stringWithFormat:@"%@",[dict objectForKey:@"videoUrl"]];
        self.headUrl = [NSString stringWithFormat:@"%@",[dict objectForKey:@"headUrl"]];
        self.zanStatus = [NSString stringWithFormat:@"%@",[dict objectForKey:@"zanStatus"]];
        self.videoUp = [NSString stringWithFormat:@"%@",[dict objectForKey:@"videoUp"]];
    }
    return self;
}
@end

@implementation DisVideoModelList

- (instancetype)initWithArray:(NSArray *)array {
    if (self = [super init]) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in array) {
            DisVideoModel *videoModel = [[DisVideoModel alloc] initWithDictionary:dict];
            [list addObject:videoModel];
        }
        self.videoArr = list;
    }
    return self;
}

@end
