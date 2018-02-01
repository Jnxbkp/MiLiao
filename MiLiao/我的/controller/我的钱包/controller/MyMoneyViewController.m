//
//  MyMoneyViewController.m
//  MChat
//
//  Created by apple on 2018/1/3.
//  Copyright © 2018年 Zc. All rights reserved.
//

#import "MyMoneyViewController.h"
#import "UIImage+Common.h"
#import "GoPayTableViewController.h"
#import "WithdrawalsViewController.h"
#import "CashMingXiViewController.h"
#import "PayMingXiViewController.h"
#import "IncomeMoneyViewController.h"
#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
@interface MyMoneyViewController ()<UINavigationControllerDelegate>
{
    NSUserDefaults *_userDefaults;
    
}
@property (nonatomic, strong) NSString * MMmoney;
@property (nonatomic, strong) NSString * mmoney;
@property (weak, nonatomic) IBOutlet UILabel *money;

@end

@implementation MyMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:RGBA(255, 255, 255, 1)};
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"我的钱包"];
    _userDefaults = [NSUserDefaults standardUserDefaults];
//    self.money.text = [NSString stringWithFormat:@"%@撩币",[_userDefaults objectForKey:@"balance"]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [self loadData];

}
- (void)loadData
{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [HLLoginManager getWalletInfotoken:[_userDefaults objectForKey:@"token"] success:^(NSDictionary *info) {
        NSLog(@"%@",info);
//        self.dict = info[@"data"];
        [SVProgressHUD dismiss];
        self.MMmoney = info[@"data"][@"mMoney"];
        self.mmoney = info[@"data"][@"money"];
//money
         self.money.text = [NSString stringWithFormat:@"%@撩币",info[@"data"][@"mMoney"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *bigv = [NSString stringWithFormat:@"%@",[YZCurrentUserModel sharedYZCurrentUserModel].isBigv];
    if ([bigv isEqualToString:@"3"]) {
        return 50;
    }else{
        if (indexPath.section == 0 && indexPath.row == 1) {
            return 0;
        }
        if (indexPath.section == 1 && indexPath.row == 0) {
            return 0;
        }if (indexPath.section == 1 && indexPath.row == 2) {
            return 0;
        }
    }
   
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //充值
            GoPayTableViewController *goPayVC  = [[GoPayTableViewController alloc]init];
            [self.navigationController pushViewController:goPayVC animated:YES];
        }
        if (indexPath.row == 1) {
            //提现
            WithdrawalsViewController  * WithdrawalsVC = [[WithdrawalsViewController alloc]init];
            WithdrawalsVC.Mmoney = self.MMmoney;
            WithdrawalsVC.money = self.mmoney;
            [self.navigationController pushViewController:WithdrawalsVC animated:YES];

        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //收入明细
            IncomeMoneyViewController *cashVC = [[IncomeMoneyViewController alloc]init];
            [self.navigationController pushViewController:cashVC animated:YES];
        }
        if (indexPath.row == 1) {
            //支出明细
            PayMingXiViewController *cashVC = [[PayMingXiViewController alloc]init];
            [self.navigationController pushViewController:cashVC animated:YES];
        }
        if (indexPath.row == 2) {
            //提现明细
            CashMingXiViewController *cashVC = [[CashMingXiViewController alloc]init];
            [self.navigationController pushViewController:cashVC animated:YES];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 8;
    }
    if (section == 1) {
        return 8;
    }
    return 0.01;
}
@end
