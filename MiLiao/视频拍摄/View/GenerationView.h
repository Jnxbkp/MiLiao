//
//  GenerationView.h
//  particle
//
//  Created by Meicam on 2017/11/8.
//  Copyright © 2017年 NewAuto video team. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GenerationView;

@protocol GenerationViewDelegate<NSObject>

- (void)generationView:(GenerationView*)generationView finishClick:(Boolean)isFinish;

@end

@interface GenerationView : UIView

@property (weak, nonatomic)id delegate;
- (instancetype)initWithFrame:(CGRect)frame;

- (void)setProgress:(NSInteger)progress;

- (void)finish;
- (void)fail;

@end
