//
//  LoveTableViewCell.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/16.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoveTableViewCell : UITableViewCell

@property (nonatomic ,strong)UIImageView     *iconImageView;
@property (nonatomic ,strong)UIImageView     *headUrlImageView;
@property (nonatomic ,strong)UILabel         *rankLabel;
@property (nonatomic ,strong)UILabel         *nameLabel;
@property (nonatomic, strong)UILabel         *loveLabel;
@property (nonatomic, strong)UILabel         *lineLabel;

@end
