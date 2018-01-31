//
//  FSBaseViewController.m
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "FSBaseViewController.h"
#import "FSBaseTableView.h"
#import "FSBaseTopTableViewCell.h"
#import "FSBaselineTableViewCell.h"
#import "FSScrollContentView.h"
#import "FSScrollContentViewController.h"
#import "FSBottomTableViewCell.h"

#import "HLZiLiaoController.h"
#import "MLCommentsViewController.h"
#import "VideoViewController.h"
#import "ChatListController.h"
#import "ChatRoomController.h"

#import "RongCallKit.h"
#import <RongIMKit/RongIMKit.h>


#import "UserInfoNet.h"
#import "MainMananger.h"

#import "VideoUserModel.h"
#import "LoveViewController.h"
#import "EvaluateVideoViewController.h"//评价
#import "PayWebViewController.h"
#import "UserCallPowerModel.h"//通话能力
#import "ReportView.h"//投诉弹窗

#import "EnoughCallTool.h"

//#import "FUManager.h"
//#import <FUAPIDemoBar/FUAPIDemoBar.h>
//#import "FUVideoFrameObserverManager.h"

#define buyVChatButtonTag 800
#define downButtonTag   2000
#define ziLiaoStr      @"ziLiao"
#define videoStr      @"shiPin"
#define commentStr      @"pingLun"
@interface FSBaseViewController ()<UITableViewDelegate,UITableViewDataSource,FSPageContentViewDelegate,FSSegmentTitleViewDelegate,topButtonDelegate> {
    NSUserDefaults  *_userDefaults;
    WomanModel      *_womanModel;
    UIButton        *_backButton;
    UIButton        *_stateButton;
    UIButton        *_focusButton;
    PriceView       *_priceView;
    float           detailHeight;
    UIView          *_navView;
    UIView          *_colorView;
    UILabel         *_titleLabel;
    NSMutableArray  *_imageMuArr;
    UIView          *_footView;//下方视图
    
    UIView          *_backGroundView;
    UIView          *_buyVChatView;
    UILabel         *_foucusLabel;
    NSString        *_isBuyWechat;
    NSString        *_isHidden;    //是否隐藏版本
    
    NSString        *_selectStr;
    
}
@property (nonatomic, strong) FSBaseTableView *tableView;
@property (nonatomic, strong) FSBottomTableViewCell *contentCell;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property (nonatomic, assign) BOOL canScroll;
///当前用户的M币
@property (nonatomic, assign) CGFloat balance;
///当前网红的价格
@property (nonatomic, assign) CGFloat netHotPrice;
///评价控制器
@property (nonatomic, strong) EvaluateVideoViewController *evaluateVideoViewConroller;
@end

@implementation FSBaseViewController

