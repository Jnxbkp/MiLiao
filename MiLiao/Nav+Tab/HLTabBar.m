//
//  HLTabBar.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/5.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "HLTabBar.h"

@interface HLTabBar()
@property (nonatomic, strong) UIButton *middleBtn;
@end

@implementation HLTabBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isHidden = [userDefaults objectForKey:@"isHidden"];
    if ([isHidden isEqualToString:@"yes"]) {
        CGFloat w = self.bounds.size.width/4.0;
        
        UIButton *sendBtn = [[UIButton alloc] init];
        sendBtn.backgroundColor = [UIColor clearColor];
        [sendBtn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        
        sendBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [sendBtn addTarget:self action:@selector(didClickPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
        sendBtn.adjustsImageWhenHighlighted = NO;
        sendBtn.size = CGSizeMake(30, 30);
        sendBtn.centerX = w+w/2;
        sendBtn.centerY = 20;
        [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:sendBtn];
        self.middleBtn = sendBtn;
        
        [sendBtn setImagePositionWithType:SSImagePositionTypeTop spacing:3];
        // 其他位置按钮
        NSUInteger count = self.subviews.count;
        for (NSUInteger i = 0 , j = 0; i < count; i++)
        {
            UIView *view = self.subviews[i];
            Class class = NSClassFromString(@"UITabBarButton");
            if ([view isKindOfClass:class])
            {
                view.width = self.width / 4.0;
                view.x = self.width * j / 4.0;
                j++;
                if (j == 1)
                {
                    j++;
                }
            }
        }
    } else {
        CGFloat w = self.bounds.size.width/5.0;
        
        UIButton *sendBtn = [[UIButton alloc] init];
        sendBtn.backgroundColor = [UIColor clearColor];
        [sendBtn setImage:[UIImage imageNamed:@"tabar_plus_normal@2x"] forState:UIControlStateNormal];
        
        sendBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [sendBtn addTarget:self action:@selector(didClickPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
        sendBtn.adjustsImageWhenHighlighted = NO;
        sendBtn.size = CGSizeMake(w, 70);
        sendBtn.centerX = self.width / 2;
        sendBtn.centerY = 12;
        [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:sendBtn];
        self.middleBtn = sendBtn;
        
        [sendBtn setImagePositionWithType:SSImagePositionTypeTop spacing:4];
        // 其他位置按钮
        NSUInteger count = self.subviews.count;
        for (NSUInteger i = 0 , j = 0; i < count; i++)
        {
            UIView *view = self.subviews[i];
            Class class = NSClassFromString(@"UITabBarButton");
            if ([view isKindOfClass:class])
            {
                view.width = self.width / 5.0;
                view.x = self.width * j / 5.0;
                j++;
                if (j == 2)
                {
                    j++;
                }
            }
        }
    }
   
    
}
// 发布
- (void)didClickPublishBtn:(UIButton*)sender {
    if (self.didMiddBtn) {
        self.didMiddBtn();
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.isHidden == NO)
    {
        CGPoint newP = [self convertPoint:point toView:self.middleBtn];
        if ( [self.middleBtn pointInside:newP withEvent:event])
        {
            return self.middleBtn;
        }else
        {
            return [super hitTest:point withEvent:event];
        }
    }
    else
    {
        return [super hitTest:point withEvent:event];
    }
}


@end
