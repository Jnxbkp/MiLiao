//
//  tiXainTableViewCell.m
//  MiLiao
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "tiXainTableViewCell.h"

@implementation tiXainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)guanli:(id)sender {
    if (self.sureBlock) {
        self.sureBlock();
    }
}

@end
