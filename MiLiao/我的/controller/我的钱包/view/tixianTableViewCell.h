//
//  tixianTableViewCell.h
//  MiLiao
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MingXiModel;
@interface tixianTableViewCell : UITableViewCell
@property (strong, nonatomic) MingXiModel *model;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *nickName;

@end
