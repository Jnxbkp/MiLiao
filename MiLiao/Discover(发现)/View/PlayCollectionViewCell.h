//
//  PlayCollectionViewCell.h
//  MiLiao
//
//  Created by King on 2018/1/12.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AliyunVodPlayerSDK/AliyunVodPlayerDefine.h>

typedef NS_ENUM(NSUInteger, PlayActionType) {
    ///上传图片
    PlayActionTypeUploadImage,
    ///喜欢
    PlayActionTypeLove,
    ///观看量
    PlayActionTypeLook,
    ///评论量
    PlayActionTypeComment,
    ///分享
    PlayActionTypeShare
};

typedef void(^ButtonClickBlock)(PlayActionType actionType);

@interface PlayCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSString *playURLString;

///准备视频
- (void)prepare;

///暂停播放
- (void)pausePlay;

/*
 功能：恢复播放视频
 备注：在pause暂停视频之后可以调用resume进行播放。
 */
- (void)resumePlay;

//停止播放
- (void)stopPlay;

///点击视频播放界面的按钮回调
- (void)playAction:(ButtonClickBlock)action;

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
- (AliyunVodPlayerState)playerState;


@end
