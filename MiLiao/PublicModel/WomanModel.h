//
//  WomanModel.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "BaseModel.h"

@interface WomanModel : BaseModel

@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *descriptionStr;
@property (nonatomic, strong) NSString *isAgent;
@property (nonatomic, strong) NSString *isBigv;
@property (nonatomic, strong) NSString *isCommon;
@property (nonatomic, strong) NSString *jtl;

@property (nonatomic, strong) NSString *personalSign;
@property (nonatomic, strong) NSString *province;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *constellation;
@property (nonatomic, strong) NSString *country;

@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic, strong) NSString *height;

@property (nonatomic, strong) NSArray *evaluationList;
@property (nonatomic, strong) NSArray *imageList;
@end
