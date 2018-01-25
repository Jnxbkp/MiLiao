//
//  TagViewController.h
//  MiLiao
//
//  Created by apple on 2018/1/8.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BackkBlock)(NSString * text);

@interface TagViewController : UIViewController
@property (nonatomic, copy) BackkBlock backBlock1;
@property (nonatomic, copy) BackkBlock backBlock2;

@end
