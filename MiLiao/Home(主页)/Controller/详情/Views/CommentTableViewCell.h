//
//  CommentTableViewCell.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic ,strong)UILabel            *titleLabel;
@property (nonatomic ,strong)UILabel            *messageLabel;
@property (nonatomic ,strong)UILabel            *lineLabel;
@property (nonatomic ,strong)UIImageView        *userImageView;
@property (nonatomic ,strong)ItemsView          *itemsView;

@end
