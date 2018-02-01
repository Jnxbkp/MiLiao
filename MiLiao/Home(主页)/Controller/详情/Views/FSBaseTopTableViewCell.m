//
//  FSBaseTopTableViewCell.m
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "FSBaseTopTableViewCell.h"

#define buttonTag   2000

@interface FSBaseTopTableViewCell ()

@end
@implementation FSBaseTopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self addHeadView];
       
    }
    return self;
}
//上方视图
- (void)addHeadView {

    _loopView = [FSLoopScrollView loopImageViewWithFrame:CGRectMake(0, 0, WIDTH, WIDTH) isHorizontal:YES];
    
    _stateButton = [StateButton buttonWithType:UIButtonTypeCustom];
    _stateButton.frame = CGRectMake(WIDTH-52, ML_StatusBarHeight+12, 40, 20);
    if (UI_IS_IPHONE6PLUS) {
        _stateButton.frame = CGRectMake(WIDTH-52, ML_StatusBarHeight+32, 40, 20);
    }
    //jubao
    _rePortButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rePortButton.frame = CGRectMake(WIDTH-32, CGRectGetMaxY(_stateButton.frame)+24, 20, 20);
    [_rePortButton setImage:[UIImage imageNamed:@"jubao"] forState:UIControlStateNormal];
    [_rePortButton addTarget:self action:@selector(rePort) forControlEvents:UIControlEventTouchUpInside];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, WIDTH-68, (WIDTH-24)/2, 20)];
    _nameLabel.textColor = ML_Color(255, 255, 255, 1);
    _nameLabel.text = @"认证名称";
    _nameLabel.font = [UIFont systemFontOfSize:20.0];

    _focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _focusButton.backgroundColor = ML_Color(255, 255, 255, 0.7);
    [_focusButton setTitleColor:ML_Color(250, 114, 152, 1) forState:UIControlStateNormal];
   
   
    _focusButton.frame = CGRectMake(WIDTH-76, _nameLabel.frame.origin.y, 64, 20);
    _focusButton.layer.cornerRadius = 9.0;
    [_focusButton addTarget:self action:@selector(selectFocusButton:) forControlEvents:UIControlEventTouchUpInside];
    _focusButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, _nameLabel.frame.origin.y+32, WIDTH-24, 1)];
    lineLabel.backgroundColor = [UIColor whiteColor];
    
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, lineLabel.frame.origin.y+13, WIDTH-24, 13)];
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.text = @"个人形象标签";
    _messageLabel.font = [UIFont systemFontOfSize:13.0];

    _numFocusLabel = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH-24)/2+22, _nameLabel.frame.origin.y+5, WIDTH-((WIDTH-24)/2+22)-88, 10)];
    _numFocusLabel.textColor = [UIColor whiteColor];
    _numFocusLabel.font = [UIFont systemFontOfSize:10.0];
    _numFocusLabel.textAlignment = NSTextAlignmentRight;
