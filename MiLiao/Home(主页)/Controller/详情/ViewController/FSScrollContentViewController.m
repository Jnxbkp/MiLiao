//
//  FSScrollContentViewController.m
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "FSScrollContentViewController.h"
#import "MLDetailTableViewCell.h"
//#import <SVPullToRefresh.h>

/**
 * 随机数据
 */
//#define RandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]

@interface FSScrollContentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) BOOL fingerIsTouch;
/** 用来显示的假数据 */
@property (strong, nonatomic) NSMutableArray *data;
@end

@implementation FSScrollContentViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"---%@",self.title);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [FSScrollContentViewController randomColor];
    self.data = [NSMutableArray arrayWithObjects:@"接听率",@"身高",@"体重",@"星座",@"城市",@"接听率",@"身高",@"体重",@"星座",@"城市",@"接听率",@"身高",@"体重",@"星座",@"城市",@"接听率",@"身高",@"体重",@"星座",@"城市",@"身高",@"体重",@"星座",@"城市",@"身高",@"体重",@"星座",@"城市", nil];

    [self setupSubViews];
}

- (void)setupSubViews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
//    __weak typeof(self) weakSelf = self;
//    [self.tableView addInfiniteScrollingWithActionHandler:^{
//        [weakSelf insertRowAtBottom];
//    }];
}

//- (void)insertRowAtTop
//{
//    for (int i = 0; i<10; i++) {
//        [self.data insertObject:RandomData atIndex:0];
//    }
//    __weak UITableView *tableView = self.tableView;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [tableView reloadData];
//    });
//}
//
//- (void)insertRowAtBottom
//{
//    for (int i = 0; i<10; i++) {
//        [self.data addObject:RandomData];
//    }
//    __weak UITableView *tableView = self.tableView;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [tableView reloadData];
//        [tableView.infiniteScrollingView stopAnimating];
//    });
//}

//#pragma mark Setter
//- (void)setIsRefresh:(BOOL)isRefresh
//{
//    _isRefresh = isRefresh;
//    [self insertRowAtTop];
//}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MLDetailTableViewCell *cell = nil;
    static NSString *cellID = @"cell.Identifier";
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MLDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = [self.data objectAtIndex:indexPath.row];
    NSArray *arr = [NSArray arrayWithObjects:@"好性感",@"漂亮", nil];
    [cell.itemsView setItemsArr:arr];
    //    cell.messageLabel.text = @"lalalal";
    cell.messageLabel.hidden = YES;
    cell.itemsView.hidden = NO;
    cell.lineLabel.hidden = NO;
    //    NSLog(@"-----------------%lf",cell.itemsView.frame.size.height);
    if (indexPath.row == self.data.count-1) {
        cell.lineLabel.hidden = YES;
    }
    return cell;
}

#pragma mark UIScrollView
//判断屏幕触碰状态
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    DebugLog(@"接触屏幕");
    self.fingerIsTouch = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
//    DebugLog(@"离开屏幕");
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
        self.data = [NSMutableArray arrayWithObjects:@"接听率",@"身高",@"体重",@"星座",@"城市",@"接听率",@"身高",@"体重",@"星座",@"城市",@"接听率",@"身高",@"体重",@"星座",@"城市",@"接听率",@"身高",@"体重",@"星座",@"城市",@"身高",@"体重",@"星座",@"城市",@"身高",@"体重",@"星座",@"城市", nil];
//        for (int i = 0; i<10; i++) {
//            [self.data addObject:RandomData];
//        }
    }
    return _data;
}

@end
