//
//  testViewController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/3.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "MLCommentsViewController.h"
#import "CommentTableViewCell.h"
#import "MainMananger.h"

#define itemCount   @"20"

@interface MLCommentsViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSUserDefaults *_userDefaults;
    NSString    *_commentsPage;
}
@property (nonatomic, assign) BOOL fingerIsTouch;
@property (strong, nonatomic) NSMutableArray *dataArr;


@end

@implementation MLCommentsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"---%@",self.title);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //下拉刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationWomanData:) name:@"refreshWomanData" object:nil];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArr = [NSMutableArray array];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _commentsPage = @"1";
    [self NetGetBigVEvalsUsername:_videoUserModel.username pageNumber:_commentsPage pageSize:itemCount token:[_userDefaults objectForKey:@"token"] footer:nil isFresh:@"no"];
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), HEIGHT-50-ML_TopHeight-50) style:UITableViewStylePlain];
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
     _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _tableView.bounces = NO;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMore:)];
    _tableView.mj_footer = footer;
    _tableView.mj_footer.hidden = YES;
    
    [self.view addSubview:_tableView];

}

//主播评论列表
- (void)NetGetBigVEvalsUsername:(NSString *)username pageNumber:(NSString *)pageNumber pageSize:(NSString *)pageSize token:(NSString *)token footer:(MJRefreshAutoNormalFooter *)footer isFresh:(NSString *)isFresh{
    [MainMananger NetGetBigVgetEvalsUsername:username pageNumber:pageNumber pageSize:pageSize token:token success:^(NSDictionary *info) {
        NSLog(@"--------------%@",info);
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            NSArray *arr = [info objectForKey:@"data"];
            if ([isFresh isEqualToString:@"yes"]) {
                _dataArr = [NSMutableArray array];
            }
            _commentsPage = [NSString stringWithFormat:@"%lu",[_commentsPage integerValue] +1];
            for (int i = 0; i < arr.count; i ++) {
                NSDictionary *dic = arr[i];
                [_dataArr addObject:dic];
            }
            
            if (footer != nil) {//加载
                [footer endRefreshing];
                [_tableView reloadData];
                if (arr.count <= 0) {
                    [footer endRefreshingWithNoMoreData];
                }
            } else {//首次请求
                [_tableView reloadData];
                if (arr.count > 10) {
                    _tableView.mj_footer.hidden = NO;
                }
            }
        } else {
            if (footer != nil) {
                [footer endRefreshing];
            }
        }
    } failure:^(NSError *error) {
        if (footer != nil) {
            [footer endRefreshing];
        }
        NSLog(@"error%@",error);
    }];
   
}
//加载更多
- (void)footerLoadMore:(MJRefreshAutoNormalFooter *)footer {
    [self NetGetBigVEvalsUsername:_videoUserModel.username pageNumber:_commentsPage pageSize:itemCount token:[_userDefaults objectForKey:@"token"] footer:footer isFresh:@"no"];
}
#pragma mark - 通知刷新
- (void)notificationWomanData:(NSNotification *)note {
    NSLog(@"---------%@",note);
    NSDictionary *dic = note.userInfo;
    _videoUserModel = [dic objectForKey:@"womanModel"];
    _commentsPage = @"1";
    _tableView.mj_footer.state = MJRefreshStateIdle;
    [self NetGetBigVEvalsUsername:_videoUserModel.username pageNumber:_commentsPage pageSize:itemCount token:[_userDefaults objectForKey:@"token"] footer:nil isFresh:@"yes"];
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
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = nil;
    static NSString *cellID = @"cell.Identifier";
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = [_dataArr[indexPath.row] objectForKey:@"nickname"];
    [cell.userImageView sd_setImageWithURL:[_dataArr[indexPath.row] objectForKey:@"headUrl"] placeholderImage:nil];
    [cell.itemsView setItemStr:[_dataArr[indexPath.row] objectForKey:@"tagName"]];
    cell.itemsView.frame = CGRectMake(WIDTH-12-cell.itemsView.itemsViewWidth, 12, cell.itemsView.itemsViewWidth, 24);
    
    if (indexPath.row == _dataArr.count-1) {
        cell.lineLabel.hidden = YES;
    }
    return cell;
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
