//
//  PayMingXiViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "PayMingXiViewController.h"
#import "zhichuCell.h"
#import "zhichuModel.h"
@interface PayMingXiViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSUserDefaults *_userDefaults;
    
}
@property (nonatomic, weak) UITableView * tableView;
@property (strong, nonatomic) NSMutableArray *modelArray;
@property (nonatomic, strong) zhichuModel *zhichuModel;

@end

@implementation PayMingXiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"支出明细"];
    self.view.backgroundColor = ML_Color(248, 248, 248, 1);
    _userDefaults = [NSUserDefaults standardUserDefaults];

    [self loadData];

    [self setTableview];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)loadData
{
    
    [HLLoginManager expenditureDetailstoken:[_userDefaults objectForKey:@"token"] success:^(NSDictionary *info) {
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            [SVProgressHUD dismiss];
            self.modelArray = [zhichuModel mj_objectArrayWithKeyValuesArray:info[@"data"]];
            [self.tableView reloadData];
        }else{
            
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
    [SVProgressHUD showWithStatus:@"正在加载..."];

}
- (void)setTableview
{
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-ML_TopHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = ML_Color(230, 230, 230, 1);
    self.tableView = tableView;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"zhichuCell" bundle:nil] forCellReuseIdentifier:@"zhichuCell"];
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
    static NSString *Identifier =@"zhichuCell";
    zhichuCell *cell =[tableView dequeueReusableCellWithIdentifier:Identifier];
    self.zhichuModel = self.modelArray[indexPath.row];
    cell.model = self.zhichuModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 49;
}

@end
