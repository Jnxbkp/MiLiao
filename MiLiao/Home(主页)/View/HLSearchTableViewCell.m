//
//  HLSearchTableViewCell.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/3.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "HLSearchTableViewCell.h"

@implementation HLSearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creat];
    }
    return self;
}
- (void)creat {
    self.backgroundColor = Color242;
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 50, 50)];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 25.0;
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 20, WIDTH-90, 20)];
    _nameLabel.textColor = Color75;
    _nameLabel.font = [UIFont systemFontOfSize:14.0];
    
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y+28, _nameLabel.frame.size.width-80, 14)];
    _messageLabel.textColor = Color155;
    _messageLabel.font = [UIFont systemFontOfSize:12.0];
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 74.7, WIDTH, 0.3)];
    _lineLabel.backgroundColor = Color229;
    
    _seeLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-82, _messageLabel.frame.origin.y,70, 14)];
    _seeLabel.textColor = Color155;
    _seeLabel.font = [UIFont systemFontOfSize:12.0];
    _seeLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:_headImageView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_messageLabel];
    [self.contentView addSubview:_lineLabel];
    [self.contentView addSubview:_seeLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
