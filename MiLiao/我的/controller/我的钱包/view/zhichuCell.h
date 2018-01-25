//
//  tixianTableViewCell.h
//  MiLiao
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class zhichuModel;
@interface zhichuCell : UITableViewCell
@property (strong, nonatomic) zhichuModel *model;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
