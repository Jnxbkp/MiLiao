//
//  PlayCollectionViewCell.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/29.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AliyunVodPlayerSDK/AliyunVodPlayer.h>

//typedef NS_ENUM(NSUInteger, PlayActionType) {
//    ///上传图片
//    PlayActionTypeUploadImage,
//    ///喜欢
//    PlayActionTypeLove,
//    ///观看量
//    PlayActionTypeLook,
//    ///评论量
//    PlayActionTypeComment,
//    ///分享
//    PlayActionTypeShare
//};

@protocol buttonClickDelegate <NSObject>

- (void)headButtonSelect:(UIButton *)button;
- (void)guanZhuButtonSelect:(UIButton *)button;
- (void)zanButtonSelect:(UIButton *)button;
- (void)videoButtonSelect:(UIButton *)button;

@end

@interface PlayCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIView *playerView;
@property (nonatomic, strong) DisVideoModel *videoModel;
@property (nonatomic, strong) UIButton *headButton;
@property (nonatomic, strong) UIButton  *guanZhuButton;
@property (nonatomic, strong) UILabel *guanLabel;
@property (nonatomic, strong) UIButton *zanButton;
@property (nonatomic, strong) UILabel *zanLabel;
@property (nonatomic, strong) UIButton *seeButton;
@property (nonatomic, strong) UILabel *seeLabel;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) NSString *isGuanZhu;

@property (nonatomic,weak) id<buttonClickDelegate> delegate;


@property (nonatomic, strong)AliyunVodPlayer *aliPlayer;
@property (nonatomic, assign)BOOL isStart;
- (void)prepare:(NSString *)urlStr;
- (void)startPlay;
- (void)pausePlay;
- (void)resumePlay;
- (void)stopPlay;
- (void)releasePlayer;
/////准备视频
//- (void)prepare;
//
/////暂停播放
//- (void)pausePlay;
//
///*
// 功能：恢复播放视频
// 备注：在pause暂停视频之后可以调用resume进行播放。
// */
//- (void)resumePlay;
//
////停止播放
//- (void)stopPlay;
//
/////点击视频播放界面的按钮回调
////- (void)playAction:(ButtonClickBlock)action;
//
///*
// 功能：获取播放器当前播放状态
// 当前播放状态有：
// AliyunVodPlayerStateIdle = 0,           //空转，闲时，静态
// AliyunVodPlayerStateError,              //错误
// AliyunVodPlayerStatePrepared,           //已准备好
// AliyunVodPlayerStatePlay,               //播放
// AliyunVodPlayerStatePause,              //暂停
// AliyunVodPlayerStateStop,               //停止
// AliyunVodPlayerStateFinish,             //播放完成
// AliyunVodPlayerStateLoading             //加载中
// */
//- (AliyunVodPlayerState)playerState;
@end
