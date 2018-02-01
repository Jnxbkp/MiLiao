//
//  EvaluateVideoViewController.m
//  MiLiao
//
//  Created by King on 2018/1/16.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "EvaluateVideoViewController.h"

#import "EvaluateTagModel.h"
#import "UserInfoNet.h"
#import "QLStarView.h"//星星view
#import "SetMoneyView.h"//结算成功的view

#import "UserInfoNet.h"

@implementation TagButton

- (void)setEvaluateTag:(EvaluateTagModel *)evaluateTag {
    _evaluateTag = evaluateTag;
    [self setTitle:evaluateTag.tagName forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = [self colorwithHexString:self.evaluateTag.tagColor];
    } else {
        self.backgroundColor = [UIColor lightGrayColor];
    }
}


///通过字符串转颜色
- (UIColor *)colorwithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textColor = [UIColor orangeColor];
        self.backgroundColor = [UIColor lightGrayColor];
    
        [self.titleLabel sizeToFit];
    }
    return self;
}


@end



@interface EvaluateVideoViewController ()<QLStarViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *tagContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagContentViewHeightConstraint;

@property (nonatomic, strong) NSArray *tagModelArray;
@property (nonatomic, strong) NSArray<TagButton *> *tagButtonArray;
///通话时长label
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
///消费金额label
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet QLStarView *starView;
@property (weak, nonatomic) IBOutlet UIView *mainView;

///选中的标签数组
@property (nonatomic, strong) NSMutableArray<EvaluateTagModel *> *selecetdEvaluateArray;
///评价 星星的个数
@property (nonatomic, strong) NSString *score;
@end

@implementation EvaluateVideoViewController
{
    EvaluateSuccessBlock _evaluateBlock;
}
#pragma mark - Getter
- (NSMutableArray<EvaluateTagModel *> *)selecetdEvaluateArray {
    if (!_selecetdEvaluateArray) {
        _selecetdEvaluateArray = [NSMutableArray array];
    }
    return _selecetdEvaluateArray;
}

#pragma mark - Setter
- (void)setEvaluateDict:(NSDictionary *)evaluateDict {
    _evaluateDict = evaluateDict;
    self.anchorName = evaluateDict[@"anchorName"];
    self.callID = evaluateDict[@"callId"];
}

- (void)setTagModelArray:(NSArray *)tagModelArray {
    _tagModelArray = tagModelArray;
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (EvaluateTagModel *tag in tagModelArray) {
        TagButton *button = [TagButton buttonWithType:UIButtonTypeCustom];
        button.evaluateTag = tag;
        [mutableArray addObject:button];
        [self.tagContentView addSubview:button];
        [button addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.tagButtonArray = [mutableArray copy];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    }
    return self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //布局标签
    [self layoutTagViews];
}

///布局标签
- (void)layoutTagViews {
    CGFloat margin = 10.0;
    NSInteger j = 0;
    CGFloat x = margin;
    for (NSInteger i = 0; i < self.tagButtonArray.count; i++) {
        TagButton *button = self.tagButtonArray[i];
        [button sizeToFit];
        CGFloat width = button.width +15;
        if (i >= 1) {
            TagButton *preButton = self.tagButtonArray[i-1];
            x = CGRectGetMaxX(preButton.frame) + margin;
            if (x + CGRectGetMaxX(button.frame) + margin > self.tagContentView.width) {
                x = margin;
                j++;
            }
        }
        CGFloat y = margin * (j+1) + j*30;
        button.frame = CGRectMake(x, y, width, 30);
    }
    TagButton *button = [self.tagButtonArray lastObject];
    self.tagContentViewHeightConstraint.constant = CGRectGetMaxY(button.frame) + 20;
}

///弹出凭借界面
- (void)showEvaluaateView:(NSDictionary *)dict {
    [self.superview addSubview:self.view];
    self.anchorName = dict[@"anchorName"];
    self.callID = dict[@"callId"];
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.superview);
    }];
     [SVProgressHUD showInfoWithStatus:@"正在结算"];
}

- (void)showSetMoneySuccessView:(NSDictionary *)dict {
     [SVProgressHUD dismiss];
    SetMoneyView *view = [SetMoneyView SetMoneyView];
    NSString *time = dict[@"time"];
    NSString *money = [NSString stringWithFormat:@"%@M币", dict[@"totalFee"]] ;
    NSLog(@"time is %@, money is %@", time, money);
    self.timeLabel.text = time;
    self.moneyLabel.text = money;
    [self.mainView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.mainView);
    }];
    //停留2秒
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            view.transform = CGAffineTransformMakeScale(0.1, 0.1);
            view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.starView.delegate = self;
    self.score = @"5";
    [UserInfoNet getEvaluate:^(RequestState success, NSArray *modelArray, NSInteger code, NSString *msg) {
        if (success) {
            self.tagModelArray = modelArray;
        }
    }];
  
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 控件点击方法
///标签点击
- (void)tagButtonClick:(TagButton *)sender {
    
    EvaluateTagModel *tag = sender.evaluateTag;
    
    if ([self.selecetdEvaluateArray containsObject:tag]) {
        [self.selecetdEvaluateArray removeObject:tag];
        sender.selected = !sender.isSelected;
    } else {
        if (self.selecetdEvaluateArray.count >= 3) {
            NSLog(@"最多只能选择三个");
            [SVProgressHUD showInfoWithStatus:@"最多只能选择三个"];
        } else {
            [self.selecetdEvaluateArray addObject:tag];
            sender.selected = !sender.isSelected;
        }
    }
    
}

///星星评价的个数
- (void)clickIndex:(NSInteger)index {
    self.score = [NSString stringWithFormat:@"%ld", index];
}

- (IBAction)sureButtonClick:(id)sender {
    
    if (self.selecetdEvaluateArray.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选取评价标签"];
        return;
    }
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    [self.selecetdEvaluateArray enumerateObjectsUsingBlock:^(EvaluateTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [mutableArray addObject:obj.ID];
    }];
    
    [UserInfoNet saveEvaluateAnchorName:self.anchorName callId:self.callID score:self.score tags:mutableArray complete:^(RequestState success, NSString *msg) {
        NSString *message = @"评价成功";
        if (!success) message = msg;
        [SVProgressHUD showSuccessWithStatus:message];
        [self.view removeFromSuperview];
        !_evaluateBlock?:_evaluateBlock();
        if ([self.delegate respondsToSelector:@selector(evaluateSuccessOrClose)]) {
            [self.delegate evaluateSuccessOrClose];
        }
    }];
}

- (IBAction)cancleButtonClick:(UIButton *)sender {
    [self.view removeFromSuperview];
    !_evaluateBlock?:_evaluateBlock();
    if ([self.delegate respondsToSelector:@selector(evaluateSuccessOrClose)]) {
        [self.delegate evaluateSuccessOrClose];
    }
}



///评价成功的回调
- (void)evaluateSuccess:(EvaluateSuccessBlock)success {
    _evaluateBlock = success;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
