//
//  EvaluateVideoViewController.h
//  MiLiao
//
//  Created by King on 2018/1/16.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EvaluateTagModel.h"

@interface TagButton: UIButton

@property (nonatomic, strong) EvaluateTagModel *evaluateTag;

@end

///评价成功的block
typedef void(^EvaluateSuccessBlock)(void);


/**
 对当前的一对一视频女主播做出评价
 */
@interface EvaluateVideoViewController : UIViewController

///当前控制器view的父视图
@property (nonatomic, strong) UIView *superview;

///评价传值的字典
@property (nonatomic, strong) NSDictionary *evaluateDict;

///大v的用户名
@property (nonatomic, strong) NSString *anchorName;
///通话id
@property (nonatomic, strong) NSString *callID;

///弹出凭借界面
- (void)showEvaluaateView:(NSDictionary *)dict;


///评价成功的回调
- (void)evaluateSuccess:(EvaluateSuccessBlock)success;

///展示结算成功
- (void)showSetMoneySuccessView:(NSDictionary *)dict;


@end
