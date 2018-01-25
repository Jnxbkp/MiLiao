//
//  CountDownView.m
//  MiLiao
//
//  Created by King on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "CountDownView.h"


@interface CountDownView ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, strong) dispatch_source_t timer;
@end

static NSInteger CountDownTime = 2 * 60;


@implementation CountDownView
//充值点击
- (IBAction)payButtonClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(payAction)]) {
        [self.delegate payAction];
    }
    
}

+ (instancetype)CountDownView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.frame = CGRectMake(0, 0, 120, 40);
    self.label.text = [self showTime:CountDownTime];
}


- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self reset];
}


//返回剩余时间数
- (NSString *)showTime:(NSInteger)time {
    NSInteger minu = time / 60;
    NSInteger second = time % 60;
    NSString *string = [NSString stringWithFormat:@"%ld:%02ld", minu, second];
    return string;
}

///重置
- (void)reset {
    CountDownTime = 2 * 60;
    if (self.timer) dispatch_cancel(self.timer);
    self.label.text = [self showTime:CountDownTime];
}

///开始倒计时
- (void)startCountDowun {
    
    self.hidden = NO;
    
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        CountDownTime--;
        if ([self.delegate respondsToSelector:@selector(countDownSeconds:)]) {
            [self.delegate countDownSeconds:CountDownTime];
        }
        if (CountDownTime <= 0) {
            dispatch_cancel(self.timer);
            //通话结束
            if ([self.delegate respondsToSelector:@selector(countDownEnd)]) {
                [self.delegate countDownEnd];
            }
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.label.text = [self showTime:CountDownTime];
            });
            
        }
    });
    dispatch_resume(self.timer);
}

@end
