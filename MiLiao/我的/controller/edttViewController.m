//
//  edttViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/4.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "edttViewController.h"
#import "NickNameViewController.h"
#import <RongIMKit/RongIMKit.h>

#define iconImageWH 60

static NSString *kTempFolder = @"touxiang";

@interface edttViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate, UITableViewDataSource>
{
    OSSClient * client;
    
    NSUserDefaults *_userDefaults;
    
    
}
@property (nonatomic, weak)UITableView * tableView;
@property(nonatomic,strong)UIButton *LogoutButton;

//用户头像
@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)NSData *imageData;

@property(nonatomic,strong)NSString *AccessKeyId;
@property(nonatomic,strong)NSString *AccessKeySecret;
@property(nonatomic,strong)NSString *SecurityToken;
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,strong)NSString *headerUrl;
@property (assign,nonatomic) BOOL dianji;

@end

@implementation edttViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"编辑资料"];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    [self setCustomView];
    //初始化尾部视图
    [self setupFootView];
}
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
//}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.headerUrl = [_userDefaults objectForKey:@"headUrl"];
    NSString *nickname = [_userDefaults objectForKey:@"nickname"];

    self.nickName = nickname;
}
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    //在其他离开改页面的方法同样加上下面代码
//    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//}
//初始化尾部视图
-(void)setupFootView
{
    UIView *footView=[UIView new];
    footView.frame=CGRectMake(0, 0, WIDTH, 130);
//    footView.backgroundColor = [UIColor grayColor];
    self.LogoutButton=[[UIButton alloc]initWithFrame:CGRectMake(50, 50, WIDTH-100, 40)];
    self.LogoutButton.backgroundColor=[UIColor redColor];
    self.LogoutButton.layer.masksToBounds=YES;
    self.LogoutButton.layer.cornerRadius=5.0;
    [self.LogoutButton addTarget:self action:@selector(LogoutButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.LogoutButton setTitle:@"提交" forState:(UIControlStateNormal)];
    [footView addSubview:self.LogoutButton];
    self.tableView.tableFooterView=footView;

}
- (void)LogoutButtonClick
{
    self.dianji = YES;
    //id
    [HLLoginManager NetPostupdateHeadUrl:[_userDefaults objectForKey:@"headUrl"] nickName:self.nickName token:[_userDefaults objectForKey:@"token"] success:^(NSDictionary *info) {
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        NSLog(@"----------------%@",info);
        if (resultCode == SUCCESS) {
            //把自己信息存起来
//            [self RCIM_currentUserInfo:info[@"data"][@"id"]];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:info[@"resultMsg"]];

        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)RCIM_currentUserInfo:(NSString *)userId {
    [HLLoginManager NetGetgetUserInfoToken:[_userDefaults objectForKey:@"token"] UserId:userId success:^(NSDictionary *info) {
        NSLog(@"%@",info);
        //nickname headUrl
        RCUserInfo *_currentUserInfo =
        [[RCUserInfo alloc] initWithUserId:userId
                                      name:[_userDefaults objectForKey:@"nickname"]
                                  portrait:[_userDefaults objectForKey:@"headUrl"]];
        [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;
    } failure:^(NSError *error) {
        
    }];
}
- (void)setCustomView{
    UITableView * tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    tableView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    [HLLoginManager NetGetgetOSSToken:token success:^(NSDictionary *info) {
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        NSLog(@"----------------%@",info);
        
        if (resultCode == SUCCESS) {
            
            self.AccessKeyId = info[@"data"][@"AccessKeyId"];
            self.AccessKeySecret = info[@"data"][@"AccessKeySecret"];
            self.SecurityToken = info[@"data"][@"SecurityToken"];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"拍  照"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"抱歉，您的设备没有摄像头" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
                [alert show];
                return;
            }
            UIImagePickerController *controller = [[UIImagePickerController alloc]init];
            [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
            [controller setAllowsEditing:YES];
            [controller setDelegate:self];
            [self presentViewController:controller animated:YES completion:nil];
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *controller = [[UIImagePickerController alloc]init];
            [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [controller setAllowsEditing:YES];
            [controller setDelegate:self];
            [self presentViewController:controller animated:YES completion:nil];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];

    }
    if (indexPath.row == 1) {
        [self.view endEditing:YES];
        NickNameViewController *nick = [[NickNameViewController alloc]init];
        nick.backBlock = ^(NSString *text) {
        self.nickName = text;
        [_userDefaults setObject:self.nickName forKey:@"nickname"];

        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        };
        [self.navigationController pushViewController:nick animated:YES];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellID=@"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier: cellID];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.textLabel.text=@"头像";
            self.iconImage=[[UIImageView alloc] init];
            NSLog(@"----------%@",_headerUrl);
            // store_img
            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.headerUrl]] placeholderImage:[UIImage imageNamed:@"my_head_icon"] options:SDWebImageRefreshCached];
            [cell.contentView addSubview:self.iconImage];
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            self.iconImage.layer.cornerRadius = 30;
            self.iconImage.layer.masksToBounds = YES;
            self.iconImage.sd_layout
            .centerYIs(85 / 2)
            .rightSpaceToView(cell.contentView, 10)
            .widthIs(iconImageWH)
            .heightIs(iconImageWH);
        }
        return cell;
    }else{
        static NSString *cellID=@"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell)
        {
            cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier: cellID];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        //第一个分区
        cell.textLabel.text=@"昵称";
        cell.detailTextLabel.text=self.nickName;
        
        return cell;
    }
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 85;
        
    }
    
    return 47;
    
}
#pragma mark - UIImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *avatar = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(avatar)) {
        //返回为png图像。
        UIImage *imagenew = [self imageWithImageSimple:avatar scaledToSize:CGSizeMake(200, 200)];
        self.imageData = UIImagePNGRepresentation(imagenew);
    }else {
        //返回为JPEG图像。
        UIImage *imagenew = [self imageWithImageSimple:avatar scaledToSize:CGSizeMake(200, 200)];
        self.imageData = UIImageJPEGRepresentation(imagenew, 0.1);
    }
// 参数设置
    NSString *endpoint = @"http://oss-cn-beijing.aliyuncs.com";
    // 明文设置secret的方式建议只在测试时使用，更多鉴权模式参考后面链接给出的官网完整文档的`访问控制`章节
   id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:self.AccessKeyId secretKeyId:self.AccessKeySecret securityToken:self.SecurityToken];
    client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = @"xbkp-nihao";
    NSString *fileName = [NSString stringWithFormat:@"touxiang/%ld%c%c.jpg", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
    put.objectKey = fileName;
    put.uploadingData = self.imageData;
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        task = [client presignPublicURLWithBucketName:@"xbkp-nihao"
                                        withObjectKey:fileName];
        NSLog(@"objectKey: %@", put.objectKey);
        if (!task.error) {
            OSSGetBucketResult * result = task.result;
            NSLog(@"%@",result);
            self.headerUrl = [NSString stringWithFormat:@"%@",result];
            [_userDefaults setObject:self.headerUrl forKey:@"headUrl"];
            NSLog(@"------>>>%@",self.headerUrl);
            [self takePhoto];

            NSLog(@"upload object success!");
            
        }
        else {
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
}
/**
 *  压缩图片尺寸
 *
 *  @param image   图片
 *  @param newSize 大小
 *
 *  @return 真实图片
 */
- (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/**
 *  返回当前时间
 *
 *  @return return value description
 */
- (NSString *)getTimeNow
{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    date = [formatter stringFromDate:[NSDate date]];
    //取出个随机数
    int last = arc4random() % 10000;
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@-%i", date,last];
    NSLog(@"%@", timeNow);
    return timeNow;
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)takePhoto {
    NSLog(@"------23213123123>>>%@",self.headerUrl);
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.headerUrl]] placeholderImage:[UIImage imageNamed:@"my_head_icon"] options:SDWebImageRefreshCached];
//    [self.tableView reloadData];
}
@end
