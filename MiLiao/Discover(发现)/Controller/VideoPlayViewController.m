//
//  VideoPlayViewController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/29.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "VideoPlayViewController.h"
#import <AliyunVodPlayerSDK/AliyunVodPlayer.h>
#import "PlayCollectionViewCell.h"

#import "FSBaseViewController.h"
#import "DiscoverMananger.h"
#import "MainMananger.h"
#import "VideoUserModel.h"

#import "RongCallKit.h"
#import "UserInfoNet.h"
#import "EnoughCallTool.h"

#import "PayWebViewController.h"
#import "EvaluateVideoViewController.h"//评价

#define headButtonTag   2000
#define zanButtonTag    3000
#define videoButtonTag  4000

#define zanLabelTag  5000
#define seeLabelTag  6000
#define guanZhuTag  7000
#define guanNumTag  8000
@interface VideoPlayViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,AliyunVodPlayerDelegate,buttonClickDelegate, EvaluateVideoViewControllerDelegate>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)AliyunVodPlayer *aliPlayer;
@property (nonatomic, strong)UIView *currentPlayerView;

@property (nonatomic, assign) BOOL isChangedRow;
@property (nonatomic, strong) NSIndexPath *tempIndexPath;
@property (nonatomic, strong) PlayCollectionViewCell *currentPlayCell;
///评价控制器
@property (nonatomic, strong) EvaluateVideoViewController *evaluateVideoViewConroller;

@end

@implementation VideoPlayViewController {
    UIButton    *_zanButton;
    UIButton    *_guangZhuButton;
    UILabel     *_zanLabel;
    UILabel     *_seeLaebl;
    UILabel     *_guanLabel;
    
    NSInteger    _zanNum;
    
    NSUserDefaults  *_userDefaults;
}

-(AliyunVodPlayer *)aliPlayer{
    if (!_aliPlayer) {
        _aliPlayer = [[AliyunVodPlayer alloc] init];
        _aliPlayer.delegate = self;
    }
    return _aliPlayer;
}

- (UIView *)currentPlayerView{
    if(!_currentPlayerView){
        _currentPlayerView = [[UIView alloc] init];
    }
    return _currentPlayerView;
}

- (EvaluateVideoViewController *)evaluateVideoViewConroller {
    if (!_evaluateVideoViewConroller) {
        _evaluateVideoViewConroller = [[EvaluateVideoViewController alloc] init];
        _evaluateVideoViewConroller.superview = self.view;
        _evaluateVideoViewConroller.delegate = self;
//        __weak typeof(self) weakSelf = self;
//        [_evaluateVideoViewConroller evaluateSuccess:^{
//            [weakSelf.currentPlayCell resumePlay];
//        }];
    }
    return _evaluateVideoViewConroller;
}
#pragma mark - 评价的代理
///评价成功或关闭
- (void)evaluateSuccessOrClose {
    NSArray *ary = [self.collectionView visibleCells];
    for (PlayCollectionViewCell *cell in ary) {
        [cell resumePlay];
    }
}

