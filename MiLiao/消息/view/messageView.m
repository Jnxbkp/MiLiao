//
//  messageView.m
//  MiLiao
//
//  Created by apple on 2018/1/9.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "messageView.h"

@implementation messageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btn:(UIButton *)sender {
    if (sender == self.btnTonghua) {
        if (self.tonghuaBlock) {
            self.tonghuaBlock();
        }
    }
    if (sender == self.btnM) {
        if (self.MBlock) {
            self.MBlock();
        }
    }
    if (sender == self.xitongBtn) {
        if (self.xitongBlock) {
            self.xitongBlock();
        }
    }
}


@end
