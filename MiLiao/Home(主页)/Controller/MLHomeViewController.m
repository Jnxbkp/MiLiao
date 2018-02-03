//
//  MLHomeViewController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2017/12/29.
//  Copyright © 2017年 Jarvan-zhang. All rights reserved.
//

#import "MLHomeViewController.h"
#import "MLSearchViewController.h"
#import "MLHomeListTableViewCell.h"
#import "MainMananger.h"
#import "FSBaseViewController.h"

#import "VideoUserModel.h"//用户模型
#import "ReportView.h"
#define choseButtonTag          1000
#define tabHight   HEIGHT-ML_TopHeight-35-ML_TabBarHeight

#define newStr                     @"new"
#define careStr                    @"care"
#define recommandStr               @"recommand"
#define page                       @"1"

static NSString *const bigIdentifer = @"bigCell";
@interface MLHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate> {
    
    NSUserDefaults      *_userDefaults;
    UICollectionView    *_bigCollectionView;
    UITableView         *_newTabelView;
    UITableView         *_careTabelView;
    UITableView         *_recommandTabelView;
    NSMutableArray      *_recommandList;
    NSMutableArray      *_careList;
    NSMutableArray      *_newsList;
    UIView              *_downView;
    
    NSString            *_selectStr;
    UIView              *_choseView;
    UIButton            *_newButton;
    UIButton            *_recommandButton;
    UIButton            *_careButton;
    
    NSString            *_newPage; //加载的页
    NSString            *_carePage;
    NSString            *_recommandPage;
    NSDictionary      *infoDic;
    
}
///模型数组
@property (nonatomic, strong) NSArray *modelArray;

@end

@implementation MLHomeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:Color255 size:CGSizeMake(WIDTH, ML_TopHeight)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, WIDTH-10, 44)];
    UIButton *searchBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBut setBackgroundImage:[UIImage imageNamed:@"sousuokuang"] forState:UIControlStateNormal];
    [searchBut setBackgroundImage:[UIImage imageNamed:@"sousuokuang"] forState:UIControlStateHighlighted];
    searchBut.frame = CGRectMake(19, 10, WIDTH-48, 28);
    
    [searchBut addTarget:self action:@selector(pushSearchVC:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:searchBut];
    self.navigationItem.titleView = titleView;
    

    //foucusStatusChange
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foucusStatusChange) name:@"foucusStatusChange" object:nil];
    
    ListenNotificationName_Func(@"lahei", @selector(notificationFunc:));
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _careList = [NSMutableArray array];
    _newsList = [NSMutableArray array];
    _recommandList = [NSMutableArray array];
    _selectStr = recommandStr;
    _newPage = @"1";
    _carePage = @"1";
    _recommandPage = @"1";
    
    NSLog(@"-------------%@",[_userDefaults objectForKey:@"token"]);
    [self addTableChoseView];
    
    UICollectionViewFlowLayout *dealLayout = [[UICollectionViewFlowLayout alloc]init];
    dealLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    dealLayout.minimumLineSpacing = 0;
    dealLayout.minimumInteritemSpacing = 0;
    _bigCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 35, WIDTH, tabHight) collectionViewLayout:dealLayout];
    [_bigCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:bigIdentifer];
    
    _bigCollectionView.showsVerticalScrollIndicator = NO;
    _bigCollectionView.showsHorizontalScrollIndicator = NO;
    _bigCollectionView.delegate = self;
    _bigCollectionView.pagingEnabled = YES;
    _bigCollectionView.scrollEnabled = YES;
    _bigCollectionView.dataSource = self;
    _bigCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_bigCollectionView];
  
     [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [self netGetListPageSelectStr:_selectStr pageNumber:_recommandPage header:nil footer:nil];
}