//#pragma mark - naviBar
- (void)backButton{
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, ML_StatusBarHeight, 50, 40);
    if (UI_IS_IPHONEX) {
        backButton.frame = CGRectMake(10, ML_StatusBarHeight, 50, 40);
    }
    [backButton setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(11, 12, 11, 25);
    [backButton addTarget:self action:@selector(leftBarButtonItemCliceked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)leftBarButtonItemCliceked:(UIButton*)sender{
    sender.enabled = NO;
    //释放播放器
    if (self.aliPlayer) {
        [self.aliPlayer releasePlayer];
        self.aliPlayer = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
    sender.enabled = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSArray *ary = [self.collectionView visibleCells];
    for (PlayCollectionViewCell *cell in ary) {
        [cell stopPlay];
    }
    [SVProgressHUD dismiss];
     [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize =  CGSizeMake(WIDTH, HEIGHT);
    layout.minimumInteritemSpacing=0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor grayColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = YES;
    if (@available(iOS 11.0, *)) {
        [self.collectionView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        // Fallback on earlier versions
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentCell inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];

    [self.view addSubview:self.collectionView];

    [self backButton];
    
    [self listenNotification];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _videoModelList.videoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"identifier";
    [collectionView registerClass:[PlayCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    PlayCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.aliPlayer.delegate = self;
    cell.delegate = self;
    
    cell.headButton.tag = headButtonTag+indexPath.row;
    cell.zanButton.tag = zanButtonTag+indexPath.row;
    cell.videoButton.tag = videoButtonTag+indexPath.row;
    cell.zanLabel.tag = zanLabelTag+indexPath.row;
    cell.seeLabel.tag = seeLabelTag+indexPath.row;
    cell.guanZhuButton.tag = guanZhuTag+indexPath.row;
    cell.guanLabel.tag = guanNumTag+indexPath.row;
    
    NSString *isBigV = [NSString stringWithFormat:@"%@",[_userDefaults objectForKey:@"isBigV"]];
    if ([isBigV isEqualToString:@"3"]) {
        cell.videoButton.hidden = YES;
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.holderImageView.hidden = NO;
    DisVideoModel *videoModel = [_videoModelList.videoArr objectAtIndex:indexPath.row];

    cell.videoModel = videoModel;
    
    
    
//    _currentCell = indexPath.row;
    [self NetGetAnchorSfgzVodeoId:videoModel.videoId token:[_userDefaults objectForKey:@"token"] anchorId:videoModel.userId cell:cell];

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
   
    PlayCollectionViewCell *temp =  (PlayCollectionViewCell*)cell;
    DisVideoModel *videoModel = [[DisVideoModel alloc]init];
    videoModel = [_videoModelList.videoArr objectAtIndex:indexPath.row];
    [temp prepareSts:_baseModel videoId:videoModel.videoId];
    
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
   
    PlayCollectionViewCell *temp =  (PlayCollectionViewCell*)cell;
    [temp stopPlay];

    
}

//是否已关注大V
- (void)NetGetAnchorSfgzVodeoId:(NSString *)videoId token:(NSString *)token anchorId:(NSString *)anchorId cell:(PlayCollectionViewCell *)cell{
    [DiscoverMananger NetGetgetAnchorSfgzVodeoId:videoId token:token anchorId:anchorId success:^(NSDictionary *info) {
        NSLog(@"-----%@",info);
        cell.isGuanZhu = [NSString stringWithFormat:@"%@",[info objectForKey:@"data"]];
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}

#pragma mark - 通知方法
- (void)listenNotification {
    ListenNotificationName_Func(VideoCallEnd, @selector(notificationFunc:));
    ListenNotificationName_Func(SetMoneySuccess, @selector(notificationFunc:));
}

- (void)notificationFunc:(NSNotification *)notification {
    
    //视频通话结束
    if ([notification.name isEqualToString:VideoCallEnd]) {
        
        //没有接通过 继续播放当前视频
        if (notification.userInfo == nil) {
            NSArray *ary = [self.collectionView visibleCells];
            for (PlayCollectionViewCell *cell in ary) {
                [cell resumePlay];
            }
        } else {
            //添加评价界面
             [self.evaluateVideoViewConroller showEvaluaateView:notification.userInfo];
        }
       
    }
    //结算成功
    if ([notification.name isEqualToString:SetMoneySuccess]) {
        [self.evaluateVideoViewConroller showSetMoneySuccessView:notification.userInfo];
    }
    
}

#pragma mark -  cell button delegate
- (void)headButtonSelect:(UIButton *)button {
    DisVideoModel *videoModel = [[DisVideoModel alloc]init];
    videoModel = [_videoModelList.videoArr objectAtIndex:button.tag-headButtonTag];
    
    FSBaseViewController *baseVC = [[FSBaseViewController alloc]init];
    baseVC.user_id = videoModel.userId;
    [self.navigationController pushViewController:baseVC animated:YES];
    
}
//关注当前大VV
- (void)guanZhuButtonSelect:(UIButton *)button {
    
    DisVideoModel *videoModel = [[DisVideoModel alloc]init];
    videoModel = [_videoModelList.videoArr objectAtIndex:button.tag-guanZhuTag];
    _guangZhuButton = [[UIButton alloc]init];
    _guangZhuButton = button;
    
    _guanLabel = [[UILabel alloc]init];
    _guanLabel = (UILabel *)[self.view viewWithTag:button.tag+1000];
    
    [MainMananger NetPostCareuserBgzaccount:videoModel.anchorAccount gzaccount:[_userDefaults objectForKey:@"username"] sfgz:@"1" token:[_userDefaults objectForKey:@"token"] success:^(NSDictionary *info) {
        NSLog(@"-----<>><%@",info);
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            _guangZhuButton.hidden = YES;
            _guanLabel.text = [NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"fansNum"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}
- (void)zanButtonSelect:(UIButton *)button {
    if (button.selected == YES) {
        [self NetPostZanButtonClick:@"0" button:button];
    } else {
        [self NetPostZanButtonClick:@"1" button:button];
    }

}


- (void)playCollectionViewCell:(PlayCollectionViewCell *)cell videoButtonSelect:(DisVideoModel *)videoModel {
    
    self.currentPlayCell = cell;
    
    VideoUserModel *videoUser = [[VideoUserModel alloc] init];
    videoUser.nickname = videoModel.nickName;
    videoUser.price = videoModel.price;
    videoUser.username = videoModel.anchorAccount;
    videoUser.posterUrl = videoModel.headUrl;
    [UserInfoNet canCall:videoUser.username powerEnough:^(RequestState success, NSString *msg, MoneyEnoughType enoughType) {
        if (success) {
            //余额不充足 不能聊天 可以视频
            if (enoughType == MoneyEnoughTypeNotEnough) {
                [EnoughCallTool viewController:self showPayAlertController:^{
                    [self goPay];//去充值
                } continueCall:^{
                    [cell pausePlay];
                    //继续视频
                    [[RCCall sharedRCCall] startSingleVideoCallToVideoUser:videoUser];
                }];
            }
            
            //余额充足 既能聊天 有能视频
            if (enoughType == MoneyEnoughTypeEnough) {
                [cell pausePlay];
                [[RCCall sharedRCCall] startSingleVideoCallToVideoUser:videoUser];
            }
            
            //余额为0
            if (enoughType == MoneyEnoughTypeEmpty) {
                [EnoughCallTool viewController:self showPayAlertController:^{
                    [self goPay];
                }];
                
            }
        } else {
            [SVProgressHUD showErrorWithStatus:msg];
        }
    }];
    
}


- (void)goPay {
    PayWebViewController *payViewController = [[PayWebViewController alloc] init];
    [self.navigationController pushViewController:payViewController animated:YES];
}


//赞视频
- (void)NetPostZanButtonClick:(NSString *)zanStatus button:(UIButton *)button {
    DisVideoModel *videoModel = [[DisVideoModel alloc]init];
    videoModel = [_videoModelList.videoArr objectAtIndex:button.tag-zanButtonTag];
    _zanNum = [videoModel.videoUp integerValue];
    _zanButton = [[UIButton alloc]init];
    _zanButton = button;
    
    _zanLabel = [[UILabel alloc]init];
    _zanLabel = (UILabel *)[self.view viewWithTag:button.tag+2000];
    
    [DiscoverMananger NetPostUpdateVideoZanUserId:videoModel.userId token:[_userDefaults objectForKey:@"token"] videoId:videoModel.videoId zanStatus:zanStatus success:^(NSDictionary *info) {
        NSLog(@"%@",info);
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            if (button.selected == YES) {
                [_zanButton setImage:[UIImage imageNamed:@"noxihuan_video"] forState:UIControlStateNormal];
                
                _zanLabel.text = [NSString stringWithFormat:@"%d",[videoModel.videoUp intValue] - 1];
                button.selected = NO;
                NSMutableArray *muarr = [_videoModelList.videoArr mutableCopy];
                DisVideoModel *model = [muarr objectAtIndex:button.tag-zanButtonTag];
                model.videoUp = [NSString stringWithFormat:@"%ld",[videoModel.videoUp integerValue] - 1];
                [muarr removeObjectAtIndex:button.tag-zanButtonTag];
                [muarr insertObject:model atIndex:button.tag-zanButtonTag];
                _videoModelList.videoArr = muarr;
            } else {
                button.selected = YES;
                [_zanButton setImage:[UIImage imageNamed:@"xihuan_video"] forState:UIControlStateNormal];
                 _zanLabel.text = [NSString stringWithFormat:@"%d",[videoModel.videoUp intValue] + 1];
                NSMutableArray *muarr = [_videoModelList.videoArr mutableCopy];
                DisVideoModel *model = [muarr objectAtIndex:button.tag-zanButtonTag];
                model.videoUp = [NSString stringWithFormat:@"%ld",[videoModel.videoUp integerValue] +1];
                [muarr removeObjectAtIndex:button.tag-zanButtonTag];
                [muarr insertObject:model atIndex:button.tag-zanButtonTag];
                _videoModelList.videoArr = muarr;
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];

}

-(void)vodPlayer:(AliyunVodPlayer *)vodPlayer onEventCallback:(AliyunVodPlayerEvent)event{
    self.tempIndexPath = [NSIndexPath indexPathForRow:(int)(self.collectionView.contentOffset.y/HEIGHT) inSection:0];
    PlayCollectionViewCell *temp = (PlayCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:self.tempIndexPath] ;
    if (event == AliyunVodPlayerEventPrepareDone) {
        if (vodPlayer.autoPlay) {
            
        }else{
            
            [vodPlayer start];
        }
    }
    switch (event) {
        case AliyunVodPlayerEventPrepareDone:
            [SVProgressHUD dismiss];
            
            //播放准备完成时触发
            break;
        case AliyunVodPlayerEventPlay:
            [SVProgressHUD dismiss];
            //暂停后恢复播放时触发
            break;
        case AliyunVodPlayerEventFirstFrame:
            [SVProgressHUD dismiss];
            temp.holderImageView.hidden = YES;
            //播放视频首帧显示出来时触发
            break;
        case AliyunVodPlayerEventPause:
            [SVProgressHUD dismiss];
            //视频暂停时触发
            break;
        case AliyunVodPlayerEventStop:
            [SVProgressHUD dismiss];
            //主动使用stop接口时触发
            break;
        case AliyunVodPlayerEventFinish:
            [SVProgressHUD dismiss];
            //视频正常播放完成时触发
            break;
        case AliyunVodPlayerEventBeginLoading:
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            temp.holderImageView.hidden = NO;
            //视频开始载入时触发
            break;
        case AliyunVodPlayerEventEndLoading:
            [SVProgressHUD dismiss];
            
            //视频加载完成时触发
            break;
        case AliyunVodPlayerEventSeekDone:
            [SVProgressHUD dismiss];
            //视频Seek完成时触发
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
