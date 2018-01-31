//
//  PlayCollectionViewCell.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/29.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "PlayCollectionViewCell.h"

@implementation PlayCollectionViewCell

//- (UIView *)playerView{
//    if(!_playerView){
//        _playerView = [[UIView alloc] init];
//    }
//    return _playerView;
//}

-(AliyunVodPlayer *)aliPlayer{
    if (!_aliPlayer) {
        _aliPlayer = [[AliyunVodPlayer alloc] init];
    }
    return _aliPlayer;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isStart = NO;
//        self.playerView = [[UIView alloc]init];
//        self.playerView.frame= CGRectMake(0, 0, WIDTH, HEIGHT);
//        self.playerView.backgroundColor = [UIColor blackColor];
//        [self.contentView addSubview:self.playerView];
        self.playerView = [[UIView alloc] init];
        self.playerView = self.aliPlayer.playerView;
        [self.contentView addSubview:self.playerView];
        self.playerView.frame= CGRectMake(0, 0, WIDTH, HEIGHT);
        [self.aliPlayer setAutoPlay:YES];
        
        [self creat];
    }
    return self;
}
- (void)creat {
    _headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _headButton.frame = CGRectMake(WIDTH-54, (HEIGHT-50)/2, 42, 50);
    _headButton.imageEdgeInsets =UIEdgeInsetsMake(0, 0, 8, 0);
    _headButton.imageView.layer.masksToBounds = YES;
    _headButton.imageView.layer.cornerRadius = 21.0;
    [_headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _guanZhuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _guanZhuButton.frame = CGRectMake(_headButton.frame.origin.x+15, _headButton.frame.origin.y+38, 12, 12);
    [_guanZhuButton setImage:[UIImage imageNamed:@"icon_guanZhu"] forState:UIControlStateNormal];
    
    [_guanZhuButton addTarget:self action:@selector(guanZhu:) forControlEvents:UIControlEventTouchUpInside];
    
    _guanLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-66, _headButton.frame.origin.y+55, 66, 12)];
    _guanLabel.font = [UIFont systemFontOfSize:12.0];
    _guanLabel.textAlignment = NSTextAlignmentCenter;
    _guanLabel.textColor = Color255;
    
    _zanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _zanButton.frame = CGRectMake(WIDTH-54, _guanLabel.frame.origin.y+32, 42, 55);
    _zanButton.imageEdgeInsets = UIEdgeInsetsMake(0, 2, 22, 2);
    [_zanButton setImage:[UIImage imageNamed:@"noxihuan_video"] forState:UIControlStateNormal];
    [_zanButton addTarget:self action:@selector(zanButSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    _zanLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-66, _zanButton.frame.origin.y+43, 66, 12)];
    _zanLabel.font = [UIFont systemFontOfSize:12.0];
    _zanLabel.textAlignment = NSTextAlignmentCenter;
    _zanLabel.textColor = Color255;
    
    
    _seeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _seeButton.frame = CGRectMake(WIDTH-54, _zanButton.frame.origin.y+75, 42, 47);
    _seeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 1, 22, 1);
     [_seeButton setImage:[UIImage imageNamed:@"guankan_video"] forState:UIControlStateNormal];
   
    _seeLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-66, _seeButton.frame.origin.y+35, 66, 12)];
    _seeLabel.font = [UIFont systemFontOfSize:12.0];
    _seeLabel.textAlignment = NSTextAlignmentCenter;
    _seeLabel.textColor = Color255;
    
    _videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _videoButton.backgroundColor = NavColor;
    _videoButton.layer.cornerRadius = 5.0;
    _videoButton.frame = CGRectMake(WIDTH-120, _seeButton.frame.origin.y+77, 108, 30);
    [_videoButton setImage:[UIImage imageNamed:@"shipin_video"] forState:UIControlStateNormal];
    [_videoButton setTitle:@"与我视频" forState:UIControlStateNormal];
    _videoButton.imageEdgeInsets = UIEdgeInsetsMake(6, 12, 6, 72);
    _videoButton.titleEdgeInsets = UIEdgeInsetsMake(9, 12, 9, 0);
    _videoButton.tintColor = Color255;
    _videoButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_videoButton addTarget:self action:@selector(videoButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, HEIGHT-65, WIDTH-24, 15)];
    _nameLabel.font = [UIFont systemFontOfSize:15.0];
    _nameLabel.textColor = Color255;
    
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, _nameLabel.frame.origin.y+31, WIDTH-24, 12)];
    _messageLabel.font = [UIFont systemFontOfSize:12.0];
    _messageLabel.textColor = Color255;
    
    if (UI_IS_IPHONEX) {
        _nameLabel.frame = CGRectMake(12, HEIGHT-65-44, WIDTH-24, 15);
        _messageLabel.frame = CGRectMake(12, _nameLabel.frame.origin.y+31, WIDTH-24, 12);
        
    }
    [self.contentView addSubview:_headButton];
    [self.contentView addSubview:_guanZhuButton];
    [self.contentView addSubview:_guanLabel];
    [self.contentView addSubview:_zanButton];
    [self.contentView addSubview:_seeButton];
    [self.contentView addSubview:_videoButton];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_messageLabel];
    [self.contentView addSubview:_zanLabel];
    [self.contentView addSubview:_seeLabel];
    
}
- (void)setVideoModel:(DisVideoModel *)videoModel {
    _videoModel = videoModel;
    [_headButton sd_setImageWithURL:[NSURL URLWithString:videoModel.headUrl] forState:UIControlStateNormal];
    if ([videoModel.zanStatus isEqualToString:@"1"]) {
        [_zanButton setImage:[UIImage imageNamed:@"xihuan_video"] forState:UIControlStateNormal];
        _zanButton.selected = YES;
    } else {
         [_zanButton setImage:[UIImage imageNamed:@"noxihuan_video"] forState:UIControlStateNormal];
        _zanButton.selected = NO;
    }
    
    _guanLabel.text = videoModel.fansNum;
    _zanLabel.text = videoModel.videoUp;
    _seeLabel.text = videoModel.videoCount;
    _nameLabel.text = videoModel.nickName;
    _messageLabel.text = videoModel.videoName;
}

