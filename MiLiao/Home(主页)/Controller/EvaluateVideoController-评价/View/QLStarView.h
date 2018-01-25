//
//  SQSareView.h
//  SongQiMall
//
//  Created by king on 2017/3/6.
//  Copyright © 2017年 king. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QLStarViewDelegate <NSObject>

- (void)clickIndex:(NSInteger)index;

@end


typedef void(^SelectedStart)(NSInteger star);

@interface QLStarView : UIView
@property (nonatomic, weak) IBInspectable id<QLStarViewDelegate> delegate;

@property (nonatomic, strong) NSString *defaultImageName;
///xib 工具栏显示的默认状态下的图片
@property (strong, nonatomic) IBInspectable UIImage *defaultImage;


@property (nonatomic, strong) NSString *lightImageName;
///xib 工具栏显示的选中状态下的图片
@property (strong, nonatomic) IBInspectable UIImage *lightImage;

///星星的是否可点击 默认为no
@property (assign, nonatomic, getter=isStarClickEnable) IBInspectable BOOL starClickEnable;

///初始化状态时 是否全部选中状态 默认不选中
@property (assign, nonatomic, getter=isAllSelecetd) IBInspectable BOOL allSelected;

/**
 获取一个5个星星的view，默认星星不可点击.

 @param frame frame
 @param defaultImageName 普通状态下星星图片的名字
 @param hightLightImageName 选中状态下图片的名字
 @param start 当前view选中星星的个数的回调
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame defaultImageName:(NSString *)defaultImageName hightLightImageName:(NSString *)hightLightImageName selectedStart:(SelectedStart)start;

- (void)getSelectedStar:(SelectedStart)star;

@end
