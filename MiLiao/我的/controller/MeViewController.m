//
//  MeViewController.m
//  MChat
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 Zc. All rights reserved.
//

#import "MeViewController.h"
#import "MyMoneyViewController.h"
#import "edttViewController.h"
#import "IdentificationVController.h"
#import "RCDCustomerServiceViewController.h"
#import "MyVideoViewController.h"
#import "SettingTableViewController.h"
#import "InReviewViewController.h"//审核中
#import "AuditFailureViewController.h"//审核失败
#import "AuditSuccessViewController.h"//审核成功
#import "HelpViewController.h"
#import "CallUSViewController.h"
@interface MeViewController () {
    NSUserDefaults   *_userDefaults;
}
//退出按钮
@property(nonatomic,strong)UIButton *LogoutButton;
@property (strong, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UIButton *edit;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property(nonatomic,strong)NSString *headerUrl;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
  
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.headerImg.layer.cornerRadius = 45;
    self.headerImg.layer.masksToBounds = YES;
    self.edit.hidden = YES;
//    [self loadData];

//    NSLog(@"wowowowowowowowo%@",[_userDefaults objectForKey:@"headUrl"]);
//    self.nickName.text = [_userDefaults objectForKey:@"nickname"];
}
- (void)loadData
{
    [HLLoginManager centertoken:[_userDefaults objectForKey:@"token"] success:^(NSDictionary *info) {
        
        NSLog(@"----------------%@",info);
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
          //  headUrl
            [YZCurrentUserModel userInfoWithDictionary:info[@"data"]];
            self.headerUrl = info[@"data"][@"headUrl"];
            [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",info[@"data"][@"headUrl"]]] placeholderImage:[UIImage imageNamed:@"默认头像"] options:SDWebImageRefreshCached];
            self.nickName.text = [NSString stringWithFormat:@"%@",info[@"data"][@"nickname"]];
             NSString *isBigV = [NSString stringWithFormat:@"%@",info[@"data"][@"isBigV"]];
             [_userDefaults setObject:isBigV forKey:@"isBigV"];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //导航栏透明
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]forBarMetrics:UIBarMetricsDefault];
//    self.nickName.text = [YZCurrentUserModel sharedYZCurrentUserModel].nickname;
    NSLog(@"%@^^^",[YZCurrentUserModel sharedYZCurrentUserModel].nickname);
//    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_userDefaults objectForKey:@"headUrl"]]] placeholderImage:[UIImage imageNamed:@"my_head_icon"] options:SDWebImageRefreshCached];

    [self loadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    if (UI_IS_IPHONE6) {
        self.tableView.contentSize = CGSizeMake(0,HEIGHT+100);

    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏客服
    if (indexPath.section == 1 && indexPath.row == 0) {
        return 0;
    }
    //隐藏帮助
    if (indexPath.section == 1 && indexPath.row == 1) {
        return 0;
    }
    //隐藏版本更新
    if (indexPath.section == 2 && indexPath.row == 1) {
        return 0;
    }
    //根据后台判断隐藏我的钱包 小视频
    if ([[_userDefaults objectForKey:@"isHidden"]isEqualToString:@"yes"])
    {
        if (indexPath.section == 0 && indexPath.row == 1) {
            return 0;
        }
        if (indexPath.section == 0 && indexPath.row == 0) {
            return 0;
        }
        //  0:未申请, 1:申请待审核, 2:审核未通过, 3:审核通过
        if ([[_userDefaults objectForKey:@"isBigV"]isEqualToString:@"3"])
        {
            if (indexPath.section == 2 && indexPath.row == 0) {
                return 50;
            }
        }else{
            if (indexPath.section == 2 && indexPath.row == 0) {
                return 0;
            }
        }
        
    }else{
        //  0:未申请, 1:申请待审核, 2:审核未通过, 3:审核通过
        if ([[_userDefaults objectForKey:@"isBigV"]isEqualToString:@"3"])
        {
            
        }else{
            //隐藏小视频
            if (indexPath.section == 0 && indexPath.row == 0) {
                return 0;
            }
            if (indexPath.section == 2 && indexPath.row == 0) {
                return 0;
            }
        }

    }
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 4) {
            //联系我们
            CallUSViewController *callUS = [[CallUSViewController alloc]init];
            [self.navigationController pushViewController:callUS animated:YES];
        }
        if (indexPath.row == 0) {
            MyVideoViewController *videoVC = [[MyVideoViewController alloc]init];
            [self.navigationController pushViewController:videoVC animated:YES];
        }
        if (indexPath.row == 1) {
            //我的钱包
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
            MyMoneyViewController *money = [story instantiateViewControllerWithIdentifier:@"MyMoneyViewController"];
            //设置导航条颜色
            UINavigationController *nav = (UINavigationController *)self.navigationController;
            //隐藏分隔线
            [nav.navigationBar setShadowImage:[UIImage new]];
            [self.navigationController pushViewController:money animated:YES];

        }
        if (indexPath.row == 2) {
            //编辑个人资料
            edttViewController *edit = [[edttViewController alloc]init];
            edit.headerUrl = self.headerUrl;
            edit.nickName = self.nickName.text;
            [self.navigationController pushViewController:edit animated:YES];
        }
        if (indexPath.row == 3) {
            //  0:未申请, 1:申请待审核, 2:审核未通过, 3:审核通过
            if ([[_userDefaults objectForKey:@"isBigV"]isEqualToString:@"0"]) {
                //大V
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
                IdentificationVController *Identification = [story instantiateViewControllerWithIdentifier:@"IdentificationVController"];
                //设置导航条颜色
                UINavigationController *nav = (UINavigationController *)self.navigationController;
                //隐藏分隔线
                [nav.navigationBar setShadowImage:[UIImage new]];
                [self.navigationController pushViewController:Identification animated:YES];
            }
            if ([[_userDefaults objectForKey:@"isBigV"]isEqualToString:@"1"]) {
                InReviewViewController *inreview = [[InReviewViewController alloc]init];
                [self.navigationController pushViewController:inreview animated:YES];
            }
            if ([[_userDefaults objectForKey:@"isBigV"]isEqualToString:@"2"]) {
                AuditFailureViewController *AuditFailure = [[AuditFailureViewController alloc]init];
                [self.navigationController pushViewController:AuditFailure animated:YES];
                
            }if ([[_userDefaults objectForKey:@"isBigV"]isEqualToString:@"3"]) {
                if ([[_userDefaults objectForKey:@"price"] intValue] >0) {
                    //已经设置了M币了
                    NSLog(@"已经设置M币了我草特码了不能点了");
                }else{
                    AuditSuccessViewController *AuditSuccess = [[AuditSuccessViewController alloc]init];
                    [self.navigationController pushViewController:AuditSuccess animated:YES];
                }
                
            }
          
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //客服
//            RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
//            chatService.userName = @"客服";
//            chatService.conversationType = ConversationType_CUSTOMERSERVICE;
//            chatService.targetId = @"KEFU151540013396895";
//            chatService.title = chatService.userName;
//            [self.navigationController pushViewController :chatService animated:YES];
        }
        if (indexPath.row == 1) {
            //帮助
//            HelpViewController *help = [[HelpViewController alloc]init];
//            [self.navigationController pushViewController:help animated:YES];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            //设置
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
            SettingTableViewController *set = [story instantiateViewControllerWithIdentifier:@"SettingTableViewController"];
            [self.navigationController pushViewController:set animated:YES];
        }
        if (indexPath.row == 1) {
            //版本更新
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前已是最新版本" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    if (indexPath.section == 3) {
        //退出登录
//        [self.navigationController popToRootViewControllerAnimated:YES];
        
        [_userDefaults setObject:@"0" forKey:@"isBigV"];
        [_userDefaults setObject:@"no" forKey:@"isLog"];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"isBigV",@"no",@"isLog", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KSwitchRootViewControllerNotification" object:nil userInfo:dic];
        NSLog(@"退出登录");
    }
}

//编辑资料
- (IBAction)edit:(id)sender {
    edttViewController *edit = [[edttViewController alloc]init];
    [self.navigationController pushViewController:edit animated:YES];
}





@end
