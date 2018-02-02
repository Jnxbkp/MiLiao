//
//  GoPayTableViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/13.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "GoPayTableViewController.h"
#import <Masonry.h>
#import "MyQianBaoTableViewCell.h"
#import "zhifuTableViewCell.h"//支付方式新
#import "PayWebViewController.h"
@interface GoPayTableViewController ()
@property(nonatomic,assign)BOOL boolBtnSelected;
@property (nonatomic,strong) NSArray *moneyAry;

@end

@implementation GoPayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:ML_Color(255, 255, 255, 1)};
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"充值"];
    self.moneyAry = [[NSArray alloc]init];
     self.moneyAry = @[@"20",@"100",@"200",@"400",@"1000",@"2000",@"4000",@"10000",@"20000"];
    self.money = @"20";
    [self registerCell];

}

- (void)registerCell {
    UIView *footView=[UIView new];
    footView.frame=CGRectMake(0, 0, WIDTH, 100);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, WIDTH-10, 21)];
    label.text = @"注：充值金额不可退还和提现";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = rgba(153, 153, 153, 1);
    [footView addSubview:label];
    self.tableView.tableFooterView=footView;

    //选择金额
    [self.tableView registerNib:[UINib nibWithNibName:@"MyQianBaoTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyQianBaoTableViewCell"];
    //支付方式
    [self.tableView registerNib:[UINib nibWithNibName:@"zhifuTableViewCell" bundle:nil] forCellReuseIdentifier:@"zhifuTableViewCell"];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MyQianBaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyQianBaoTableViewCell" forIndexPath:indexPath];
        cell.selectedBlock = ^(NSInteger index) {
            if (index<=self.moneyAry.count) {
                self.money = [NSString stringWithFormat:@"%@",self.moneyAry[index]];
                NSLog(@"金额金额金额~~~~%@",self.money);
//                self.Id = [NSString stringWithFormat:@"%@",self.dicAry[index][@"id"]];
            }
        };
        
        return cell;
    }else{
        static NSString *Identifier =@"zhifuTableViewCell";
        zhifuTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:Identifier];
//        cell.index = indexPath.row;
//        cell.tuijian.hidden = YES;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//选择金额
        
    }
    if (indexPath.section == 1) {
        //支付宝
//            self.type = 1;
        PayWebViewController *payWeb = [[PayWebViewController alloc]init];
        payWeb.money = self.money;
        [self.navigationController pushViewController:payWeb animated:YES];
        }
    
    
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 270;
    }else{
        return 44;
        
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        sectionView.backgroundColor = ML_Color(248, 248, 248, 1);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 180, 25)];
        label.text = @"请选择支付方式";
        label.textColor = ML_Color(97, 97, 97, 1);
        label.font = [UIFont systemFontOfSize:15];
        [sectionView addSubview:label];
        return sectionView;

    }
    return nil;
}
///分区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return 0;
        
    }else{
        return 40;
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //去掉UItableview headerview黏性(sticky)
    if (scrollView == self.tableView){
        CGFloat sectionHeaderHeight = 45 + 10;
        if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
@end
