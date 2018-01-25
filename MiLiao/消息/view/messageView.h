//
//  messageView.h
//  MiLiao
//
//  Created by apple on 2018/1/9.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BackBlock)(void);

@interface messageView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btnTonghua;
@property (weak, nonatomic) IBOutlet UIButton *btnM;
@property (weak, nonatomic) IBOutlet UIButton *xitongBtn;
@property (nonatomic, copy) BackBlock tonghuaBlock;
@property (nonatomic, copy) BackBlock MBlock;
@property (nonatomic, copy) BackBlock xitongBlock;
@property (weak, nonatomic) IBOutlet UIImageView *MImageView;
@property (weak, nonatomic) IBOutlet UILabel *MLabel;
@property (weak, nonatomic) IBOutlet UIImageView *Mjiantou;


@end
