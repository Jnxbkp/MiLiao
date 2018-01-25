//
//  messageCell.m
//  MiLiao
//
//  Created by apple on 2018/1/3.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "messageCell.h"
#import "CallListModel.h"
@implementation messageCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setModel:(CallListModel *)model {
    _model = model;
    self.message.text = [NSString stringWithFormat:@"%@",model.createDate];
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.headUrl]];

}



@end