- (void)notificationFunc:(NSNotification *)notification {
    if ([notification.name isEqualToString:@"lahei"]) {
        NSDictionary *dict = notification.userInfo;
        NSString *laheiID = dict[@"laheiID"];
        
        NSMutableArray *laheiAry = [[NSMutableArray alloc]init];
        for (VideoUserModel  *model in _recommandList) {
            NSString *str = model.ID;
            if (![str isEqualToString:laheiID]){
                [laheiAry addObject:model];
                _recommandList = laheiAry;
                
            }
        }
        [_recommandTabelView reloadData];
        NSMutableArray *laheiAry2 = [[NSMutableArray alloc]init];
        for (VideoUserModel  *model in _careList) {
            NSString *str = model.ID;
            if (![str isEqualToString:laheiID]){
                [laheiAry2 addObject:model];
                _careList = laheiAry2;
                
            }
        }
        [_careTabelView reloadData];
        NSMutableArray *laheiAry3 = [[NSMutableArray alloc]init];
        for (VideoUserModel  *model in _newsList) {
            NSString *str = model.ID;
            if (![str isEqualToString:laheiID]){
                [laheiAry3 addObject:model];
                _newsList = laheiAry3;
               
            }
        }
         [_newTabelView reloadData];
    }
}
//table选择视图
- (void)addTableChoseView {
    _choseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 35)];
    _choseView.backgroundColor = [UIColor whiteColor];
    _choseView.userInteractionEnabled = YES;
    NSArray *arr = [NSArray arrayWithObjects:@"推荐",@"关注",@"新人", nil];
    for (int i = 0; i < arr.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(WIDTH/3*i, 0, WIDTH/3, 33);
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitle:arr[i] forState:UIControlStateSelected];
        [button setTitleColor:ML_Color(77, 77, 77, 1) forState:UIControlStateNormal];
        [button setTitleColor:NavColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        button.tag = choseButtonTag+i;
        [button addTarget:self action:@selector(choseStyle:) forControlEvents:UIControlEventTouchUpInside];
        CGSize strSize = [NSStringSize getNSStringHeight:@"推荐" Font:15.0];
        if (i == 0) {
            button.selected = YES;
            _recommandButton = button;
            _downView = [[UIView alloc]initWithFrame:CGRectMake((WIDTH/3-(strSize.width+20))/2, 33, strSize.width+20, 2)];
            [_downView setBackgroundColor:NavColor];
            [_choseView addSubview:_downView];
        } else if (i == 1) {
            button.selected = NO;
            _careButton = button;
        } else if (i == 2) {
            button.selected = NO;
            _newButton = button;
        }
        [_choseView addSubview:button];
    }
    [self.view addSubview:_choseView];
}
#pragma mark - 选择种类列表
- (void)choseStyle:(UIButton *)button {
    if (button.selected == NO) {
        
        if (button.tag == choseButtonTag) {
            _recommandButton.selected = YES;
            _newButton.selected = NO;
            _careButton.selected = NO;
            _selectStr = recommandStr;
            if (_recommandList.count > 0) {
                [self recommandTabReload];
            } else {
                _recommandPage = @"1";
                [self netGetListPageSelectStr:_selectStr pageNumber:_recommandPage header:nil footer:nil];
            }
            
        } else if (button.tag == choseButtonTag+1) {
            _recommandButton.selected = NO;
            _careButton.selected = YES;
            _newButton.selected = NO;
            
            _selectStr = careStr;
            if (_careList.count > 0) {
                [self careTabReload];
            } else {
                _carePage = @"1";
                [self netGetListPageSelectStr:_selectStr pageNumber:_carePage header:nil footer:nil];
            }
            
        } else if (button.tag == choseButtonTag+2) {
            _recommandButton.selected = NO;
            _careButton.selected = NO;
            _newButton.selected = YES;
            
            _selectStr = newStr;
            if (_newsList.count > 0) {
                [self newTabReload];
            } else {
                _newPage = @"1";
                [self netGetListPageSelectStr:_selectStr pageNumber:_newPage header:nil footer:nil];
            }
        }
        CGSize strSize = [NSStringSize getNSStringHeight:@"推荐" Font:15.0];
        [UIView animateWithDuration:0.2 animations:^{
            [_downView setFrame:CGRectMake(button.frame.origin.x+(WIDTH/3-(strSize.width+20))/2, 33, strSize.width+20, 2)];
        }];
        _bigCollectionView.contentOffset = CGPointMake((button.tag-choseButtonTag)*WIDTH, 0);
    }
    
}
//请求网络接口
- (void)netGetListPageSelectStr:(NSString *)selectStr pageNumber:(NSString *)pageNumber header:(MJRefreshNormalHeader *)header footer:(MJRefreshAutoNormalFooter *)footer {
   NSLog(@"----token--%@----%@",[_userDefaults objectForKey:@"token"],pageNumber);
    [MainMananger NetGetMainListKind:selectStr token:[_userDefaults objectForKey:@"token"] pageNumber:pageNumber pageSize:PAGESIZE success:^(NSDictionary *info) {
        infoDic = info;
        NSLog(@"---success--%@",info);
        [SVProgressHUD dismiss];
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            self.modelArray = [VideoUserModel mj_objectArrayWithKeyValuesArray:info[@"data"]];
            NSLog(@"%ld", self.modelArray.count);

            if (header == nil && footer == nil) {//首次请求
                if([selectStr isEqualToString:newStr]) {
                    _newPage = [NSString stringWithFormat:@"%lu",[_newPage integerValue] +1];
                    _newsList = [self.modelArray mutableCopy];
                    
                    for (int i = 0; i < _newsList.count; i ++) {
                        VideoUserModel *model = [_newsList objectAtIndex:i];
                        NSString *str = model.ID;
                        if ([str isEqualToString:[_userDefaults objectForKey:@"laheiID"]]) {
                            
                            [_newsList removeObjectAtIndex:i];
                        }
                    }

                    [self newTabReload];
                    if (self.modelArray.count > 1) {
                        _newTabelView.mj_footer.hidden = NO;
                    }
                } else if ([selectStr isEqualToString:careStr]) {
                    _carePage = [NSString stringWithFormat:@"%lu",[_carePage integerValue] +1];
                    _careList = [self.modelArray mutableCopy];

                    for (int i = 0; i < _careList.count; i ++) {
                        VideoUserModel *model = [_careList objectAtIndex:i];
                        NSString *str = model.ID;
                        if ([str isEqualToString:[_userDefaults objectForKey:@"laheiID"]]) {
                            
                            [_careList removeObjectAtIndex:i];
                        }
                    }
                    [self careTabReload];
                    if (self.modelArray.count > 1) {
                        _careTabelView.mj_footer.hidden = NO;
                    } else if (self.modelArray.count == 0) {
                        _careTabelView.mj_footer.hidden = YES;
                        [self careTabReload];
                    }
                } else {
                    _recommandPage = [NSString stringWithFormat:@"%lu",[_recommandPage integerValue] +1];
                    _recommandList = [self.modelArray mutableCopy];
                    
                    for (int i = 0; i < _recommandList.count; i ++) {
                        VideoUserModel *model = [_recommandList objectAtIndex:i];
                        NSString *str = model.ID;
                        if ([str isEqualToString:[_userDefaults objectForKey:@"laheiID"]]) {
                            
                            [_recommandList removeObjectAtIndex:i];
                        }
                    }
                    [self recommandTabReload];
                    
                    if (self.modelArray.count > 1) {
                        _recommandTabelView.mj_footer.hidden = NO;
                    }
                }
            } else if (header == nil && footer != nil) {//加载
                [footer endRefreshing];
                if([selectStr isEqualToString:newStr]) {
                    _newPage = [NSString stringWithFormat:@"%lu",[_newPage integerValue] +1];
                    [_newsList addObjectsFromArray:[self.modelArray mutableCopy]];
                    
                    for (int i = 0; i < _newsList.count; i ++) {
                        VideoUserModel *model = [_newsList objectAtIndex:i];
                        NSString *str = model.ID;
                        if ([str isEqualToString:[_userDefaults objectForKey:@"laheiID"]]) {
                            
                            [_newsList removeObjectAtIndex:i];
                        }
                    }
                    [self newTabReload];
                    
                    if (self.modelArray.count <= 0) {
                        [footer endRefreshingWithNoMoreData];
                    }
                } else if ([selectStr isEqualToString:careStr]) {
                    _carePage = [NSString stringWithFormat:@"%lu",[_carePage integerValue] +1];
                    [_careList addObjectsFromArray:[self.modelArray mutableCopy]];
                    
                    for (int i = 0; i < _careList.count; i ++) {
                        VideoUserModel *model = [_careList objectAtIndex:i];
                        NSString *str = model.ID;
                        if ([str isEqualToString:[_userDefaults objectForKey:@"laheiID"]]) {
                            
                            [_careList removeObjectAtIndex:i];
                        }
                    }
                    [self careTabReload];
                    
                    if (self.modelArray.count <= 0) {
                        [footer endRefreshingWithNoMoreData];
                    }
                } else {
                    _recommandPage = [NSString stringWithFormat:@"%lu",[_recommandPage integerValue] +1];
                    [_recommandList addObjectsFromArray:[self.modelArray mutableCopy]];
                  
                    for (int i = 0; i < _recommandList.count; i ++) {
                        VideoUserModel *model = [_recommandList objectAtIndex:i];
                        NSString *str = model.ID;
                        if ([str isEqualToString:[_userDefaults objectForKey:@"laheiID"]]) {
                            
                            [_recommandList removeObjectAtIndex:i];
                        }
                    }
                    [self recommandTabReload];
                    
                    if (self.modelArray.count <= 0) {
                        [footer endRefreshingWithNoMoreData];
                    }
                }
                
            } else if (header != nil && footer == nil) {//刷新
                [header endRefreshing];
                if([selectStr isEqualToString:newStr]) {
                    _newPage = [NSString stringWithFormat:@"%lu",[_newPage integerValue] +1];
                    _newsList = [NSMutableArray array];
                    _newsList = [self.modelArray mutableCopy];
                    
                    for (int i = 0; i < _newsList.count; i ++) {
                        VideoUserModel *model = [_newsList objectAtIndex:i];
                        NSString *str = model.ID;
                        if ([str isEqualToString:[_userDefaults objectForKey:@"laheiID"]]) {
                            
                            [_newsList removeObjectAtIndex:i];
                        }
                    }

                    [self newTabReload];
                    
                    if (self.modelArray.count > 1) {
                        _newTabelView.mj_footer.hidden = NO;
                    }
                } else if ([selectStr isEqualToString:careStr]) {
                    _careList = [NSMutableArray array];
                    _carePage = [NSString stringWithFormat:@"%lu",[_carePage integerValue] +1];
                    _careList = [self.modelArray mutableCopy];
                    
                   
                    for (int i = 0; i < _careList.count; i ++) {
                        VideoUserModel *model = [_careList objectAtIndex:i];
                        NSString *str = model.ID;
                        if ([str isEqualToString:[_userDefaults objectForKey:@"laheiID"]]) {
                            
                            [_careList removeObjectAtIndex:i];
                        }
                    }
                    [self careTabReload];
                    
                    if (self.modelArray.count > 1) {
                        _careTabelView.mj_footer.hidden = NO;
                    }
                } else {
                    _recommandList = [NSMutableArray array];
                    _recommandPage = [NSString stringWithFormat:@"%lu",[_recommandPage integerValue] +1];
                    _recommandList = [self.modelArray mutableCopy];
                    
                    for (int i = 0; i < _recommandList.count; i ++) {
                        VideoUserModel *model = [_recommandList objectAtIndex:i];
                        NSString *str = model.ID;
                        if ([str isEqualToString:[_userDefaults objectForKey:@"laheiID"]]) {
                            
                            [_recommandList removeObjectAtIndex:i];
                        }
                    }
                    [self recommandTabReload];
                    
                    if (self.modelArray.count > 1) {
                        _recommandTabelView.mj_footer.hidden = NO;
                    }
                }
            }
            
        } else {
            if (footer != nil) {//加载
                [footer endRefreshing];
            } else if (header != nil) {//刷新
                [header endRefreshing];
            }
            
            if (resultCode == 1004) {
                [_userDefaults setObject:@"0" forKey:@"isBigV"];
                [_userDefaults setObject:@"no" forKey:@"isLog"];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"isBigV",@"no",@"isLog", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"KSwitchRootViewControllerNotification" object:nil userInfo:dic];
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (header == nil&&footer == nil) {
            
        } else if (header == nil && footer != nil) {
            [footer endRefreshing];
        } else if (footer == nil && header != nil) {
            [header endRefreshing];
        }
        
        NSLog(@"error%@",error);
    }];
    
}

