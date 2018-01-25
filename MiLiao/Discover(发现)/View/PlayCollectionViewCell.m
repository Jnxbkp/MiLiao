//
//  PlayCollectionViewCell.m
//  MiLiao
//
//  Created by King on 2018/1/12.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "PlayCollectionViewCell.h"


/**** View ****/
#import "CommentVideoView.h"//评论view

#import <AliyunVodPlayerSDK/AliyunVodPlayer.h>



@interface PlayCollectionViewCell ()
@property (nonatomic, strong)AliyunVodPlayer *aliPlayer;
@property (nonatomic, strong) UIView *playerView;

@property (weak, nonatomic) IBOutlet UIImageView *loveImageView;

@end



@implementation PlayCollectionViewCell
{
    ButtonClickBlock _buttonClickBlock;
}
#pragma mark - getter
-(AliyunVodPlayer *)aliPlayer{
    if (!_aliPlayer) {
        _aliPlayer = [[AliyunVodPlayer alloc] init];
    }
    return _aliPlayer;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    [self setContentView];
    // Initialization code
}

- (void)prepare {
//    [self.aliPlayer prepareWithURL:[NSURL URLWithString:self.playURLString]];
    
    //测试播放视频连接
    [self.aliPlayer prepareWithURL:[NSURL URLWithString:@"http://cloud.video.taobao.com/play/u/2712925557/p/1/e/6/t/1/40050769.mp4"]];
}

///暂停播放
- (void)pausePlay{
    [self.aliPlayer pause];
}


/*
 功能：获取播放器当前播放状态
 当前播放状态有：
 AliyunVodPlayerStateIdle = 0,           //空转，闲时，静态
 AliyunVodPlayerStateError,              //错误
 AliyunVodPlayerStatePrepared,           //已准备好
 AliyunVodPlayerStatePlay,               //播放
 AliyunVodPlayerStatePause,              //暂停
 AliyunVodPlayerStateStop,               //停止
 AliyunVodPlayerStateFinish,             //播放完成
 AliyunVodPlayerStateLoading             //加载中
 */
- (AliyunVodPlayerState)playerState {
    return [self.aliPlayer playerState];
}

- (void)resumePlay{
    [self.aliPlayer resume];
}


- (void)stopPlay {
    [self.aliPlayer stop];
}


- (void)setContentView{
    self.playerView = [[UIView alloc] init];
    self.playerView = self.aliPlayer.playerView;
    [self.contentView insertSubview:self.playerView atIndex:0];
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
    }];

    [self.aliPlayer setAutoPlay:YES];
    
    
}


#pragma mark - 控件点击方法

//评论按钮点击
- (IBAction)commentButtonClick:(UIButton *)sender {
    CommentVideoView *comentView = [CommentVideoView CommentVideoView];
    [self.contentView addSubview:comentView];
    [UIView animateWithDuration:0.2 animations:^{
        comentView.y = 0;
    }];
    
}

//点赞
- (IBAction)loveAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    [UIView animateWithDuration:0.2 animations:^{
        
        if (sender.isSelected) {
            
             self.loveImageView.image = [UIImage imageNamed:@"xihuan2"];
            
        } else {
            self.loveImageView.image = [UIImage imageNamed:@"xihuan"];
        }
        self.loveImageView.transform = CGAffineTransformMakeScale(2, 2);
        
    } completion:^(BOOL finished) {
        self.loveImageView.transform = CGAffineTransformIdentity;
    }];
   
}




#pragma mark - 回调方法
///点击视频播放界面的按钮回调
- (void)playAction:(ButtonClickBlock)action {
    _buttonClickBlock = action;
}



@end
