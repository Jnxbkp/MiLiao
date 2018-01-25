//
//  MyVideoViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "MyVideoViewController.h"
#import "MLDiscoverListCollectionViewCell.h"
#import "MainMananger.h"

#define itemWidth                 (WIDTH-32)/2
#define itemHeight                 itemWidth*16/9
@interface MyVideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    NSUserDefaults  *_userDefaults;
}
@property (nonatomic, assign) BOOL fingerIsTouch;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSString *pageNum;
@end
static NSString * const reuseIdentifier = @"Cell";
@implementation MyVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"小视频"];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArr = [NSMutableArray array];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _pageNum = @"1";
    [self netGetUserVideoListHeader:nil footer:nil];
    [self setupSubViews];

}
- (void)setupSubViews
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-ML_TopHeight) collectionViewLayout:layout];
    _collectionView.backgroundColor = Color242;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing:)];
    _collectionView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMore:)];
    _collectionView.mj_footer = footer;
    _collectionView.mj_footer.hidden = YES;
    
    [self.collectionView registerClass:[MLDiscoverListCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_collectionView];
}
//主播视频列表
- (void)netGetUserVideoListHeader:(MJRefreshNormalHeader *)header footer:(MJRefreshAutoNormalFooter *)footer {
    [MainMananger NetGetgetVideoListById:[_userDefaults objectForKey:@"id"] token:[_userDefaults objectForKey:@"token"] pageNumber:_pageNum pageSize:PAGESIZE success:^(NSDictionary *info) {
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            NSArray *arr = [[info objectForKey:@"data"] objectForKey:@"userList"];
            _pageNum = [NSString stringWithFormat:@"%lu",[_pageNum integerValue] +1];
            if (header == nil && footer == nil) {//首次请求
                for (int i = 0; i < arr.count; i ++) {
                    NSDictionary *dic = arr[i];
                    [_dataArr addObject:dic];
                }
                
            } else if (header != nil) {
                [header endRefreshing];
                _dataArr = [NSMutableArray array];
                for (int i = 0; i < arr.count; i ++) {
                    NSDictionary *dic = arr[i];
                    [_dataArr addObject:dic];
                }
                if (_dataArr.count > 0) {
                    _collectionView.mj_footer.hidden = NO;
                }
            } else if (footer != nil) {
                [footer endRefreshing];
                for (int i = 0; i < arr.count; i ++) {
                    NSDictionary *dic = arr[i];
                    [_dataArr addObject:dic];
                }
                if (arr.count <= 0) {
                    [footer endRefreshingWithNoMoreData];
                }
            }
            [_collectionView reloadData];
        } else {
            if (header != nil) {
                [header endRefreshing];
            } else if (footer != nil) {
                [footer endRefreshing];
            }
        }
    } failure:^(NSError *error) {
        if (header != nil) {
            [header endRefreshing];
        } else if (footer != nil) {
            [footer endRefreshing];
        }
        NSLog(@"error%@",error);
    }];
    
}
#pragma mark refresh
- (void)headerRefreshing:(MJRefreshNormalHeader *)header {
    _pageNum = @"1";
     _collectionView.mj_footer.state = MJRefreshStateIdle;
    [self netGetUserVideoListHeader:header footer:nil];
}
#pragma mark - 加载更多
- (void)footerLoadMore:(MJRefreshAutoNormalFooter *)footer {
    [self netGetUserVideoListHeader:nil footer:footer];
}
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return _dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MLDiscoverListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    CGSize likeSize = [NSStringSize getNSStringHeight:[NSString stringWithFormat:@"%@",[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"videoUp"]] Font:12.0];
    cell.likeNumLabel.frame = CGRectMake(itemWidth-likeSize.width-12, cell.timeLabel.frame.origin.y, likeSize.width, 12);
    cell.iconImageView.frame = CGRectMake(cell.likeNumLabel.frame.origin.x-18, cell.timeLabel.frame.origin.y+1.5, 10, 9);
    [cell.mainImgageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"videoUrl"]]] placeholderImage:[UIImage imageNamed:@"aaa"]];
    cell.messageLabel.text = [[_dataArr objectAtIndex:indexPath.row] objectForKey:@"videoName"];;
    cell.likeNumLabel.text = [NSString stringWithFormat:@"%@",[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"videoUp"]];
    NSString *timeStampString  = [NSString stringWithFormat:@"%@",[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"updateDate"]];
    NSString *timeStr = [ToolObject timeBeforeInfoWithString:[timeStampString doubleValue]];
    cell.timeLabel.text = timeStr;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger currentPage = self.magicController.currentPage;
    NSLog(@"==didSelectItemAtIndexPath%@ \n current page is: %ld==", indexPath, (long)currentPage);
    //    VTDetailViewController *detailViewController = [[VTDetailViewController alloc] init];
    //    detailViewController.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:detailViewController animated:YES];
}
//UICollectionView item size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(itemWidth, itemHeight);
    
}
//UICollectionView  margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 12, 0, 12);
}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

@end
