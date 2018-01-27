//
//  ReportView.m
//  MiLiao
//
//  Created by King on 2018/1/27.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "ReportView.h"

@interface ReportView ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonArray;

@property (nonatomic, strong) UIButton *perButton;

@end

@implementation ReportView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.frame = [UIScreen mainScreen].bounds;

}

+ (instancetype)ReportView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
}

- (void)show {

    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)buttonArrayClick:(UIButton *)sender {
    if (self.perButton == sender) {
        return;
    }
    sender.selected = !sender.isSelected;
    self.perButton.selected = !self.perButton.isSelected;
    self.perButton = sender;
}
- (IBAction)sureButtonClick:(id)sender {
    [self removeFromSuperview];
    [SVProgressHUD showInfoWithStatus:@"我们已收到您的举报，会尽快处理"];
}

@end
