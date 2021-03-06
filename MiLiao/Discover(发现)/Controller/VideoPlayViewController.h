//
//  VideoPlayViewController.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/29.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayCollectionViewCell;

@interface VideoPlayViewController : UIViewController


@property (nonatomic, strong)DisbaseModel  *baseModel;
@property (nonatomic, strong)DisVideoModelList  *videoModelList;
@property (assign) NSInteger    currentCell;
@property (nonatomic, strong) PlayCollectionViewCell *currentPlayCell;
@property (nonatomic, strong)NSString  *kind;

@end
