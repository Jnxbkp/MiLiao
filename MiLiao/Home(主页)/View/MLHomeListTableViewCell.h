//
//  MLHomeListTableViewCell.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2017/12/29.
//  Copyright © 2017年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BackBlock)(void);
@class VideoUserModel;


@interface MLHomeListTableViewCell : UITableViewCell

@property (nonatomic ,strong)UIImageView      *mainImgageView;
@property (nonatomic ,strong)StateButton         *stateButton;
@property (nonatomic ,strong)UIView           *belowView;
@property (nonatomic ,strong)UILabel          *nameLabel;
@property (nonatomic ,strong)UILabel          *messageLabel;
@property (nonatomic ,strong)PriceView        *priceView;
@property (nonatomic, strong) VideoUserModel *videoUserModel;
@property (nonatomic ,strong)UIButton         *rePortButton;
@property (nonatomic, copy) BackBlock  reportBlock;

@end
