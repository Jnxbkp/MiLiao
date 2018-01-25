//
//  MyVideoViewController.h
//  MiLiao
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoUserModel;
@interface MyVideoViewController : UIViewController
@property (nonatomic, assign) BOOL vcCanScroll;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) NSString *str;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) VideoUserModel *videoUserModel;
@end
