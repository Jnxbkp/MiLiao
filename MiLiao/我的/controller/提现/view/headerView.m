//
//  headerView.m
//  MiLiao
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "headerView.h"

@implementation headerView
- (IBAction)sure:(id)sender {
    
    if (self.sureBlock) {
        self.sureBlock();
    }
}
- (IBAction)mingXin:(id)sender {
    if (self.mingxiBlock) {
        self.mingxiBlock();
    }
}
- (IBAction)textField:(UITextField *)sender {
    if (self.textFiledClick) {
        self.textFiledClick(sender.text);
    }
}


@end
