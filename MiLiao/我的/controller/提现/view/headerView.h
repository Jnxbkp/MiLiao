//
//  headerView.h
//  MiLiao
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^textFieldBlock) (NSString*str);
typedef void (^BackBlock)(void);

@interface headerView : UIView
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UILabel *Mmoney;
@property (weak, nonatomic) IBOutlet UILabel *money;

@property(nonatomic,copy)textFieldBlock textFiledClick;//输入框block
@property (nonatomic, copy) BackBlock sureBlock;
@property (nonatomic, copy) BackBlock mingxiBlock;
@end
