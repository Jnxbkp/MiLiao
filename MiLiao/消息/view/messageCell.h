//
//  messageCell.h
//  MiLiao
//
//  Created by apple on 2018/1/3.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CallListModel;

@interface messageCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) CallListModel *model;

@end
