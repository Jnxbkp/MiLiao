//
//  NickNameViewController.h
//  MiLiao
//
//  Created by apple on 2018/1/6.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BackBlock)(NSString * text);

@interface NickNameViewController : UIViewController
@property (nonatomic, copy) BackBlock backBlock;
@property (strong, nonatomic) IBOutlet UITextField *textFiled;

@end