//    _numFocusLabel.text = [NSString stringWithFormat:@"23984关注"];

    UILabel *downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, WIDTH+150, WIDTH, 8)];
    downLabel.backgroundColor = Color242;
    
    [self addSubview:_loopView];
    [self addSubview:_stateButton];
    [self addSubview:_rePortButton];
    [self addSubview:_focusButton];
    [self addSubview:_nameLabel];
    [self addSubview:_messageLabel];
    [self addSubview:_numFocusLabel];
    [self addSubview:lineLabel];
    
   
    
    
    NSArray *arr = [NSArray array];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isHidden = [userDefaults objectForKey:@"isHidden"];
    if ([isHidden isEqualToString:@"yes"]) {
        downLabel.frame = CGRectMake(0, WIDTH+50, WIDTH, 8);
        arr = [NSArray arrayWithObjects:@"亲密度排行:", nil];
    } else {
        downLabel.frame = CGRectMake(0, WIDTH+100, WIDTH, 8);
        arr = [NSArray arrayWithObjects:@"视频聊天需要支付:",@"亲密度排行:", nil];
//        arr = [NSArray arrayWithObjects:@"视频聊天需要支付:",@"亲密度排行:",@"个人微信:", nil];
    }
    
    [self addSubview:downLabel];
    
    for (int i = 0; i < arr.count ; i ++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, WIDTH+18+50*i, 150, 14)];
        label.textColor = Color75;
        label.font = [UIFont systemFontOfSize:14.0];
        label.text = arr[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.frame = CGRectMake(0, WIDTH+50*i, WIDTH, 50);
        button.tag = buttonTag+i;
        [button addTarget:self action:@selector(mindButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, button.frame.origin.y+50, WIDTH, 0.3)];
        lineLabel.backgroundColor = Color242;
        
        if ([isHidden isEqualToString:@"yes"]) {
            UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-25, button.frame.origin.y+16, 13, 18)];
            iconImageView.image = [UIImage imageNamed:@"BackArrow"];
            for (int i = 0; i < 3; i ++) {
                
                UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-70-(44*i), button.frame.origin.y+9, 32, 32)];
                headImage.layer.cornerRadius = 16;
                headImage.layer.masksToBounds = YES;
                
                [self addSubview:headImage];
                
                if (i == 0) {
                    _headImage1 = headImage;
                } else if (i == 1) {
                    _headImage2 = headImage;
                } else {
                    _headImage3 = headImage;
                }
                
                
            }
            [self addSubview:iconImageView];
            [self addSubview:lineLabel];
        } else {
            if (i == 0) {
                _priceView = [[PriceView alloc]initWithFrame:CGRectMake(12+label.frame.size.width+10, label.frame.origin.y-0.5, WIDTH-(12+label.frame.size.width+10)-12, 15) withPrice:@" " kind:@""];
                [self addSubview:_priceView];
                [self addSubview:lineLabel];
                
            } else if (i == 1) {
                UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-25, button.frame.origin.y+16, 13, 18)];
                iconImageView.image = [UIImage imageNamed:@"BackArrow"];
                for (int i = 0; i < 3; i ++) {
                    
                    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-70-(44*i), button.frame.origin.y+9, 32, 32)];
                    headImage.layer.cornerRadius = 16;
                    headImage.layer.masksToBounds = YES;
                    
                    [self addSubview:headImage];
                    
                    if (i == 0) {
                        _headImage1 = headImage;
                    } else if (i == 1) {
                        _headImage2 = headImage;
                    } else {
                        _headImage3 = headImage;
                    }
                    
                    
                }
                [self addSubview:iconImageView];
//                [self addSubview:lineLabel];
            }
//            else {
//                
//                _weixinLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2, button.frame.origin.y+18, WIDTH/2-12, 14)];
//                _weixinLabel.text = @"WX******";
//                _weixinLabel.textColor = Color75;
//                _weixinLabel.textAlignment = NSTextAlignmentRight;
//                _weixinLabel.font = [UIFont systemFontOfSize:14.0];
//                
//                _getweixinLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-140, button.frame.origin.y+18, 60, 14)];
//                _getweixinLabel.text = @"购买查看";
//                _getweixinLabel.textColor = NavColor;
//                _getweixinLabel.font = [UIFont systemFontOfSize:14.0];
//                
//                [self addSubview:_getweixinLabel];
//                [self addSubview:_weixinLabel];
//            }
        }
        
        [self addSubview:label];
        [self addSubview:button];
        
    }

}
- (void)rePort
{
    if (self.reportBlock) {
        self.reportBlock();
    }
}
//关注
- (void)selectFocusButton:(UIButton *)button {
    [self.delegate focusButtonSelect:button];
}
//亲密度和微信
- (void)mindButtonSelect:(UIButton *)button {
    if (button.tag == buttonTag+1) {
        [self.delegate loveNumButtonselect];
    } else if (button.tag == buttonTag+2) {
        [self.delegate weiXinButtonSelect];
    }
}
//- (void)backBarButtonSelect:(UIButton *)button {
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

@end
