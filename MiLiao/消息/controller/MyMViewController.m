//
//  MyMViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "MyMViewController.h"
#import "MyMTableViewCell.h"
#import "Mmodel.h"
@interface MyMViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView * tableView;
@property (strong, nonatomic) NSMutableArray *modelArray;
@property (nonatomic, strong) Mmodel *mmodel;

@end

@implementation MyMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"我的撩币"];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"MyMTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyMTableViewCell"];
    //    double systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
    //    if (systemVersion < 11) {
    //        self.tableView.contentInset = UIEdgeInsetsMake(32, 0, 0, 0);
    //    }
    [self.view addSubview:tableView];
}
//获取数据
- (void)loadData
{
    [HLLoginManager getUserMoneyInfotoken:[YZCurrentUserModel sharedYZCurrentUserModel].token success:^(NSDictionary *info) {
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS)
        {
            self.modelArray = [Mmodel mj_objectArrayWithKeyValuesArray:info[@"data"]];
           [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:info[@"resultMsg"]];

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
    static NSString *Identifier =@"MyMTableViewCell";
    MyMTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:Identifier];
    self.mmodel = self.modelArray[indexPath.row];
    cell.model =  self.mmodel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 294;
}
@end
