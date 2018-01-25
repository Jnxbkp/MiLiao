//
//  tiXainTableViewCell.h
//  MiLiao
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BackBlock)(void);
@interface tiXainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *zhanghu;
@property (weak, nonatomic) IBOutlet UILabel *zhanghuName;
@property (weak, nonatomic) IBOutlet UILabel *moblel;
@property (nonatomic, copy) BackBlock sureBlock;

@end
