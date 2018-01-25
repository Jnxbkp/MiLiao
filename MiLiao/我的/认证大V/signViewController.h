//
//  signViewController.h
//  MiLiao
//
//  Created by apple on 2018/1/8.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BackBlock)(NSString * text);

@interface signViewController : UIViewController
@property (nonatomic, copy) BackBlock backBlock;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