#pragma mark refresh
- (void)headerRefreshing:(MJRefreshNormalHeader *)header {
    
    if ([_selectStr isEqualToString:newStr]) {
        _newPage = page;
        _newTabelView.mj_footer.state = MJRefreshStateIdle;
        [self netGetListPageSelectStr:_selectStr pageNumber:_newPage header:header footer:nil];
    } else if ([_selectStr isEqualToString:careStr]) {
        _carePage = page;
        _careTabelView.mj_footer.state = MJRefreshStateIdle;
        [self netGetListPageSelectStr:_selectStr pageNumber:_carePage header:header footer:nil];
    } else {
        _recommandPage = page;
        _recommandTabelView.mj_footer.state = MJRefreshStateIdle;
        [self netGetListPageSelectStr:_selectStr pageNumber:_recommandPage header:header footer:nil];
    }
}
#pragma mark - 加载更多
- (void)footerLoadMore:(MJRefreshAutoNormalFooter *)footer {
    if ([_selectStr isEqualToString:newStr]) {
        [self netGetListPageSelectStr:_selectStr pageNumber:_newPage header:nil footer:footer];
    } else if ([_selectStr isEqualToString:careStr]) {
        [self netGetListPageSelectStr:_selectStr pageNumber:_carePage header:nil footer:footer];
    } else {
        [self netGetListPageSelectStr:_selectStr pageNumber:_recommandPage header:nil footer:footer];
    }
}
#pragma mark - 通知刷新关注列表
- (void)foucusStatusChange {
    [self netGetListPageSelectStr:careStr pageNumber:page header:nil footer:nil];
}
//collection section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//collectiion rows
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bigIdentifer forIndexPath:indexPath];
    for(id subView in cell.contentView.subviews){
        if(subView){
            [subView removeFromSuperview];
        }
    }
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, tabHight) style:UITableViewStylePlain];
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = WIDTH-16;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing:)];
    tableView.mj_header = header;

    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMore:)];
    tableView.mj_footer = footer;
    tableView.mj_footer.hidden = YES;
    
    if (indexPath.row == 0) {
        _recommandTabelView = tableView;
        [cell.contentView addSubview:_recommandTabelView];
    } else if (indexPath.row == 1) {
        _careTabelView = tableView;
        [cell.contentView addSubview:_careTabelView];

    } else {
        _newTabelView = tableView;
        [cell.contentView addSubview:_newTabelView];

    }
    return cell;
}

