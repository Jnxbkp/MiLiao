//
//  MLDetailTableViewCell.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/2.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "MLDetailTableViewCell.h"

@implementation MLDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creat];
    }
    return self;
}
- (void)creat {
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 12.5, WIDTH/3, 13)];
    _titleLabel.textColor = Color128;
    _titleLabel.font = [UIFont systemFontOfSize:13.0];
    
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2, 10, WIDTH/2-12, 18)];
    _messageLabel.textAlignment = NSTextAlignmentRight;
    _messageLabel.textColor = Color155;
    _messageLabel.font = [UIFont systemFontOfSize:12.0];
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.3)];
    _lineLabel.backgroundColor = Color242;
    
//    _userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 28, 28)];
//    _userImageView.hidden = YES;
//    _userImageView.layer.cornerRadius = 14.0;
//
//    _itemsView = [[ItemsView alloc]initWithFrame:CGRectMake(WIDTH/2-30, 12, WIDTH/2, 25)];
//    _itemsView.hidden = YES;
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_messageLabel];
    [self.contentView addSubview:_lineLabel];
//    [self.contentView addSubview:_itemsView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
