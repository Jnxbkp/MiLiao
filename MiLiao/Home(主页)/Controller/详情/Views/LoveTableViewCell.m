//
//  LoveTableViewCell.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/16.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "LoveTableViewCell.h"

@implementation LoveTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self creat];
        
    }
    return self;
}
- (void)creat {
    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 24, 24, 24)];
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 12.0;
    
    _rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 30, 40, 12)];
    _rankLabel.font = [UIFont systemFontOfSize:12.0];
    _rankLabel.textColor = ML_Color(78, 78, 78, 1);
    
    _headUrlImageView = [[UIImageView alloc]initWithFrame:CGRectMake(52, 11, 50, 50)];
    _headUrlImageView.layer.masksToBounds = YES;
    _headUrlImageView.layer.cornerRadius = 25.0;
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(114, 18, WIDTH-130, 15)];
    _nameLabel.font = [UIFont systemFontOfSize:15.0];
    _nameLabel.textColor = Color75;
    
    _loveLabel = [[UILabel alloc]initWithFrame:CGRectMake(114, 44, WIDTH-130, 12)];
    _loveLabel.font = [UIFont systemFontOfSize:12.0];
    _loveLabel.textColor = ML_Color(155, 155, 155, 1);
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.3)];
    _lineLabel.backgroundColor = Color242;
    
    [self.contentView addSubview:_iconImageView];
     [self.contentView addSubview:_rankLabel];
     [self.contentView addSubview:_headUrlImageView];
    [self.contentView addSubview:_nameLabel];
     [self.contentView addSubview:_loveLabel];
     [self.contentView addSubview:_lineLabel];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
