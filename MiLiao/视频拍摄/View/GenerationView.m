//
//  GenerationView.m
//  particle
//
//  Created by Meicam on 2017/11/8.
//  Copyright © 2017年 NewAuto video team. All rights reserved.
//

#import "GenerationView.h"
#import "UIView+Frame.h"

@interface GenerationView() {
    float angle;
}

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) UILabel *numLabel;
@property (strong, nonatomic) UIButton *finishBtn;
@property (assign, nonatomic) Boolean isFinish;

@end

@implementation GenerationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self addSubview:view];
        
        [self addSubview:self.imageView];
        [self addSubview:self.tipLabel];
        [self addSubview:self.numLabel];
        [self addSubview:self.finishBtn];
        [self startAnimation];
    }
    return self;
}

-(void)startAnimation {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    self.imageView.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}

-(void)endAnimation {
    if (self.isFinish) {
        self.imageView.transform = CGAffineTransformIdentity;
        return;
    }
    angle += 10;
    [self startAnimation];
}

- (void)setProgress:(NSInteger)progress {
    self.numLabel.text = [NSString stringWithFormat:@"%ld%%",(long)progress];
}

- (void)finish {
    self.tipLabel.text = @"保存成功";
    self.numLabel.text = @"可在相册中进行查看";
    [self.finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    self.imageView.image = [UIImage imageNamed:@"capture_ok"];
    self.isFinish = YES;
}

- (void)fail {
    self.tipLabel.text = @"保存失败";
    self.numLabel.text = @"请检查手机空间后重新尝试";
    [self.finishBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.imageView.image = [UIImage imageNamed:@"u26-1"];
    self.isFinish = YES;
}

- (void)finishBtnClick:(UIButton*)finishBtn{
    if ([self.delegate respondsToSelector:@selector(generationView:finishClick:)]) {
        [self.delegate generationView:self finishClick:self.isFinish];
    }
}

#pragma - mark Getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _imageView.center = CGPointMake(self.frame.size.width/2, 150);
        _imageView.image = [UIImage imageNamed:@"capture_exporting"];
    }
    return _imageView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageView.y+self.imageView.height+20, self.width, 25)];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.text = @"视频正在生成中";
    }
    return _tipLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tipLabel.y+self.tipLabel.height+20, self.width, 25)];
        _numLabel.text = [NSString stringWithFormat:@"%d%%",0];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.textColor = [UIColor whiteColor];
    }
    return  _numLabel;
}

- (UIButton *)finishBtn {
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishBtn.frame = CGRectMake((self.width-90)/2, self.numLabel.y+self.numLabel.height+30, 90, 40);
        [_finishBtn setTitle:@"取消完成 " forState:UIControlStateNormal];
        _finishBtn.backgroundColor = [UIColor blueColor];
        [_finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
