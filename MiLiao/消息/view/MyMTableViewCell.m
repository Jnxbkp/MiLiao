//
//  MyMTableViewCell.m
//  MiLiao
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "MyMTableViewCell.h"
#import "Mmodel.h"
@implementation MyMTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}
- (void)setModel:(Mmodel *)model {
    _model = model;

    //时间戳转化成时间
    NSString *str=model.createDate;//时间戳
    NSTimeInterval time=[str doubleValue]/1000;
    NSDateFormatter *stampFormatter = [[NSDateFormatter alloc] init];
    [stampFormatter setDateFormat:@"MM-dd HH:mm"];
    //以 1970/01/01 GMT为基准，然后过了secs秒的时间
    NSDate *stampDate2 = [NSDate dateWithTimeIntervalSince1970:time];
    self.time.text = [NSString stringWithFormat:@"%@",[stampFormatter stringFromDate: stampDate2]];
    NSDateFormatter *stampFormatter2 = [[NSDateFormatter alloc] init];
    [stampFormatter2 setDateFormat:@"MM-dd"];
    self.timeTwo.text = [NSString stringWithFormat:@"%@",[stampFormatter2 stringFromDate: stampDate2]];
    self.leftLabel.text = [NSString stringWithFormat:@"购买支付:%lld元",[model.amount longLongValue]*2];
    self.Mmoney.text = [NSString stringWithFormat:@"%@撩币",model.amount];
   
    /*
     type 0:视频, 1:私信, 2:微信购买，  3提现 4充值
     isbigV = 0普通用户 0,1,2,4 支出
     isbigV = 3大V用户 0,1,2,3 收入
     */
    NSString *isV = [NSString stringWithFormat:@"%@",[YZCurrentUserModel sharedYZCurrentUserModel].isBigv];
    if ([isV isEqualToString:@"0"]) {
        
    }
    NSString *typeStr = [NSString stringWithFormat:@"%@",model.type];
    if ([typeStr isEqualToString:@"0"]) {
        self.rightLabel.text = @"视频通话";
        self.moneyLabel.text = @"支出金额";
        self.title.text  = @"支出";
    }
    if ([typeStr isEqualToString:@"1"]) {
        self.rightLabel.text = @"购买微信";
        self.moneyLabel.text = @"支出金额";
        self.title.text  = @"支出";

    }
    if ([typeStr isEqualToString:@"2"]) {
        self.rightLabel.text = @"视频通话";
        self.moneyLabel.text = @"支出金额";
        self.title.text  = @"支出";

    }
    if ([typeStr isEqualToString:@"3"]) {
        self.rightLabel.text = @"提现";
    }
    if ([typeStr isEqualToString:@"4"]) {
        self.rightLabel.text = @"充值";
        self.moneyLabel.text = @"充值金额";
        self.title.text  = @"充值";

    }
}


@end
