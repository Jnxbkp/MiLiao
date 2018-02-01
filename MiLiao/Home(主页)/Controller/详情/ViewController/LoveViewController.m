//
//  LoveViewController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/16.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "LoveViewController.h"
#import "LoveTableViewCell.h"
#import "MainMananger.h"

@interface LoveViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray      *_dataArr;
    UITableView         *_tableView;
}

@end

@implementation LoveViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color242;
    [self addNavView];
    
    [self netGetBigVEvaluationListheader:nil];
    
    
    _dataArr = [NSMutableArray array];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ML_TopHeight, WIDTH, HEIGHT-ML_TopHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = Color242;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing:)];
    _tableView.mj_header = header;
    
    [self.view addSubview:_tableView];
}
- (void)addNavView {
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, ML_TopHeight)];
    navView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, ML_StatusBarHeight, WIDTH-100, 44)];
    titleLabel.text = [NSString stringWithFormat:@"%@亲密度",_womanModel.nickname];
    titleLabel.textColor = Color75;
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [navView addSubview:titleLabel];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, ML_StatusBarHeight, 50, 40);
    if (UI_IS_IPHONEX) {
        backButton.frame = CGRectMake(10, ML_StatusBarHeight, 50, 40);
    }
    [backButton setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(11, 12, 11, 25);
    [backButton addTarget:self action:@selector(backBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [navView addSubview:backButton];
    [self.view addSubview:navView];
    
    
}

//请求数据
- (void)netGetBigVEvaluationListheader:(MJRefreshNormalHeader *)header {
    [MainMananger NetGetIntimateListUsername:_womanModel.username success:^(NSDictionary *info) {
        NSLog(@"---------%@",info);
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            NSArray *arr = [info objectForKey:@"data"];
            if (header != nil) {
                _dataArr = [NSMutableArray array];
                [header endRefreshing];
            }
            for (int i = 0; i < arr.count; i ++) {
                NSDictionary *dic = arr[i];
                [_dataArr addObject:dic];
            }
            [_tableView reloadData];
        } else {
            if (header != nil) {
                [header endRefreshing];
            }
        }
    } failure:^(NSError *error) {
        if (header != nil) {
            [header endRefreshing];
        }
        NSLog(@"error%@",error);
    }];

}
#pragma mark refresh
- (void)headerRefreshing:(MJRefreshNormalHeader *)header {
    [self netGetBigVEvaluationListheader:header];
}
#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}
//tableview头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, WIDTH, 11)];
    label.text = @"对女神每消费1撩币，增加1点亲密值";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:11.0];
    label.textColor = Color155;
    
    [footView addSubview:label];
    return footView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoveTableViewCell *cell = nil;
    static NSString *cellID = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LoveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.row < 3) {
        cell.rankLabel.hidden = YES;
        cell.iconImageView.hidden = NO;
        if (indexPath.row == 0) {
            cell.iconImageView.image = [UIImage imageNamed:@"jinpai"];
        } else if (indexPath.row == 1) {
            cell.iconImageView.image = [UIImage imageNamed:@"yinpai"];
        } else {
            cell.iconImageView.image = [UIImage imageNamed:@"tongpai"];
        }
    } else {
        cell.rankLabel.hidden = NO;
        cell.iconImageView.hidden = YES;
        cell.rankLabel.text = [NSString stringWithFormat:@"NO.%lu",indexPath.row+1];
    }
    [cell.headUrlImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"headUrl"]]] placeholderImage:nil];
    cell.nameLabel.text = [[_dataArr objectAtIndex:indexPath.row] objectForKey:@"userName"];
    cell.loveLabel.text = [NSString stringWithFormat:@"亲密值%@",[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"amount"]];
    return cell;
}
- (void)backBarButtonItemAction:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
