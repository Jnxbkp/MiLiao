//
//  MyCallViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "MyCallViewController.h"
#import "messageCell.h"
#import "CallListModel.h"
#import "RongCallKit.h"
#import <RongIMKit/RongIMKit.h>
#import "UserInfoNet.h"
#import "GoPayTableViewController.h"
#import "UserCallPowerModel.h"
#import "EvaluateVideoViewController.h"//评价

@interface MyCallViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView * tableView;
@property (strong, nonatomic) NSMutableArray *modelArray;

@end

@implementation MyCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"我的通话"];
   
    [self setTableview];
    [self loadData];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)setTableview
{
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-ML_TopHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = ML_Color(230, 230, 230, 1);

    self.tableView = tableView;
    [self.tableView registerNib:[UINib nibWithNibName:@"messageCell" bundle:nil] forCellReuseIdentifier:@"messageCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    double systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
//    if (systemVersion < 11) {
//        self.tableView.contentInset = UIEdgeInsetsMake(32, 0, 0, 0);
//    }
    [self.view addSubview:tableView];
}
//获取数据
- (void)loadData
{
    [HLLoginManager NetGetgetCallInfoListToken:[YZCurrentUserModel sharedYZCurrentUserModel].token success:^(NSDictionary *info) {
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            self.modelArray = [CallListModel mj_objectArrayWithKeyValuesArray:info[@"data"]];
            [self.tableView reloadData];

        }
    } failure:^(NSError *error) {
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.modelArray.count;
}
//头部视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *Identifier =@"messageCell";
    messageCell *cell =[tableView dequeueReusableCellWithIdentifier:Identifier];
    self.callListModel = self.modelArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model =  self.callListModel;

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 64;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakSelf = self;
    self.callListModel = self.modelArray[indexPath.row];
    
    //普通用户
    if ([[YZCurrentUserModel sharedYZCurrentUserModel].roleType isEqualToString:RoleTypeCommon]) {
        [UserInfoNet canCall:self.callListModel.anchorAccount result:^(RequestState success, id model, NSInteger code, NSString *msg) {
            if (success) {
                
                UserCallPowerModel *callPower = (UserCallPowerModel *)model;
                MoneyEnoughType moneyType = callPower.typeCode;
                //余额不充足 不能聊天 可以视频
                if (moneyType == MoneyEnoughTypeNotEnough) {
                    [self showPayAlertController:^{
                        //去充值
                        //                    GoPayTableViewController *goPayVC = [[GoPayTableViewController alloc]init];
                        //                    [weakSelf.navigationController pushViewController:goPayVC animated:YES];
                    } continueCall:^{
                        //继续视频
                        [weakSelf videoCall];
                    }];
                }
                
                //余额充足 既能聊天 有能视频
                if (moneyType == MoneyEnoughTypeEnough) {
                    [self videoCall];
                }
                
                //余额为0
                if (moneyType == MoneyEnoughTypeEmpty) {
                    [self showPayAlertController:^{
                        
                    }];
                }
                
            } else {
                [SVProgressHUD showErrorWithStatus:msg];
            }
        }];
    } else {
         [self videoCall];
    }
    
    
}
///视频聊天
- (void)videoCall {
    [[RCCall sharedRCCall] startSingleVideoCallToCallListUser:self.callListModel];
}
///去充值
- (void)showPayAlertController:(void(^)(void))pay {
    __weak typeof(self) weakSelf = self;

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您的M不足" message:@"是否立即充值" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *payAction = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        GoPayTableViewController *goPayVC = [[GoPayTableViewController alloc]init];
        [weakSelf.navigationController pushViewController:goPayVC animated:YES];
        
        !pay?:pay();
    }];
    [payAction setValue:[UIColor orangeColor] forKey:@"titleTextColor"];
    [alertController addAction:cancleAction];
    [alertController addAction:payAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
///弹出是否充值的alert
- (void)showPayAlertController:(void(^)(void))pay continueCall:(void(^)(void))continueCall {
    __weak typeof(self) weakSelf = self;

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您的M不足不够与大V通话5分钟" message:@"是否去充值" preferredStyle:UIAlertControllerStyleAlert];
    //继续通话
    UIAlertAction *continueCallAction = [UIAlertAction actionWithTitle:@"继续通话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !continueCall?:continueCall();
    }];
    
    //充值
    UIAlertAction *payAction = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        GoPayTableViewController *goPayVC = [[GoPayTableViewController alloc]init];
        [weakSelf.navigationController pushViewController:goPayVC animated:YES];
        !pay?:pay();
    }];
    [payAction setValue:[UIColor orangeColor] forKey:@"titleTextColor"];
    
    [alertController addAction:continueCallAction];
    [alertController addAction:payAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
