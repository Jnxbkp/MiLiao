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

///提交按钮
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

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
- (IBAction)closeButtonClick:(id)sender {
     [self removeFromSuperview];
}

- (IBAction)buttonArrayClick:(UIButton *)sender {
    if (self.perButton == sender) {
        return;
    }
    sender.selected = !sender.isSelected;
    self.perButton.selected = !self.perButton.isSelected;
    self.perButton = sender;
    
    self.submitButton.backgroundColor = RGBColor(0xF97298);
    self.submitButton.enabled = YES;
}
- (IBAction)sureButtonClick:(id)sender {
    [self removeFromSuperview];
    [SVProgressHUD showInfoWithStatus:@"我们已收到您的举报，会尽快处理"];
}

@end