- (EvaluateVideoViewController *)evaluateVideoViewConroller {
    if (!_evaluateVideoViewConroller) {
        _evaluateVideoViewConroller = [[EvaluateVideoViewController alloc] init];
        _evaluateVideoViewConroller.superview = self.view;
    }
    return _evaluateVideoViewConroller;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//     [self prefersStatusBarHidden];
    [self.navigationController setNavigationBarHidden:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"tableView嵌套tableView手势Demo";
 
    _selectStr = ziLiaoStr;
    //监听通知
    [self listenNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _womanModel = [[WomanModel alloc]init];
    _imageMuArr = [NSMutableArray array];
    _isBuyWechat = [NSString string];
    
    _isHidden = [NSString stringWithFormat:@"%@",[_userDefaults objectForKey:@"isHidden"]];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    //主播信息请求
    [self NetGetUserInformation:_user_id header:nil];
    
    _tableView = [[FSBaseTableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-50) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        [_tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        // Fallback on earlier versions
    }
    
    if ([[_userDefaults objectForKey:@"isBigV"]isEqualToString:@"3"]) {
        _tableView.frame = CGRectMake(0, -ML_StatusBarHeight, WIDTH, HEIGHT+ML_StatusBarHeight);
    }
    
    if (UI_IS_IPHONEX) {
        if ([[_userDefaults objectForKey:@"isBigV"]isEqualToString:@"3"]) {
            _tableView.frame = CGRectMake(0, -ML_StatusBarHeight, WIDTH, HEIGHT+ML_StatusBarHeight-34);
        }
        
    }
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing:)];
    _tableView.mj_header = header;
    
    [self.view addSubview:_tableView];
    [self addFootView];
     [self addNavView];
    [self setupSubViews];
    [self loadDaata];
}
- (void)loadDaata
{
    [UserInfoNet getUserRole:^(RequestState success, NSDictionary *dict, NSString *msg) {
        NSLog(@"%@",msg);
        if (success) {

            [YZCurrentUserModel sharedYZCurrentUserModel].roleType = dict[@"roleType"];
        }
    }];
}
#pragma mark - 通知方法
- (void)listenNotification {
    ListenNotificationName_Func(VideoCallEnd, @selector(notificationFunc:));
    ListenNotificationName_Func(SetMoneySuccess, @selector(notificationFunc:));
}

- (void)notificationFunc:(NSNotification *)notification {

    //视频通话结束 添加评价界面
    if ([notification.name isEqualToString:VideoCallEnd]) {
        [self.evaluateVideoViewConroller showEvaluaateView:notification.userInfo];
    }
    //结算成功
    if ([notification.name isEqualToString:SetMoneySuccess]) {
        [self.evaluateVideoViewConroller showSetMoneySuccessView:notification.userInfo];
    }
    
}

- (void)setupSubViews
{
    self.canScroll = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
//    __weak typeof(self) weakSelf = self;
//    [self.tableView addPullToRefreshWithActionHandler:^{
//        [weakSelf insertRowAtTop];
//    }];
    _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _backGroundView.backgroundColor = ML_Color(0, 0, 0, 0.49);
    _backGroundView.hidden = YES;
    
    _buyVChatView = [[UIView alloc]initWithFrame:CGRectMake(54*Iphone6Size, 266*Iphone6Size, WIDTH-(54*Iphone6Size)*2, 150*Iphone6Size)];
    _buyVChatView.hidden = YES;
    _buyVChatView.backgroundColor = Color255;
    _buyVChatView.layer.cornerRadius = 5.0;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 28, _buyVChatView.frame.size.width, 14)];
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = @"需支付1000M币，是否立即支付";
    titleLabel.textColor = Color155;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    NSArray *buttonArr = [NSArray arrayWithObjects:@"否",@"是", nil];
    for (int i = 0; i < buttonArr.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = buyVChatButtonTag+i;
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [button setTitle:buttonArr[i] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5.0;
        [button addTarget:self action:@selector(buyVChatButton:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.frame = CGRectMake(24, _buyVChatView.frame.size.height-62, 48, 34);
            button.backgroundColor = Color242;
            [button setTitleColor:Color75 forState:UIControlStateNormal];
        } else {
            button.frame = CGRectMake(_buyVChatView.frame.size.width-24-48, _buyVChatView.frame.size.height-62, 48, 34);
            button.backgroundColor = ML_Color(255, 239, 239, 1);
            [button setTitleColor:ML_Color(250, 114, 152, 1) forState:UIControlStateNormal];
        }
        [_buyVChatView addSubview:button];
    }
    [_buyVChatView addSubview:titleLabel];
    [self.view addSubview:_backGroundView];
    [self.view addSubview:_buyVChatView];
}
- (void)addNavView {
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, ML_TopHeight)];
    _navView.backgroundColor = [UIColor clearColor];
    _colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, ML_TopHeight)];
    _colorView.backgroundColor = NavColor;
    _colorView.alpha = 0;
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, WIDTH, ML_TopHeight)];
    _titleLabel.font = [UIFont systemFontOfSize:18.0];
    _titleLabel.textColor = Color255;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0, ML_StatusBarHeight, 50, 40);
    if (UI_IS_IPHONEX) {
        _backButton.frame = CGRectMake(10, ML_StatusBarHeight, 50, 40);
    }
    [_backButton setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    _backButton.imageEdgeInsets = UIEdgeInsetsMake(11, 12, 11, 25);
    [_backButton addTarget:self action:@selector(backBarButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_colorView addSubview:_titleLabel];
    [_navView addSubview:_colorView];
    [_navView addSubview:_backButton];
    [self.view addSubview:_navView];
}

- (void)backBarButtonSelect:(UIButton *)button {
        [self.navigationController popViewControllerAnimated:YES];
}
//底部视图
- (void)addFootView {
    _footView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-50, WIDTH, 50)];
    if (UI_IS_IPHONEX) {
        _footView.frame = CGRectMake(0, HEIGHT-50-34, WIDTH, 50);
    }
    _footView.backgroundColor = [UIColor whiteColor];
    NSArray *titleArr = [NSArray arrayWithObjects:@"私信我",@"与我视频", nil];
    for (int i = 0; i < titleArr.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(12+((WIDTH-48)/2+24)*i, 10, (WIDTH-48)/2, 30);
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [button setTitleColor:Color255 forState:UIControlStateNormal];
        button.layer.cornerRadius = 5.0;
        button.backgroundColor = NavColor;
        if (i == 0) {
            button.imageEdgeInsets = UIEdgeInsetsMake(5, 12, 5, (WIDTH-48)/2-36);
            [button setImage:[UIImage imageNamed:@"sixin"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"sixin"] forState:UIControlStateHighlighted];
        } else {
            button.imageEdgeInsets = UIEdgeInsetsMake(5, 12, 5, (WIDTH-48)/2-40);
            [button setImage:[UIImage imageNamed:@"shipin"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"shipin"] forState:UIControlStateHighlighted];
        }
        button.tag = downButtonTag+i;
        [button addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:button];
    }
    [self.view addSubview:_footView];
    if ([[_userDefaults objectForKey:@"isBigV"]isEqualToString:@"3"]) {
        _footView.hidden = YES;
    }
   
    
}
#pragma mark - 请求主播数据
- (void)NetGetUserInformation:(NSString *)user_id header:(MJRefreshNormalHeader *)header{
    NSLog(@"-------%@",user_id);
    [MainMananger NetGetgetAnchorInfoNickName:@"a" token:[_userDefaults objectForKey:@"token"] userid:user_id success:^(NSDictionary *info) {
        NSLog(@"----%@",info);
        [SVProgressHUD dismiss];
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            _imageMuArr = [NSMutableArray array];
            _womanModel = [[WomanModel alloc]initWithDictionary:[[info objectForKey:@"data"] objectAtIndex:0]];
            _titleLabel.text = _womanModel.nickname;
            for (int i = 0; i < _womanModel.imageList.count; i++) {
                NSDictionary *dic = _womanModel.imageList[i];
                NSString *fileUrl = [dic objectForKey:@"fileUrl"];
                [_imageMuArr addObject:fileUrl];
                
            }
            
            [_tableView reloadData];
            if (header != nil) {
                
                [header endRefreshing];
                _titleView.selectIndex = 0;
                self.contentCell.pageContentView.contentViewCurrentIndex = _titleView.selectIndex;
                NSDictionary *userDic = [NSDictionary dictionaryWithObject:_womanModel forKey:@"womanModel"];
                NSNotification *notification =[NSNotification notificationWithName:@"refreshWomanData" object:nil userInfo:userDic];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            } else {
                NSDictionary *userDic = [NSDictionary dictionaryWithObject:_womanModel forKey:@"womanModel"];
                NSNotification *notification =[NSNotification notificationWithName:@"getWomanInformation" object:nil userInfo:userDic];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
        } else {
            if (header != nil) {
                [header endRefreshing];
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (header != nil) {
            [header endRefreshing];
        }
        NSLog(@"error%@",error);
    }];
}

#pragma mark refresh
- (void)headerRefreshing:(MJRefreshNormalHeader *)header {
    [self NetGetUserInformation:_user_id header:header];
}
//微信购买
- (void)buyVChatButton:(UIButton *)button {
    
    if (button.tag == buyVChatButtonTag) {
        _backGroundView.hidden = YES;
        _buyVChatView.hidden = YES;
    } else {
        [self buyWeChat];
    }
}
//购买微信
- (void)buyWeChat {
    [MainMananger NetGetbuyWechatInfoToken:[_userDefaults objectForKey:@"token"] anchorId:_womanModel.user_id price:@"2000" success:^(NSDictionary *info) {
        _backGroundView.hidden = YES;
        _buyVChatView.hidden = YES;
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            _isBuyWechat = @"yes";
            [self NetGetUserInformation:_user_id header:nil];
        } else {
            [ToolObject showOkAlertMessageString:[info objectForKey:@"resultMsg"] withViewController:self];
        }
    } failure:^(NSError *error) {
        _backGroundView.hidden = YES;
        _buyVChatView.hidden = YES;
        NSLog(@"error%@",error);
    }];
}
//底部按钮点击
- (void)downButtonClick:(UIButton *)but {
    
    if (but.tag == downButtonTag) {
        [self chat];
    } else {
       
        [UserInfoNet canCall:self.videoUserModel.username powerEnough:^(RequestState success, NSString *msg, MoneyEnoughType enoughType) {
            if (success) {
                //余额不充足 不能聊天 可以视频
                if (enoughType == MoneyEnoughTypeNotEnough) {
                    [EnoughCallTool viewController:self showPayAlertController:^{
                        //去充值
                        [self goPay];
                    } continueCall:^{
                        //继续视频
                        [self videoCall];
                    }];
                }
                
                //余额充足 既能聊天 有能视频
                if (enoughType == MoneyEnoughTypeEnough) {
                    [self videoCall];
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
    
}

///聊天
- (void)chat {
    //新建一个聊天会话View Controller对象,建议这样初始化
    ChatRoomController *chat = [[ChatRoomController alloc] initWithConversationType:ConversationType_PRIVATE targetId:self.videoUserModel.username];
    chat.isFSBase = @"YES";
    chat.title = self.videoUserModel.nickname;
    chat.videoUser = self.videoUserModel;
    chat.automaticallyAdjustsScrollViewInsets = NO;
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
}

///视频聊天
- (void)videoCall {
    NSLog(@"%@", self.videoUserModel.username);
    [[RCCall sharedRCCall] startSingleVideoCallToVideoUser:self.videoUserModel];
//    [[RCCall sharedRCCall] startSingleCall:self.videoUserModel.username mediaType:RCCallMediaVideo];
}

- (void)goPay {
    PayWebViewController *payViewController = [[PayWebViewController alloc] init];
    [self.navigationController pushViewController:payViewController animated:YES];
}

#pragma mark - 计算可通话时长
//计算可通话时长
- (void)calculatorCallTime:(void(^)(BOOL canCall))canCall {
#warning 针对账户余额 需另做判断
//    [UserInfoNet canCall:^(RequestState success, MoneyEnoughType moneyType) {
//        if (success) {
//
//        }
//    }];
    [UserInfoNet getUserBalance:^(CGFloat balance) {
        self.balance = balance;
       !canCall?:canCall(self.balance - [self.videoUserModel.price integerValue] * 5 >= 0);
    }];
    
}

- (void)insertRowAtTop
{
    NSArray *sortTitles = [NSArray array];
    if ([_isHidden isEqualToString:@"yes"]) {
        sortTitles = @[@"资料",@"评论"];
    } else {
        sortTitles = @[@"资料",@"视频",@"评论"];
    }
    
    self.contentCell.currentTagStr = sortTitles[self.titleView.selectIndex];
    self.contentCell.isRefresh = YES;
//    [self.tableView.pullToRefreshView stopAnimating];
}

#pragma mark notify
- (void)changeScrollStatus//改变主视图的状态
{
    self.canScroll = YES;
    self.contentCell.cellCanScroll = NO;
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([_isHidden isEqualToString:@"yes"]) {
               return WIDTH+58;
            }
            return WIDTH+158;
        }
        return 0;
    }
    if ([[_userDefaults objectForKey:@"isBigV"]isEqualToString:@"3"]) {
        return HEIGHT-ML_TopHeight;
    } else {
//        return HEIGHT-ML_TopHeight-50;
        if([_selectStr isEqualToString:ziLiaoStr]) {
            return HEIGHT-ML_TopHeight-50;
        } else {
            return HEIGHT-ML_TopHeight-50;
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
        return 50;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([_isHidden isEqualToString:@"yes"]) {
        self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50) titles:@[@"资料",@"评论"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
        
    } else {
        self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50) titles:@[@"资料",@"视频",@"评论"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    }
    
    self.titleView.titleNormalColor = ML_Color(77, 77, 77, 1);
    self.titleView.titleSelectColor = NavColor;
    self.titleView.indicatorColor = NavColor;
    self.titleView.indicatorExtension = 15;
    self.titleView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 49.7, WIDTH, 0.3)];
    label.backgroundColor = Color242;
    [self.titleView addSubview:label];
    return self.titleView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *FSBaseTopTableViewCellIdentifier = @"FSBaseTopTableViewCellIdentifier";
    static NSString *FSBaselineTableViewCellIdentifier = @"FSBaselineTableViewCellIdentifier";
    if (indexPath.section == 1) {
        _contentCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!_contentCell) {
            _contentCell = [[FSBottomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            NSMutableArray *contentVCs = [NSMutableArray array];
            if ([_isHidden isEqualToString:@"yes"]) {
                NSArray *titles = @[@"资料",@"评论"];
                //                NSMutableArray *contentVCs = [NSMutableArray array];
                for (NSString *title in titles) {
                    if ([title isEqualToString:@"资料"]) {
                        HLZiLiaoController *detailVC = [[HLZiLiaoController alloc]init];
                        detailVC.womanModel = _womanModel;
                        
                        [contentVCs addObject:detailVC];
                    } else {
                        MLCommentsViewController *vc = [[MLCommentsViewController alloc]init];
                        vc.title = title;
                        vc.str = title;
                        vc.videoUserModel = _videoUserModel;
                        [contentVCs addObject:vc];
                    }
                }
            } else {
                NSArray *titles = @[@"资料",@"视频",@"评论"];
                
                for (NSString *title in titles) {
                    if ([title isEqualToString:@"资料"]) {
                        HLZiLiaoController *detailVC = [[HLZiLiaoController alloc]init];
                        detailVC.womanModel = _womanModel;
                        
                        [contentVCs addObject:detailVC];
                    } else if ([title isEqualToString:@"视频"]) {
                        VideoViewController *videoVC = [[VideoViewController alloc]init];
                        videoVC.videoUserModel = _videoUserModel;
                        [contentVCs addObject:videoVC];
                    } else {
                        MLCommentsViewController *vc = [[MLCommentsViewController alloc]init];
                        vc.title = title;
                        vc.str = title;
                        vc.videoUserModel = _videoUserModel;
                        [contentVCs addObject:vc];
                    }
                }
                
            
            }
            _contentCell.viewControllers = contentVCs;
            _contentCell.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT - 50) childVCs:contentVCs parentVC:self delegate:self];
            if ([[_userDefaults objectForKey:@"isBigV"]isEqualToString:@"3"]) {
                _contentCell.pageContentView.frame = CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT);
            }
            [_contentCell.contentView addSubview:_contentCell.pageContentView];
        }
        return _contentCell;
    }
    if (indexPath.row == 0) {
        FSBaseTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FSBaseTopTableViewCellIdentifier];
        if (!cell) {
            cell = [[FSBaseTopTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FSBaseTopTableViewCellIdentifier];
        }
        cell.reportBlock = ^{
//            ReportView *alert = [[NSBundle mainBundle] loadNibNamed:
//                                 @"ReportView" owner:nil options:nil ].lastObject;
//            [alert show];
            [self showReportSheet];
        };
        cell.delegate = self;
        if (_imageMuArr.count >0) {
            cell.loopView.imgResourceArr = _imageMuArr;
        }
        
        [cell.priceView setPrice:_womanModel.price];

        cell.nameLabel.text = _womanModel.nickname;
        cell.messageLabel.text = _womanModel.descriptionStr;
        [cell.stateButton setStateStr:_womanModel.status];
        cell.numFocusLabel.text = [NSString stringWithFormat:@"%@关注",_womanModel.fansNum];
   
        _foucusLabel = cell.numFocusLabel;
        
        cell.headImage3.hidden = NO;
        cell.headImage2.hidden = NO;
        cell.headImage1.hidden = NO;
        
        if (_womanModel.orderList.count == 0) {
            cell.headImage1.hidden = YES;
            cell.headImage2.hidden = YES;
            cell.headImage3.hidden = YES;
        } else if (_womanModel.orderList.count == 1) {
            cell.headImage2.hidden = YES;
            cell.headImage3.hidden = YES;
            [cell.headImage1 sd_setImageWithURL:[NSURL URLWithString:[_womanModel.orderList[0] objectForKey:@"headUrl"]] placeholderImage:nil];
        } else if (_womanModel.orderList.count == 2) {
            cell.headImage3.hidden = YES;
            [cell.headImage1 sd_setImageWithURL:[NSURL URLWithString:[_womanModel.orderList[0] objectForKey:@"headUrl"]] placeholderImage:nil];
            [cell.headImage2 sd_setImageWithURL:[NSURL URLWithString:[_womanModel.orderList[1] objectForKey:@"headUrl"]] placeholderImage:nil];
        } else {
            [cell.headImage1 sd_setImageWithURL:[NSURL URLWithString:[_womanModel.orderList[0] objectForKey:@"headUrl"]] placeholderImage:nil];
             [cell.headImage2 sd_setImageWithURL:[NSURL URLWithString:[_womanModel.orderList[1] objectForKey:@"headUrl"]] placeholderImage:nil];
            [cell.headImage3 sd_setImageWithURL:[NSURL URLWithString:[_womanModel.orderList[2] objectForKey:@"headUrl"]] placeholderImage:nil];
        }
        
        cell.weixinLabel.text = _womanModel.wechat;
        if ([_womanModel.wechat hasPrefix:@"WX**"]) {
            _isBuyWechat = @"no";
            cell.getweixinLabel.hidden = NO;
        } else {
            _isBuyWechat = @"yes";
            cell.getweixinLabel.hidden = YES;
        }
        
        if ([_womanModel.sfgz isEqualToString:@"1"]) {
            cell.focusButton.selected = YES;
            [cell.focusButton setImage:nil forState:UIControlStateNormal];
            [cell.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
        } else {
            cell.focusButton.selected = NO;
            [cell.focusButton setImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
            [cell.focusButton setTitle:@"关注" forState:UIControlStateNormal];
            cell.focusButton.imageEdgeInsets = UIEdgeInsetsMake(5, 13, 5, 42);
        }
        return cell;
    }else{
        FSBaselineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FSBaselineTableViewCellIdentifier];
        if (!cell) {
            cell = [[FSBaselineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FSBaselineTableViewCellIdentifier];
        }
        return cell;
    }
    return nil;
}


///弹出举报拉黑sheet
- (void)showReportSheet {
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
            [[NSUserDefaults standardUserDefaults] setObject:self.videoUserModel.ID forKey:@"laheiID"];
            [self.navigationController popViewControllerAnimated:YES];
            PostNotificationNameUserInfo(@"lahei", @{@"laheiID":self.videoUserModel.ID});
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

#pragma mark topCellDelegate
- (void)focusButtonSelect:(UIButton *)button {
    if (button.selected == YES) {
        [self NetPostSelectFocusButtonisFocus:@"0" button:button];
    } else {
        [self NetPostSelectFocusButtonisFocus:@"1" button:button];
    }

}

- (void)loveNumButtonselect {
    LoveViewController *loveVC = [[LoveViewController alloc]init];
    loveVC.womanModel = _womanModel;
    [self.navigationController pushViewController:loveVC animated:YES];
}

- (void)weiXinButtonSelect {
    if ([_isBuyWechat isEqualToString:@"no"]) {
        _backGroundView.hidden = NO;
        _buyVChatView.hidden = NO;
    } else {
        
    }
    
}
//关注的请求方法
- (void)NetPostSelectFocusButtonisFocus:(NSString *)isFocus button:(UIButton *)button{
    _focusButton = [[UIButton alloc]init];
    _focusButton = button;
    [MainMananger NetPostCareuserBgzaccount:_womanModel.username gzaccount:[YZCurrentUserModel sharedYZCurrentUserModel].username sfgz:isFocus token:[YZCurrentUserModel sharedYZCurrentUserModel].token success:^(NSDictionary *info) {
        
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            if (button.selected == YES) {
                _foucusLabel.text = [NSString stringWithFormat:@"%@关注",[[info objectForKey:@"data"] objectForKey:@"fansNum"]];
                button.selected = NO;
                [_focusButton setImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
                [_focusButton setTitle:@"关注" forState:UIControlStateNormal];
            } else {
                _foucusLabel.text = [NSString stringWithFormat:@"%@关注",[[info objectForKey:@"data"] objectForKey:@"fansNum"]];
                button.selected = YES;
                [_focusButton setImage:nil forState:UIControlStateNormal];
                [_focusButton setTitle:@"已关注" forState:UIControlStateNormal];
            }
            //通知改变关注
            NSNotification *notification =[NSNotification notificationWithName:@"foucusStatusChange" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}
#pragma mark FSSegmentTitleViewDelegate
- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
//    NSLog(@"-----------------%lu",endIndex);
    self.titleView.selectIndex = endIndex;
    _tableView.scrollEnabled = YES;//此处其实是监测scrollview滚动，pageView滚动结束主tableview可以滑动，或者通过手势监听或者kvo，这里只是提供一种实现方式
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
//    NSLog(@"--------------->>>select--%lu",endIndex);
    self.contentCell.pageContentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContentViewDidScroll:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress
{
    _tableView.scrollEnabled = NO;//pageView开始滚动主tableview禁止滑动
}

#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat minAlphaOffset = 0;
    CGFloat maxAlphaOffset = 200;
    if (scrollView == _tableView) {
        CGFloat offset = scrollView.contentOffset.y;
        CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
        _colorView.alpha = alpha;
    }

      CGFloat bottomCellOffset = [_tableView rectForSection:1].origin.y-ML_StatusBarHeight-ML_TopHeight;
   
    if (scrollView.contentOffset.y >= bottomCellOffset) {
        scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        if (self.canScroll) {
            self.canScroll = NO;
            self.contentCell.cellCanScroll = YES;
        }
    }else{
        if (!self.canScroll) {//子视图没到顶部
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        }
    }
  
//    NSLog(@"--------%lf-----%lf",bottomCellOffset,scrollView.contentOffset.y);
//    if([_selectStr isEqualToString:ziLiaoStr]){
//        if(scrollView.contentOffset.y >= 185) {
//            NSLog(@"-------------=-==");
//
//            self.canScroll = NO;
//            self.contentCell.cellCanScroll = YES;
//        } else {
//            if (!self.canScroll) {//子视图没到顶部
//                scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
//            }
//        }
//    }
    
    self.tableView.showsVerticalScrollIndicator = _canScroll?YES:NO;
}

#pragma mark - 网络方法
///获取当前网红的价格
- (void)getNetHotPrice:(void(^)(CGFloat price))price {
//    sleep(0.5);
    !price?:price(5);
}

#pragma mark LazyLoad
//- (FSBaseTableView *)tableView
//{
//    if (!_tableView) {
//        _tableView = [[FSBaseTableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-50) style:UITableViewStylePlain];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        [self.view addSubview:_tableView];
//    }
//    return _tableView;
//}

@end