//UICollectionView item size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(WIDTH, tabHight);
}
//UICollectionView  margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
#pragma mark - tableview的组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark  tablecell每组个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio {
    if (tableView == _newTabelView) {
        return _newsList.count;
    } else if (tableView == _careTabelView) {
        return _careList.count;
    } else {
        return _recommandList.count;
    }
}
//tableview头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
//tableview尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

#pragma mark 添加tabelcell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    MLHomeListTableViewCell *cell = nil;
    static NSString *cellID = @"cell.Identifier";
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MLHomeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
  
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableArray *muArr = [NSMutableArray array];
    
    if(tableView == _newTabelView) {
        muArr = _newsList;
    } else if (tableView == _careTabelView) {
        muArr = _careList;
    } else {
        muArr = _recommandList;
    }
    VideoUserModel *videoUserModel = [muArr objectAtIndex:indexPath.row];
    cell.videoUserModel = videoUserModel;
    [cell.stateButton setStateStr:videoUserModel.status];

    //举报
    cell.reportBlock = ^{

        [self showReportSheet:videoUserModel.ID];
    };
    
    
////    [cell.mainImgageView sd_setImageWithURL:[NSURL URLWithString:[[muArr objectAtIndex:indexPath.row] objectForKey:@"posterUrl"]] placeholderImage:nil];
//    cell.mainImgageView.image = [UIImage imageNamed:@"aaa"];
//    cell.nameLabel.text = [[muArr objectAtIndex:indexPath.row] objectForKey:@"nickname"];
//    cell.messageLabel.text = [[muArr objectAtIndex:indexPath.row] objectForKey:@"personalSign"];
//    [cell.priceView setPrice:[[muArr objectAtIndex:indexPath.row] objectForKey:@"price"]];

    
    return cell;
    
}


