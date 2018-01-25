//
//  StateButton.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/17.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "StateButton.h"

@implementation StateButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:Color255 forState:UIControlStateNormal];
        self.layer.cornerRadius = 9.0;
        self.titleLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return self;
}
- (void)setStateStr:(NSString *)stateStr {
    UIColor *color;
    NSString *str = [NSString string];
    
    if ([stateStr isEqualToString:@"ONLINE"]) {
        color = [ToolObject getColorStr:@"#189aa2"];
        str = @"在线";
    } else if ([stateStr isEqualToString:@"OFFLINE"]) {
        color = [ToolObject getColorStr:@"#999999"];
        str = @"离线";
    } else if ([stateStr isEqualToString:@"BUSY"]) {
        color = [ToolObject getColorStr:@"#faa272"];
        str = @"勿扰";
    } else if ([stateStr isEqualToString:@"TALKING"]) {
        color = [ToolObject getColorStr:@"#fa7298"];
        str = @"在聊";
    } else {
        color = [UIColor lightGrayColor];
    }
    self.backgroundColor = color;
    [self setTitle:str forState:UIControlStateNormal];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
