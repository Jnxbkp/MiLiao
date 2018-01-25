//
//  IncomeMoneyViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "IncomeMoneyViewController.h"
#import "shourucell.h"
#import "shouruModel.h"

@interface IncomeMoneyViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSUserDefaults *_userDefaults;
    
}
@property (nonatomic, weak) UITableView * tableView;
@property (strong, nonatomic) NSMutableArray *modelArray;
@property (assign, nonatomic) NSInteger pageNumber;
@property (assign, nonatomic) NSInteger pageSize;
@property (strong, nonatomic) NSDictionary *parameters;
@property (nonatomic, strong) shouruModel *shouruModel;

@end

@implementation IncomeMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"收入明细"];
    self.view.backgroundColor = ML_Color(248, 248, 248, 1);
    _userDefaults = [NSUserDefaults standardUserDefaults];
    [self setTableview];
    [self creatMJRefresh];
//    [self loadData];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)creatMJRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
}
- (void)loadData
{
    self.pageNumber = 1;
    self.pageSize = 1;
    NSString *pageN =  [NSString stringWithFormat: @"%ld",  (long)self.pageNumber];
    NSString *pageS =  [NSString stringWithFormat: @"%ld",  self.pageSize];
    [self.tableView.mj_header endRefreshing];
    [HLLoginManager incomeDetailstoken:[_userDefaults objectForKey:@"token"] pageNumber:pageN pageSize:pageS  success:^(NSDictionary *info) {
        [self.tableView.mj_header endRefreshing];
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            self.modelArray = [shouruModel mj_objectArrayWithKeyValuesArray:info[@"data"]];
            [self.tableView reloadData];

        }else{
            [SVProgressHUD showErrorWithStatus:info[@"resultMsg"]];

        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)getMoreData
{
    [self.tableView.mj_footer endRefreshing];
    self.pageNumber++;
    self.pageSize++;
    NSString *pageN =  [NSString stringWithFormat: @"%ld",  (long)self.pageNumber];
    NSString *pageS =  [NSString stringWithFormat: @"%ld",  self.pageSize];
    [HLLoginManager incomeDetailstoken:[_userDefaults objectForKey:@"token"] pageNumber:pageN pageSize:pageS success:^(NSDictionary *info) {
        [self.tableView.mj_header endRefreshing];
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            self.modelArray = [shouruModel mj_objectArrayWithKeyValuesArray:info[@"data"]];
            [self.tableView reloadData];

        }
    } failure:^(NSError *error) {

    }];
}
- (void)setTableview
{
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-ML_TopHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = ML_Color(230, 230, 230, 1);
    self.tableView = tableView;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"shourucell" bundle:nil] forCellReuseIdentifier:@"shourucell"];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
    self.tableView.tableFooterView = v;
    [self.view addSubview:self.tableView];
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
    static NSString *Identifier =@"shourucell";
    shourucell *cell =[tableView dequeueReusableCellWithIdentifier:Identifier];
    self.shouruModel = self.modelArray[indexPath.row];
    cell.model = self.shouruModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 49;
}
@end
