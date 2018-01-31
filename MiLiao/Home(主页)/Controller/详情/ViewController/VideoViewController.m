//
//  VideoViewController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/3.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "VideoViewController.h"
#import "MLDiscoverListCollectionViewCell.h"
#import "MainMananger.h"
#import "VideoPlayViewController.h"

#define itemWidth                 (WIDTH-32)/2
#define itemHeight                 itemWidth*16/9

@interface VideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    NSUserDefaults   *_userDefaults;
    NSString        *_videoPage;
    
    DisbaseModel        *_disBaseModel;
    DisVideoModelList    *_videoModelList;
}

@property (nonatomic, assign) BOOL fingerIsTouch;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

static NSString * const reuseIdentifier = @"Cell";
@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   //下拉刷新
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationWomanData:) name:@"refreshWomanData" object:nil];
    
    _videoPage = @"1";
    self.view.backgroundColor = [UIColor whiteColor];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _dataArr = [NSMutableArray array];
    
    [self netGetUserVideoListId:_videoUserModel.ID footer:nil isFresh:@"no"];
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-50-ML_TopHeight-50) collectionViewLayout:layout];
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMore:)];
    _collectionView.mj_footer = footer;
    _collectionView.mj_footer.hidden = YES;
    
    [self.collectionView registerClass:[MLDiscoverListCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    if ([[_userDefaults objectForKey:@"isBigV"]isEqualToString:@"3"]) {
        _collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), HEIGHT-50-ML_TopHeight);
    }
    
    if (UI_IS_IPHONEX) {
        if ([[_userDefaults objectForKey:@"isBigV"]isEqualToString:@"3"]) {
            _collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), HEIGHT-50-ML_TopHeight-34);
        }
    }
    
    [self.view addSubview:_collectionView];

}
//主播视频列表
- (void)netGetUserVideoListId:(NSString *)Id footer:(MJRefreshAutoNormalFooter *)footer isFresh:(NSString *)isRefresh{
    [MainMananger NetGetgetVideoListById:Id token:[_userDefaults objectForKey:@"token"] pageNumber:_videoPage pageSize:PAGESIZE success:^(NSDictionary *info) {
        NSLog(@"------->>>video----%@",info);
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        _disBaseModel = [[DisbaseModel alloc]initWithDictionary:[info objectForKey:@"data"]];
        if (resultCode == SUCCESS) {
            NSArray *arr = [[info objectForKey:@"data"] objectForKey:@"userList"];
            _videoPage = [NSString stringWithFormat:@"%lu",[_videoPage integerValue] +1];
            if ([isRefresh isEqualToString:@"yes"]) {
                _dataArr = [NSMutableArray array];
            }
            for (int i = 0; i < arr.count; i ++) {
                NSDictionary *dic = arr[i];
                [_dataArr addObject:dic];
            }
            _videoPage = [NSString stringWithFormat:@"%lu",[_videoPage integerValue] +1];
            if (footer != nil) {//加载
                [footer endRefreshing];
                [_collectionView reloadData];
                if (arr.count <= 0) {
                    [footer endRefreshingWithNoMoreData];
                }
            } else {//首次请求
                [_collectionView reloadData];
                if (arr.count > 0) {
                    _collectionView.mj_footer.hidden = NO;
                }
            }
        } else {
            if (footer != nil) {//加载
                [footer endRefreshing];
            }
        }
    } failure:^(NSError *error) {
        if (footer != nil) {//加载
            [footer endRefreshing];
        }
        NSLog(@"error%@",error);
    }];
}
//加载更多
- (void)footerLoadMore:(MJRefreshAutoNormalFooter *)footer {
    [self netGetUserVideoListId:_videoUserModel.ID footer:footer isFresh:@"no"];
}
#pragma mark - 通知刷新
- (void)notificationWomanData:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
//    _videoUserModel = [dic objectForKey:@"womanModel"];
//    
//    _videoPage = @"1";
//    NSLog(@"--------%@",[NSString stringWithFormat:@"%@",_videoUserModel.ID]);
//    [self netGetUserVideoListId:_videoUserModel.ID footer:nil isFresh:@"yes"];
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
    
    cell.messageLabel.text = [[_dataArr objectAtIndex:indexPath.row] objectForKey:@"videoName"];
    cell.likeNumLabel.text = [NSString stringWithFormat:@"%@",[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"videoUp"]];
    NSString *timeStampString  = [NSString stringWithFormat:@"%@",[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"updateDate"]];
    NSString *timeStr = [ToolObject timeBeforeInfoWithString:[timeStampString doubleValue]];
    cell.timeLabel.text = timeStr;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger currentPage = self.magicController.currentPage;
 
    _videoModelList = [[DisVideoModelList alloc]initWithArray:_dataArr];
    
    VideoPlayViewController *playController = [[VideoPlayViewController alloc]init];
    playController.baseModel = _disBaseModel;
    playController.videoModelList = _videoModelList;
    playController.currentCell = indexPath.row;
    
    [self.navigationController pushViewController:playController animated:YES];
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
#pragma mark UIScrollView
//判断屏幕触碰状态
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//        NSLog(@"接触屏幕");
    self.fingerIsTouch = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
//        NSLog(@"离开屏幕");
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
    self.collectionView.showsVerticalScrollIndicator = _vcCanScroll?YES:NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma - (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
 <#code#>
 }
 
 - (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
 <#code#>
 }
 
 - (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
 <#code#>
 }
 
 - (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
 <#code#>
 }
 
 - (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
 <#code#>
 }
 
 - (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
 <#code#>
 }
 
 - (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
 <#code#>
 }
 
 - (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
 <#code#>
 }
 
 - (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
 <#code#>
 }
 
 - (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
 <#code#>
 }
 
 - (void)setNeedsFocusUpdate {
 <#code#>
 }
 
 - (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
 <#code#>
 }
 
 - (void)updateFocusIfNeeded {
 <#code#>
 }
 
 mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
