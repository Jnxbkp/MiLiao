//
//  CommentTableViewCell.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creat];
    }
    return self;
}
- (void)creat {
    _userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 28, 28)];
    _userImageView.layer.masksToBounds = YES;
    _userImageView.layer.cornerRadius = 14.0;
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 18, 100, 13)];
    _titleLabel.textColor = Color128;
    _titleLabel.font = [UIFont systemFontOfSize:13.0];
    
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 47.7, WIDTH, 0.3)];
    _lineLabel.backgroundColor = Color242;
    
    _itemsView = [[ItemsView alloc]initWithFrame:CGRectMake(WIDTH/2-12, 12, WIDTH/2-24, 24)];
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_userImageView];
    [self.contentView addSubview:_lineLabel];
    [self.contentView addSubview:_itemsView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
