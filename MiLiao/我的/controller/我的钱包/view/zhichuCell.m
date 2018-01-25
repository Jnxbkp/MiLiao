//
//  tixianTableViewCell.m
//  MiLiao
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "zhichuCell.h"
#import "zhichuModel.h"
@implementation zhichuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(zhichuModel *)model {
    _model = model;
//    self.message.text = [NSString stringWithFormat:@"%@",model.createDate];
//    [self.image sd_setImageWithURL:[NSURL URLWithString:model.headUrl]];
    self.money.text = [NSString stringWithFormat:@"-%@M币",model.amount];
    self.nickName.text = [NSString stringWithFormat:@"视频通话 —%@",model.nickName];
    
    //时间戳转化成时间
    NSString *str=model.createDate;//时间戳
    NSTimeInterval time=[str doubleValue]/1000;
    NSDateFormatter *stampFormatter = [[NSDateFormatter alloc] init];
    [stampFormatter setDateFormat:@"MM-dd HH:mm"];
    //以 1970/01/01 GMT为基准，然后过了secs秒的时间
    NSDate *stampDate2 = [NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"时间戳转化时间 >>> %@",[stampFormatter stringFromDate:stampDate2]);
      self.time.text = [stampFormatter stringFromDate: stampDate2];
}
//- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
//{
//    // 格式化时间
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"MM月dd日 HH:mm"];
//    
//    // 毫秒值转化为秒
//    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
//    NSString* dateString = [formatter stringFromDate:date];
//    return dateString;
//}

@end
