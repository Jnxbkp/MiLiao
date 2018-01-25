//
//  tixianTableViewCell.h
//  MiLiao
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class shouruModel;
@interface shourucell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) shouruModel *model;
@property (weak, nonatomic) IBOutlet UILabel *money;
@end
