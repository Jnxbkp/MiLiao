//
//  StateButton.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/17.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StateButton : UIButton

@property (nonatomic, strong)NSString *stateStr;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setStateStr:(NSString *)stateStr;
@end