- (void)setIsGuanZhu:(NSString *)isGuanZhu {
    _isGuanZhu = isGuanZhu;
    NSLog(@"---------------><<>><><><%@",_isGuanZhu);
    if ([_isGuanZhu isEqualToString:@"1"]) {
        _guanZhuButton.hidden = YES;
    } else {
        _guanZhuButton.hidden = NO;
    }
}

- (void)headButtonClick:(UIButton *)button {
    [self.delegate headButtonSelect:button];
}
- (void)guanZhu:(UIButton *)button {
    [self.delegate guanZhuButtonSelect:button];
}
- (void)zanButSelect:(UIButton *)button {
    [self.delegate zanButtonSelect:button];
}

- (void)videoButton:(UIButton *)button {
    [self.delegate videoButtonSelect:button];
}

- (void)prepare:(NSString *)urlStr{
    [self.aliPlayer prepareWithURL:[NSURL URLWithString:urlStr]];
    //    [self.aliPlayer prepareWithURL:[NSURL URLWithString:@"http://cloud.video.taobao.com/play/u/2712925557/p/1/e/6/t/1/40050769.mp4"]];
}
- (void)prepareSts:(DisbaseModel *)videoModel videoId:(NSString *)videoId {
    
    NSLog(@"--------%@--------%@",videoId,videoModel.AccessKeyId);
    [self.aliPlayer prepareWithVid:videoId accessKeyId:videoModel.AccessKeyId accessKeySecret:videoModel.AccessKeySecret securityToken:videoModel.SecurityToken];
}
- (void)startPlay{
    [self.aliPlayer start];
    self.isStart = YES;
}

- (void)pausePlay{
    [self.aliPlayer pause];
}

- (void)resumePlay{
    [self.aliPlayer resume];
}

- (void)stopPlay{
    [self.aliPlayer stop];
}

- (void)releasePlayer{
    [self.aliPlayer releasePlayer];
    self.isStart = NO;
}
@end
