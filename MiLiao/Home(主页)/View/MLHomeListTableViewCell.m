//
//  MLHomeListTableViewCell.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2017/12/29.
//  Copyright © 2017年 Jarvan-zhang. All rights reserved.
//

#import "MLHomeListTableViewCell.h"

#import "VideoUserModel.h"


@implementation MLHomeListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creat];
    }
    return self;
}

- (void)setVideoUserModel:(VideoUserModel *)videoUserModel {
    _videoUserModel = videoUserModel;
    [_mainImgageView sd_setImageWithURL:[NSURL URLWithString:videoUserModel.posterUrl]];
    
    _nameLabel.text = videoUserModel.nickname;
    _messageLabel.text = videoUserModel.personalSign;
    [_priceView setPrice:videoUserModel.price];
}

- (void)creat {
    _mainImgageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 0, WIDTH-24, WIDTH-24)];
    [_mainImgageView setContentMode:UIViewContentModeScaleAspectFill];
    _mainImgageView.clipsToBounds = YES;

    
    _stateButton = [StateButton buttonWithType:UIButtonTypeCustom];
    _stateButton.frame = CGRectMake(WIDTH-64, 12, 40, 20);

    //jubao
    _rePortButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rePortButton.frame = CGRectMake(24, 12, 20, 20);
    [_rePortButton setImage:[UIImage imageNamed:@"jubao"] forState:UIControlStateNormal];
    [_rePortButton addTarget:self action:@selector(rePort) forControlEvents:UIControlEventTouchUpInside];
    _belowView = [[UIView alloc]initWithFrame:CGRectMake(12, WIDTH-66-24, WIDTH-24, 66)];
    _belowView.backgroundColor = ML_Color(0, 0, 0, 0.1);
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, _belowView.frame.origin.y+12, WIDTH-48, 16)];
    _nameLabel.textColor = Color255;
    _nameLabel.font = [UIFont systemFontOfSize:15.0];
    
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, _nameLabel.frame.origin.y+28, WIDTH-154-34, 15)];
    _messageLabel.textColor = Color231;
    _messageLabel.font = [UIFont systemFontOfSize:14.0];
   
    
    _priceView = [[PriceView alloc]initWithFrame:CGRectMake(WIDTH-154, _messageLabel.frame.origin.y, 130, 15) withPrice:@"0" kind:@"main"];
    _priceView.hidden = YES;
    
    [self.contentView addSubview:_mainImgageView];
    [self.contentView addSubview:_stateButton];
    [self.contentView addSubview:_rePortButton];
    [self.contentView addSubview:_belowView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_messageLabel];
    [self.contentView addSubview:_priceView];

    
}
- (void)rePort
{
    if (self.reportBlock) {
        self.reportBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
