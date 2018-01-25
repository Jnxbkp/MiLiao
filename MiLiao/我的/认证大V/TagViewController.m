//
//  TagViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/8.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "TagViewController.h"
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>
#import "TagModel.h"
@interface TagViewController ()<TTGTextTagCollectionViewDelegate>
{
    NSUserDefaults *_userDefaults;
    
}
@property(strong, nonatomic)TTGTextTagCollectionView *textTagCollectionView2;
@property (strong, nonatomic) NSMutableArray *tags;
@property (strong, nonatomic) NSString *tagText1;
@property (strong, nonatomic) NSString *tagText2;
@property (strong, nonatomic) NSArray *dataAry;
@property (strong, nonatomic) NSMutableArray *ary;

@end

@implementation TagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"选择形象标签"];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, WIDTH, 20)];
    lab.text = @"仅能选择两个";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:12];
    lab.textColor = [UIColor redColor];
    [self.view addSubview:lab];
    _textTagCollectionView2 = [[TTGTextTagCollectionView alloc]initWithFrame:CGRectMake(20, 70, WIDTH-40, 150)];
    
    _textTagCollectionView2.delegate = self;
    _textTagCollectionView2.showsVerticalScrollIndicator = NO;
    // Style2
    TTGTextTagConfig *config = _textTagCollectionView2.defaultConfig;

    config = _textTagCollectionView2.defaultConfig;
    
    config.tagTextFont = [UIFont systemFontOfSize:13.0f];
    
    config.tagExtraSpace = CGSizeMake(12, 12);
    
    config.tagTextColor = [UIColor whiteColor];
    config.tagSelectedTextColor = [UIColor whiteColor];
    
    config.tagBackgroundColor = [UIColor grayColor];
    config.tagSelectedBackgroundColor = [UIColor redColor];
    
    config.tagCornerRadius = 8.0f;
    config.tagSelectedCornerRadius = 8.0f;
    
    config.tagBorderWidth = 0;
    
    config.tagBorderColor = [UIColor whiteColor];
    config.tagSelectedBorderColor = [UIColor whiteColor];
    
    config.tagShadowColor = [UIColor blackColor];
    config.tagShadowOffset = CGSizeMake(0, 1);
    config.tagShadowOpacity = 0.3f;
    config.tagShadowRadius = 2;
    
    _textTagCollectionView2.horizontalSpacing = 8;
    _textTagCollectionView2.verticalSpacing = 8;
    _textTagCollectionView2.selectionLimit = 2;
    [_textTagCollectionView2 reload];
    [self.view addSubview:_textTagCollectionView2];
    [self loadData];
    UIButton *sure = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(_textTagCollectionView2.frame)+40, WIDTH-60, 50)];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    sure.backgroundColor = [UIColor redColor];
    sure.layer.cornerRadius = 8;
    [self.view addSubview:sure];
    _tags = [[NSMutableArray alloc]init];
    _ary = [[NSMutableArray alloc]init];

}
/*
 //把图片路径添加到数组
 NSMutableArray *photoMuArray = [[NSMutableArray alloc] initWithObjects:
 self.item1String,
 self.item2String,
 self.item3String,
 self.item4String,
 self.item5String,
 self.item6String,
 nil];
 [posters removeAllObjects];
 for (NSString *photoUrl in photoMuArray) {
 if (photoUrl.length > 0) {
 [posters addObject:photoUrl];
 }
 }
 */

- (void)loadData
{
    [HLLoginManager getTagstoken:[_userDefaults objectForKey:@"token"] success:^(NSDictionary *info) {
        NSLog(@"%@",info);
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            self.dataAry = info[@"data"];
            for (int i = 0 ; i < self.dataAry.count; i++) {
                NSString *str =self.dataAry[i][@"tagName"];
                [_tags addObject:str];
            }
            NSLog(@"%@",_tags);
            [_textTagCollectionView2 addTags:_tags];
        }else{
            
        }
    } failure:^(NSError *error) {
        
    }];
    

}
- (void)sure
{
    NSDictionary *userDic = [NSDictionary dictionaryWithObject:_ary forKey:@"VTags"];
    NSNotification *notification =[NSNotification notificationWithName:@"VTags" object:nil userInfo:userDic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    if (_ary.count == 1) {
//        self.tagText1 = [_ary objectAtIndex:0];
//        if (self.backBlock1) {
//            self.backBlock1(self.tagText1);
//        }
//    }
//    if (_ary.count == 2) {
//        self.tagText2 = [_ary objectAtIndex:1];
//        if (self.backBlock1) {
//            self.backBlock1(self.tagText1);
//        }
//        if (self.backBlock2) {
//            self.backBlock2(self.tagText2);
//        }
//    }
    
    
    [self.navigationController popViewControllerAnimated:YES ];
}
#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected {
    NSLog(@"%@",tagText);
    if (selected == YES) {
        [_ary addObject:tagText];
        NSLog(@"%@",_ary);
    }else{
        [_ary removeObject:tagText];
    }
    NSLog(@"9099090%@",_ary);
    if (_ary.count) {
        
    }


}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView updateContentSize:(CGSize)contentSize {
    NSLog(@"text tag collection: %@ new content size: %@", textTagCollectionView, NSStringFromCGSize(contentSize));
}


@end
