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
    self.title.text = [NSString stringWithFormat:@"%@",model.nickName];
    self.message.text = [NSString stringWithFormat:@"%@",model.createDate];
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.headUrl]];
    NSString *strTime = [NSString stringWithFormat:@"%@",model.callTime];
    NSString *callType = [NSString stringWithFormat:@"%@",model.callType];
    //1：完成；2：已取消；3：已拒绝；4：未接听；5：对方繁忙；6：对方取消；7：对方拒绝；8：对方未接听；0：通话异常结束；
    if ([callType isEqualToString:@"1"]) {
        self.message.text = [NSString stringWithFormat:@"%@ | 完成",model.createDate];
        
    }else if ([callType isEqualToString:@"2"]) {
        self.message.text = [NSString stringWithFormat:@"%@ | 已取消",model.createDate];

    }else if ([callType isEqualToString:@"3"]) {
        self.message.text = [NSString stringWithFormat:@"%@ | 已拒绝",model.createDate];

    }else if ([callType isEqualToString:@"4"]) {
        self.message.text = [NSString stringWithFormat:@"%@ | 未接听",model.createDate];

    } else if ([callType isEqualToString:@"5"]) {
        self.message.text = [NSString stringWithFormat:@"%@ | 对方繁忙",model.createDate];

    } else if ([callType isEqualToString:@"6"]) {
        self.message.text = [NSString stringWithFormat:@"%@ | 对方取消",model.createDate];

    } else if ([callType isEqualToString:@"7"]) {
        self.message.text = [NSString stringWithFormat:@"%@ | 对方拒绝",model.createDate];

    } else if ([callType isEqualToString:@"8"]) {
        self.message.text = [NSString stringWithFormat:@"%@ | 对方未接听",model.createDate];

    } else if ([callType isEqualToString:@"0"]) {
        self.message.text = [NSString stringWithFormat:@"%@ | 通话异常结束",model.createDate];

    }else{
        self.message.text = [NSString stringWithFormat:@"%@ | 通话时长%@",model.createDate,[ToolObject getMMSSFromSS:strTime]];

    }
   
//     self.message.text = [NSString stringWithFormat:@"%@ | 通话时长%@",model.createDate,[ToolObject getMMSSFromSS:strTime]];
  

}


@end