///弹出举报拉黑sheet
- (void)showReportSheet:(NSString *)laheiID {
    UIAlertController *reportAlertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //举报
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[ReportView ReportView] show];
    }];
    
    [reportAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    
    //拉黑
    UIAlertAction *blackAction = [UIAlertAction actionWithTitle:@"拉黑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"加入黑名单" message:@"确定加入黑名单，您将不会再收到对方消息" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_userDefaults setObject:laheiID forKey:@"laheiID"];
            NSMutableArray *laheiAry = [[NSMutableArray alloc]init];
            for (VideoUserModel  *model in _recommandList) {
                NSString *str = model.ID;
                if (![str isEqualToString:laheiID]){
                    [laheiAry addObject:model];
                    _recommandList = laheiAry;
                    
                }
            }
            [_recommandTabelView reloadData];
            NSMutableArray *laheiAry2 = [[NSMutableArray alloc]init];
            for (VideoUserModel  *model in _careList) {
                NSString *str = model.ID;
                if (![str isEqualToString:laheiID]){
                    [laheiAry2 addObject:model];
                    _careList = laheiAry2;
                    
                }
            }
            [_careTabelView reloadData];
            NSMutableArray *laheiAry3 = [[NSMutableArray alloc]init];
            for (VideoUserModel  *model in _newsList) {
                NSString *str = model.ID;
                if (![str isEqualToString:laheiID]){
                    [laheiAry3 addObject:model];
                    _newsList = laheiAry3;
                    
                }
            }
            [_newTabelView reloadData];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    [blackAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [cancleAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    
    [reportAlertController addAction:reportAction];
    [reportAlertController addAction:blackAction];
    [reportAlertController addAction:cancleAction];
    
    [self presentViewController:reportAlertController animated:YES completion:nil];
}


#pragma mark 点击tablecell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FSBaseViewController *baseVC = [[FSBaseViewController alloc]init];
    VideoUserModel *videoUserModel;
    if (tableView == _newTabelView) {
        videoUserModel = [_newsList objectAtIndex:indexPath.row];
        baseVC.user_id = videoUserModel.ID;
    } else if (tableView == _careTabelView) {
        videoUserModel = [_careList objectAtIndex:indexPath.row];
        baseVC.user_id = videoUserModel.ID;
    } else {
        videoUserModel = [_recommandList objectAtIndex:indexPath.row];
        baseVC.user_id = videoUserModel.ID;

    }
    baseVC.videoUserModel = videoUserModel;
    [self.navigationController pushViewController:baseVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _bigCollectionView) {
        
        int index = scrollView.contentOffset.x/scrollView.frame.size.width;
        NSLog(@"------------>>>%d",index);
        [self choseStyle:(UIButton *)[self.view viewWithTag:choseButtonTag+index]];
    }
}

//跳转搜索页
- (void)pushSearchVC:(UIButton *)button {
    MLSearchViewController *searchVC = [[MLSearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
- (void)recommandTabReload {
    [UIView performWithoutAnimation:^{
        [_recommandTabelView reloadData];
        [_recommandTabelView beginUpdates];
        [_recommandTabelView endUpdates];
    }];
}
- (void)newTabReload {
    [UIView performWithoutAnimation:^{
        [_newTabelView reloadData];
        [_newTabelView beginUpdates];
        [_newTabelView endUpdates];
    }];
}
- (void)careTabReload {
    [UIView performWithoutAnimation:^{
        [_careTabelView reloadData];
        [_careTabelView beginUpdates];
        [_careTabelView endUpdates];
    }];
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
