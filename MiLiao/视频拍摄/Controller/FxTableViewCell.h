//
//  FxTableViewCell.h
//  Capture
//
//  Created by Meicam on 2017/9/22.
//  Copyright © 2017年 meishe.cdv.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FxTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fxNameLabel;
@property (weak, nonatomic) IBOutlet UIView *fxThumbBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *fxImage;

@end
