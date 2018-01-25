//
//  xiangViewController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/3.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "HLZiLiaoController.h"
#import "MLDetailTableViewCell.h"



@interface HLZiLiaoController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate> {
    NSUserDefaults  *_userDefaults;
}
@property (nonatomic, assign) BOOL fingerIsTouch;
/** 用来显示的假数据 */
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation HLZiLiaoController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    // Do any additional setup after loading the view.
    //get love num
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationWomanData:) name:@"getWomanInformation" object:nil];
    //下拉刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationWomanData:) name:@"refreshWomanData" object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.data = [NSMutableArray arrayWithObjects:@"接听率",@"身高",@"体重",@"星座",@"城市", nil];
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), HEIGHT-50-50) style:UITableViewStylePlain];
    if ([[_userDefaults objectForKey:@"isBigV"]isEqualToString:@"3"]) {
        _tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), HEIGHT-50-ML_TopHeight);
    }
  
    if (UI_IS_IPHONEX) {
        if ([[_userDefaults objectForKey:@"isBigV"]isEqualToString:@"3"]) {
            _tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), HEIGHT-50-ML_TopHeight-34);
        }
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.scrollsToTop = NO;
     _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}


#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return self.data.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 82+48;
    } else {
        return 38;
    }
    
}
//tableview头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 48;
    }
    return 0;
    
}

//tableview 头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];

    
    if (section == 1) {
        UIView  *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 14, 3, 20)];
        titleView.backgroundColor = ML_Color(250, 114, 152, 1);
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 17, WIDTH-24, 14)];
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        titleLabel.textColor = Color75;
        titleLabel.text = @"个人资料";
        
        [headView addSubview:titleView];
        [headView addSubview:titleLabel];
    } else {
        
    }
    
    return headView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = nil;
        static NSString *cellID = @"cell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        for(id subView in cell.contentView.subviews){
            if(subView){
                [subView removeFromSuperview];
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView  *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 14, 3, 20)];
        titleView.backgroundColor = ML_Color(250, 114, 152, 1);
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 17, WIDTH-24, 14)];
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        titleLabel.textColor = Color75;
        titleLabel.text = @"印象标签";
        
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 6+48, 60, 12)];
        myLabel.text = @"自评形象";
        myLabel.textColor = ML_Color(127, 127, 127, 1);
        myLabel.font = [UIFont systemFontOfSize:13.0];
        
        UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 42+48, 60, 12)];
        userLabel.text = @"用户印象";
        userLabel.textColor = ML_Color(127, 127, 127, 1);
        userLabel.font = [UIFont systemFontOfSize:13.0];
        
        ItemsView *itemView = [[ItemsView alloc]init];
        [itemView setItemsDicArr:_womanModel.userTags];
        itemView.frame = CGRectMake(WIDTH-itemView.itemsViewWidth-12, 48, itemView.itemsViewWidth, 24);
        
        ItemsView *itemView1 = [[ItemsView alloc]init];
        [itemView1 setItemsDicArr:_womanModel.evaluationList];
        itemView1.frame = CGRectMake(WIDTH-itemView1.itemsViewWidth-12, 36+48, itemView1.itemsViewWidth, 24);
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 74+48, WIDTH, 8)];
        lineLabel.backgroundColor = Color242;
        
        
        [cell.contentView addSubview:titleView];
        [cell.contentView addSubview:titleLabel];
        [cell.contentView addSubview:myLabel];
        [cell.contentView addSubview:userLabel];
        [cell.contentView addSubview:itemView];
        [cell.contentView addSubview:itemView1];
        [cell.contentView addSubview:lineLabel];
        
        return cell;
        
    } else {
        MLDetailTableViewCell *cell = nil;
        static NSString *cellID = @"cell.Identifier";
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[MLDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = [_data objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            NSString *jtlStr = [NSString stringWithFormat:@"%@ %%",_womanModel.jtl];
            if ([jtlStr isEqualToString:@"(null)"]) {
                cell.messageLabel.text = [NSString stringWithFormat:@"100 %%"];
            } else {
                cell.messageLabel.text = [NSString stringWithFormat:@"%@ %%",_womanModel.jtl];
            }
            
        } else if (indexPath.row == 1) {
            cell.messageLabel.text = [NSString stringWithFormat:@"%@ cm",_womanModel.height];
        } else if (indexPath.row == 2) {
            cell.messageLabel.text = [NSString stringWithFormat:@"%@ kg",_womanModel.weight];
        } else if (indexPath.row == 3) {
            cell.messageLabel.text = _womanModel.constellation;
        } else {
            cell.messageLabel.text = _womanModel.city;
        }
        return cell;
    }
    
}
#pragma mark - 通知得到主播数据
- (void)notificationWomanData:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    _womanModel = [dic objectForKey:@"womanModel"];
    [self.tableView reloadData];
}
#pragma mark UIScrollView
//判断屏幕触碰状态
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
        NSLog(@"接触屏幕");
    self.fingerIsTouch = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
        NSLog(@"离开屏幕");
    self.fingerIsTouch = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        //        if (!self.fingerIsTouch) {//这里的作用是在手指离开屏幕后也不让显示主视图，具体可以自己看看效果
        //            return;
        //        }
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];//到顶通知父视图改变状态
    }
    self.tableView.showsVerticalScrollIndicator = _vcCanScroll?YES:NO;
}


#pragma mark LazyLoad

+ (UIColor*) randomColor{
    NSInteger r = arc4random() % 255;
    NSInteger g = arc4random() % 255;
    NSInteger b = arc4random() % 255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

- (NSMutableArray *)data
{
    if (!_data) {
        self.data = [NSMutableArray arrayWithObjects:@"接听率",@"身高",@"体重",@"星座",@"城市", nil];
        //        for (int i = 0; i<10; i++) {
        //            [self.data addObject:RandomData];
        //        }
    }
    return _data;
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
