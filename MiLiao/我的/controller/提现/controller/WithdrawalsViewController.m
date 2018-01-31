//
//  WithdrawalsViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "WithdrawalsViewController.h"
#import "tiXainTableViewCell.h"
#import "headerView.h"
#import "CashMingXiViewController.h"
#import "administrateAccountViewController.h"
@interface WithdrawalsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSUserDefaults *_userDefaults;
    
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSNumber * amount;
@property (nonatomic, strong) NSDictionary * dict;
@property (nonatomic, strong) NSString * wirthdrawAccount;
@property (nonatomic, strong) NSString * wirthdrawName;
@end

@implementation WithdrawalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:ML_Color(255, 255, 255, 1)};
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:ML_Color(255, 255, 255, 1)};
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _dict = [[NSDictionary alloc]init];
    self.title = @"提现";
    [self setTableView];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:ML_Color(250,114,152,1)] forBarMetrics:UIBarMetricsDefault];
    [self loadData];

    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NavigationBarBackgroundColor] forBarMetrics:UIBarMetricsDefault];

    
}
- (void)loadData
{
    [HLLoginManager getWalletInfotoken:[_userDefaults objectForKey:@"token"] success:^(NSDictionary *info) {
        NSLog(@"%@",info);
        self.dict = info[@"data"];
        self.wirthdrawAccount = self.dict[@"wirthdrawAccount"];
        self.wirthdrawName = self.dict[@"wirthdrawName"];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)setTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-ML_TopHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = ML_Color(241, 241, 241, 1);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"tiXainTableViewCell" bundle:nil] forCellReuseIdentifier:@"tiXainTableViewCell"];
    headerView *header = [[NSBundle mainBundle] loadNibNamed:
                          @"headerView" owner:nil options:nil ].lastObject;
    
    __weak typeof(self) weakSelf = self;
    //block回调
    header.sureBlock = ^{
        //确定按钮
        [weakSelf tiXianLoad];
    };
    header.mingxiBlock = ^{
        //查看明细
        [self.view endEditing:YES];
        CashMingXiViewController *cashVC = [[CashMingXiViewController alloc]init];
        [self.navigationController pushViewController:cashVC animated:YES];
    };
    header.textFiledClick = ^(NSString *str) {
        //输入金额
        self.amount = @([str integerValue]);
        NSLog(@"输入的提现金额是:%@",self.amount);
    };
   header.Mmoney.text = [NSString stringWithFormat:@"%@",self.Mmoney];
    header.money.text = [NSString stringWithFormat:@"%@",self.money];

    self.tableView.tableHeaderView = header;
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH*0.637)];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH*0.637)];
    imageV.image = [UIImage imageNamed:@"组1"];
    [footView addSubview:imageV];
    self.tableView.tableFooterView = footView;
    [self.view addSubview:self.tableView];

}
- (void)tiXianLoad
{
    [self.view endEditing:YES];
    if ([self.amount intValue] >= 100){
        NSString *collectionAccount = [NSString stringWithFormat:@"%@",self.dict[@"wirthdrawAccount"]];
        NSString *collectionName = [NSString stringWithFormat:@"%@",self.dict[@"wirthdrawName"]];
        
        if ([collectionAccount isEqualToString:@""] || [collectionName isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"请添加提现账户"];
        }else{
            [HLLoginManager saveWirthdrawInfotoken:[_userDefaults objectForKey:@"token"] amount:self.amount collectionAccount:collectionAccount collectionName:collectionName mobile:[_userDefaults objectForKey:@"username"] remark:@"" success:^(NSDictionary *info) {
                NSLog(@"%@",info);
                NSInteger resultCode = [info[@"resultCode"] integerValue];
                if (resultCode == SUCCESS) {
                    [SVProgressHUD showSuccessWithStatus:@"提现成功"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:info[@"resultMsg"]];
                    
                }
                
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"网络异常"];
            }];
        }
       
    }else{
        [SVProgressHUD showErrorWithStatus:@"满100可提现"];
    }
  
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    __weak typeof(self) weakSelf = self;

    tiXainTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tiXainTableViewCell"forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.wirthdrawAccount.length>0) {
        cell.zhanghu.text = [NSString stringWithFormat:@"提现账户(支付宝):  %@",self.dict[@"wirthdrawAccount"]];

    }else{
        cell.zhanghu.text =@"提现账户(支付宝): ";

    }
    if (self.wirthdrawName.length>0) {
       cell.zhanghuName.text = [NSString stringWithFormat:@"账户名称(支付宝):  %@",self.dict[@"wirthdrawName"]];
    }else{
        cell.zhanghuName.text = @"账户名称(支付宝):";


    }

    cell.sureBlock = ^{
        //管理提现账户
        administrateAccountViewController *account = [[administrateAccountViewController alloc]init];
        [weakSelf.navigationController pushViewController:account animated:YES];
    };

    return cell;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 176;
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
@end
