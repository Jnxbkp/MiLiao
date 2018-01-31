//
//  tixianTableViewCell.m
//  MiLiao
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "shourucell.h"
#import "shouruModel.h"
@implementation shourucell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(shouruModel *)model {
    _model = model;
    self.nickName.text = [NSString stringWithFormat:@"%@",model.nickName];
    self.money.text = [NSString stringWithFormat:@"+%@撩币",model.amount];
   ///时间戳转化成时间
    NSString *str=model.createDate;//时间戳
    NSTimeInterval time=[str doubleValue]/1000;
    NSDateFormatter *stampFormatter = [[NSDateFormatter alloc] init];
    [stampFormatter setDateFormat:@"MM-dd HH:mm"];
    //以 1970/01/01 GMT为基准，然后过了secs秒的时间
    NSDate *stampDate2 = [NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"时间戳转化时间 >>> %@",[stampFormatter stringFromDate:stampDate2]);
    NSString *strTime = [NSString stringWithFormat:@"%@",model.callTime];
    self.time.text = [NSString stringWithFormat:@"%@ | 视频时长%@",[stampFormatter stringFromDate: stampDate2],[ToolObject getMMSSFromSS:strTime]];
}


@end
