//
//  CashMingXiViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "CashMingXiViewController.h"
#import "tixianTableViewCell.h"
#import "MingXiModel.h"
@interface CashMingXiViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSUserDefaults *_userDefaults;
    
}
@property (nonatomic, weak) UITableView * tableView;
@property (strong, nonatomic) NSMutableArray *modelArray;

@end

@implementation CashMingXiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"提现明细"];
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
    [HLLoginManager withdrawDetailstoken:[_userDefaults objectForKey:@"token"] success:^(NSDictionary *info) {
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            self.modelArray = [MingXiModel mj_objectArrayWithKeyValuesArray:info[@"data"]];
            [self.tableView reloadData];
//
        }else{
            
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
    [self.tableView registerNib:[UINib nibWithNibName:@"tixianTableViewCell" bundle:nil] forCellReuseIdentifier:@"tixianTableViewCell"];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
    self.tableView.tableFooterView = v;
    [self.view addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
   return self.modelArray.count;
;
}
//头部视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *Identifier =@"tixianTableViewCell";
    tixianTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:Identifier];
    self.mingXiModel = self.modelArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model =  self.mingXiModel;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 49;
}
@end
