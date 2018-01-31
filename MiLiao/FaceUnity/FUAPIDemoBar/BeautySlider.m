//
//  BeautySlider.m
//
//  Created by ly on 2016/12/6.
//  Copyright © 2016年 liuyang. All rights reserved.
//

#import "BeautySlider.h"
#import "UIImage+demobar.h"

@implementation BeautySlider
{
    UILabel *tipLabel;
    UIImageView *bgImgView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setThumbImage:[UIImage imageWithName:@"expource_slider_dot"] forState:UIControlStateNormal];
    
    UIImage *bgImage = [UIImage imageWithName:@"slider_tip_white_bg"];
    bgImgView = [[UIImageView alloc] initWithImage:bgImage];
    bgImgView.frame = CGRectMake(0, -bgImage.size.height, bgImage.size.width, bgImage.size.height);
    [self addSubview:bgImgView];
    
    tipLabel = [[UILabel alloc] initWithFrame:bgImgView.frame];
    tipLabel.text = @"";
    tipLabel.textColor = [UIColor darkGrayColor];
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:tipLabel];
    
    bgImgView.hidden = YES;
    tipLabel.hidden = YES;
}

- (void)setValue:(float)value animated:(BOOL)animated
{
    [super setValue:value animated:animated];
    
    tipLabel.text = [NSString stringWithFormat:@"%.1f",value];
    
    CGFloat x = value * (self.frame.size.width - 20) - tipLabel.frame.size.width * 0.5 + 10;
    CGRect frame = tipLabel.frame;
    frame.origin.x = x;
    
    bgImgView.frame = frame;
    tipLabel.frame = frame;
    
    tipLabel.hidden = !self.tracking;
    bgImgView.hidden = !self.tracking;
}

@end
