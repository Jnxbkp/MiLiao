//
//  FxTableViewCell.m
//  Capture
//
//  Created by Meicam on 2017/9/22.
//  Copyright © 2017年 meishe.cdv.com. All rights reserved.
//

#import "FxTableViewCell.h"

@implementation FxTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_fxThumbBackgroundView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:_fxThumbBackgroundView.bounds.size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = _fxThumbBackgroundView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    _fxThumbBackgroundView.layer.mask = maskLayer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
