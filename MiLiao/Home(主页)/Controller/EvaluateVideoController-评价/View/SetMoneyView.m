//
//  SetMoneyView.m
//  MiLiao
//
//  Created by King on 2018/1/17.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "SetMoneyView.h"

@implementation SetMoneyView


+ (instancetype)SetMoneyView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
