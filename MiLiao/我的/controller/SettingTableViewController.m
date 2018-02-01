//
//  SettingTableViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "SettingTableViewController.h"
#import "IQActionSheetPickerView.h"

@interface SettingTableViewController ()<IQActionSheetPickerViewDelegate>
{
    NSUserDefaults *_userDefaults;

}
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UISwitch *swich;
@property (nonatomic, copy) NSString * strM;
@property (nonatomic, copy) NSString * strCM;
@property (nonatomic, strong) NSString *status;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"设置"];
    if ([[_userDefaults objectForKey:@"status"]isEqualToString:@"BUSY"]) {
        self.swich.on = YES;
    }else if ([[_userDefaults objectForKey:@"status"]isEqualToString:@"TALKING"])
    {
        self.swich.on = NO;
    }else{
        NSLog(@"其他");
        self.swich.on = NO;//设置初始为off的一边
        
    }
   self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.money.text = [NSString stringWithFormat:@"%@撩币/分钟",[_userDefaults objectForKey:@"price"]];

}
- (IBAction)swich:(UISwitch *)sender {
    BOOL isButtonOn = [self.swich isOn];
    if (isButtonOn) {
        NSLog(@"开");
        self.status = [NSString stringWithFormat:@"BUSY"];
        [_userDefaults setObject:@"BUSY" forKey:@"status"];
        [self updateStatus];

    }else {
        NSLog(@"关");
        self.status = @"TALKING";
        [_userDefaults setObject:@"TALKING" forKey:@"status"];
        [self updateStatus];

    }
}
- (void)updateStatus
{
    [HLLoginManager updateStatustoken:[_userDefaults objectForKey:@"token"] status:self.status success:^(NSDictionary *info) {
        NSLog(@"%@",info);
        NSLog(@"22222%@",[_userDefaults objectForKey:@"token"]);
        NSLog(@"121221%@",self.status);
    } failure:^(NSError *error) {
        
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 0;
    }
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"" delegate:self];
        picker.toolbarTintColor = [UIColor whiteColor];
        picker.titleColor = [UIColor whiteColor];
        //        picker.titleFont = [UIFont systemFontOfSize:16];
        picker.toolbarButtonColor = [UIColor blackColor];
        [picker setIsRangePickerView:YES];
        [picker setTitlesForComponents:@[@[@"向Ta收取"],@[@"100", @"95",@"90",@"85",@"80",@"75",@"70",@"65",@"60",@"55",@"50",@"45",@"40",@"35",@"30",@"25",@"20",@"15",@"10"],@[@"撩币/分钟"]]];
        [picker show];
    }
    
}
#pragma mark - IQActionSheetPickerViewDelegate

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles
{
        self.strCM = [titles objectAtIndex:1];
        self.money.text = [NSString stringWithFormat:@"%@撩币/分钟", self.strCM];
    
    [HLLoginManager setPrice:[self.strCM intValue] token:[_userDefaults objectForKey:@"token"] success:^(NSDictionary *info) {
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        NSLog(@"----------------%@",info);
        if (resultCode == SUCCESS) {
            [_userDefaults setObject:self.strCM forKey:@"price"];
            [SVProgressHUD showInfoWithStatus:@"设置成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:info[@"resultMsg"]];

        }

    } failure:^(NSError *error) {
        NSLog(@"11111111111%@",error);
    }];
}
@end
