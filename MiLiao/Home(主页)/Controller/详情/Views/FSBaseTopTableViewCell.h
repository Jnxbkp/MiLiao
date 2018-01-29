//
//  FSBaseTopTableViewCell.h
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSLoopScrollView.h"
typedef void (^BackBlock)(void);

@protocol topButtonDelegate <NSObject>

- (void)focusButtonSelect:(UIButton *)button;
- (void)weiXinButtonSelect;
- (void)loveNumButtonselect;

@end

@interface FSBaseTopTableViewCell : UITableViewCell

@property (nonatomic ,strong)FSLoopScrollView   *loopView;
@property (nonatomic ,strong)StateButton         *stateButton;
@property (nonatomic ,strong)UIButton         *focusButton;
@property (nonatomic, strong)PriceView        *priceView;

@property (nonatomic ,strong)UILabel         *nameLabel;
@property (nonatomic ,strong)UILabel         *messageLabel;
@property (nonatomic ,strong)UILabel         *numFocusLabel;
@property (nonatomic ,strong)UILabel         *getweixinLabel;
@property (nonatomic ,strong)UILabel         *weixinLabel;
@property (nonatomic ,strong)UIImageView         *headImage1;
@property (nonatomic ,strong)UIImageView         *headImage2;
@property (nonatomic ,strong)UIImageView         *headImage3;

@property (nonatomic,weak) id<topButtonDelegate> delegate;
@property (nonatomic ,strong)UIButton         *rePortButton;
@property (nonatomic, copy) BackBlock  reportBlock;

@end
