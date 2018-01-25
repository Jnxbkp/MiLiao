//
//  CountDownView.h
//  MiLiao
//
//  Created by King on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol CountDownViewDelegate<NSObject>

@optional
//充值回调
- (void)payAction;

///倒计时结束
- (void)countDownEnd;
///倒计时剩余的秒数
- (void)countDownSeconds:(NSInteger)second;

@end

typedef void(^ButtonClickBlock)(void);



/**
 一对一视频 显示剩余时间的view
 */
@interface CountDownView : UIView

@property (nonatomic, weak) id<CountDownViewDelegate> delegate;

+ (instancetype)CountDownView;

///开始倒计时
- (void)startCountDowun;

///重置
- (void)reset;

@end
