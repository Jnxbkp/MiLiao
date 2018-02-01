//
//  IdentificationVController.m
//  MiLiao
//
//  Created by apple on 2018/1/6.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "IdentificationVController.h"
#import "IQActionSheetPickerView.h"
#import "HXProvincialCitiesCountiesPickerview.h"

#import "HXAddressManager.h"
#import "introduceViewController.h"
#import "signViewController.h"
#import "TagViewController.h"
#import "InReviewViewController.h"
static NSString *kTempFolder = @"touxiang";

@interface IdentificationVController ()<IQActionSheetPickerViewDelegate,UIImagePickerControllerDelegate>
{
    OSSClient * client;
    NSUserDefaults *_userDefaults;
    NSMutableArray *posters;
    NSString *provincename;
    NSString *cityname;
    NSUInteger BtnTag;
    OSSGetBucketResult * result;
}
@property(nonatomic,strong)NSData *imageData;

@property(nonatomic,strong)NSString *AccessKeyId;
@property(nonatomic,strong)NSString *AccessKeySecret;
@property(nonatomic,strong)NSString *SecurityToken;
//身高
@property (nonatomic, copy) NSString * strM;
@property (nonatomic, copy) NSString * strCM;
//体重
@property (nonatomic, copy) NSString * weighOne;
@property (nonatomic, copy) NSString * weighTwo;

////////
@property(nonatomic,strong)NSString *country;

@property(nonatomic,strong)NSString *item1String;
@property(nonatomic,strong)NSString *item2String;
@property(nonatomic,strong)NSString *item3String;
@property(nonatomic,strong)NSString *item4String;
@property(nonatomic,strong)NSString *item5String;
@property(nonatomic,strong)NSString *item6String;

@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *sixBtn;
@property (weak, nonatomic) IBOutlet UIButton *eightBtn;
@property (weak, nonatomic) IBOutlet UILabel *hetght;
@property (weak, nonatomic) IBOutlet UILabel *weight;
@property (weak, nonatomic) IBOutlet UILabel *star;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *peopleJieshao;
@property (weak, nonatomic) IBOutlet UILabel *sign;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *tags;
@property(nonatomic,strong)NSString *tag1;
@property(nonatomic,strong)NSString *tag2;
@property(nonatomic,strong)NSArray *arr;
@property (weak, nonatomic) IBOutlet UITextField *wx;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property(nonatomic,strong)NSMutableArray *photoMuArray;
@property(nonatomic,strong)UIImageView *imageViewOne;
@property(nonatomic,strong)UIImageView *imageViewTwo;
@property(nonatomic,strong)UIImageView *imageViewThree;
@property(nonatomic,strong)UIImageView *imageViewFour;
@property(nonatomic,strong)UIImageView *imageViewFive;
@property(nonatomic,strong)UIImageView *imageViewSix;

@property (nonatomic,strong) HXProvincialCitiesCountiesPickerview *regionPickerView;

@end

@implementation IdentificationVController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationVTags:) name:@"VTags" object:nil];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.oneBtn setTag:1];
    [self.twoBtn setTag:2];
    [self.fourBtn setTag:3];
    [self.fiveBtn setTag:4];
    [self.sixBtn setTag:5];
    [self.eightBtn setTag:6];
   
    
    self.item1String = @"";
    self.item2String = @"";
    self.item3String = @"";
    self.item4String = @"";
    self.item5String = @"";
    self.item6String = @"";

    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"编辑认证资料"];
    _userDefaults = [NSUserDefaults standardUserDefaults];
   posters = [[NSMutableArray alloc]init];//图片集合
    self.phoneNumber.text = [_userDefaults objectForKey:@"username"];
    self.headerView.height = (WIDTH-48)/3*2+36;
    [self loData];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

   
}
- (void)loData
{
    NSString *token = [_userDefaults objectForKey:@"token"];
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
//提交认证申请
- (IBAction)commit:(id)sender {
    if ([self.sign.text isEqualToString:@"请设置个性签名(必填)"]) {
        self.sign.text = @"";
    }
    if ([self.peopleJieshao.text isEqualToString:@"请编辑个人介绍(必填)"]) {
        self.peopleJieshao.text = @"";
    }
    if ([self.country isEqualToString:@"中国"])
     {
         if ([provincename isEqualToString:@"北京"]) {
             [HLLoginManager NetPostupdateV:self.country province:provincename city:provincename constellation:self.star.text description:self.peopleJieshao.text height:@([ self.hetght.text integerValue]) nickName:self.nickName.text personalSign:self.sign.text personalTags:self.arr posters:posters token:[_userDefaults objectForKey:@"token"] weight: @([self.weight.text integerValue]) wechat:self.wx.text success:^(NSDictionary *info) {
                 NSInteger resultCode = [info[@"resultCode"] integerValue];
                 if (resultCode == SUCCESS) {
                     InReviewViewController *inreview = [[InReviewViewController alloc]init];
                     [self.navigationController pushViewController:inreview animated:YES];
                 }else{
                     [SVProgressHUD showErrorWithStatus:info[@"resultMsg"]];

                 }
             } failure:^(NSError *error) {
                 NSLog(@"%@",error);
             }];
         }else if ([provincename isEqualToString:@"上海"])
         {
             [HLLoginManager NetPostupdateV:self.country province:provincename city:provincename constellation:self.star.text description:self.peopleJieshao.text height: @([ self.hetght.text integerValue]) nickName:self.nickName.text personalSign:self.sign.text personalTags:self.arr posters:posters token:[_userDefaults objectForKey:@"token"] weight: @([self.weight.text integerValue]) wechat:self.wx.text success:^(NSDictionary *info) {
                 NSInteger resultCode = [info[@"resultCode"] integerValue];
                 if (resultCode == SUCCESS) {
                     InReviewViewController *inreview = [[InReviewViewController alloc]init];
                     [self.navigationController pushViewController:inreview animated:YES];
                 }else{
                     [SVProgressHUD showErrorWithStatus:info[@"resultMsg"]];

                 }
             } failure:^(NSError *error) {
                 NSLog(@"%@",error);
             }];
         }else if ([provincename isEqualToString:@"天津"])
         {
             [HLLoginManager NetPostupdateV:self.country province:provincename city:provincename constellation:self.star.text description:self.peopleJieshao.text height: @([ self.hetght.text integerValue]) nickName:self.nickName.text personalSign:self.sign.text personalTags:self.arr posters:posters token:[_userDefaults objectForKey:@"token"] weight: @([self.weight.text integerValue]) wechat:self.wx.text success:^(NSDictionary *info) {
                 NSInteger resultCode = [info[@"resultCode"] integerValue];
                 if (resultCode == SUCCESS) {
                     InReviewViewController *inreview = [[InReviewViewController alloc]init];
                     [self.navigationController pushViewController:inreview animated:YES];
                 }else{
                     [SVProgressHUD showErrorWithStatus:info[@"resultMsg"]];

                 }
             } failure:^(NSError *error) {
                 NSLog(@"%@",error);
             }];
         }else if ([provincename isEqualToString:@"重庆"])
         {
             [HLLoginManager NetPostupdateV:self.country province:provincename city:provincename constellation:self.star.text description:self.peopleJieshao.text height: @([ self.hetght.text integerValue]) nickName:self.nickName.text personalSign:self.sign.text personalTags:self.arr posters:posters token:[_userDefaults objectForKey:@"token"] weight: @([self.weight.text integerValue]) wechat:self.wx.text success:^(NSDictionary *info) {
                 NSInteger resultCode = [info[@"resultCode"] integerValue];
                 if (resultCode == SUCCESS) {
                     InReviewViewController *inreview = [[InReviewViewController alloc]init];
                     [self.navigationController pushViewController:inreview animated:YES];
                 }else{
                     [SVProgressHUD showErrorWithStatus:info[@"resultMsg"]];

                 }
             } failure:^(NSError *error) {
                 NSLog(@"%@",error);
             }];
         }else{
             [HLLoginManager NetPostupdateV:self.country province:provincename city:cityname constellation:self.star.text description:self.peopleJieshao.text height: @([ self.hetght.text integerValue]) nickName:self.nickName.text personalSign:self.sign.text personalTags:self.arr posters:posters token:[_userDefaults objectForKey:@"token"] weight: @([self.weight.text integerValue]) wechat:self.wx.text success:^(NSDictionary *info) {
                 NSLog(@"%@",info);
                 NSLog(@"12122121%@",info[@"resultMsg"]);
                 NSInteger resultCode = [info[@"resultCode"] integerValue];
                 if (resultCode == SUCCESS) {
                     InReviewViewController *inreview = [[InReviewViewController alloc]init];
                     [self.navigationController pushViewController:inreview animated:YES];
                 }else{
                     [SVProgressHUD showErrorWithStatus:info[@"resultMsg"]];

                 }
                

             } failure:^(NSError *error) {
                 NSLog(@"%@",error);
             }];
         }
       
     }
    if ([self.country isEqualToString:@"国外"]) {
        [HLLoginManager NetPostupdateV:self.country province:provincename city:provincename constellation:self.star.text description:self.peopleJieshao.text height: @([ self.hetght.text integerValue]) nickName:self.nickName.text personalSign:self.sign.text personalTags:self.arr posters:posters token:[_userDefaults objectForKey:@"token"] weight: @([self.weight.text integerValue]) wechat:self.wx.text success:^(NSDictionary *info) {
            NSLog(@"%@",info);
            NSInteger resultCode = [info[@"resultCode"] integerValue];
            if (resultCode == SUCCESS) {
                InReviewViewController *inreview = [[InReviewViewController alloc]init];
                [self.navigationController pushViewController:inreview animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:info[@"resultMsg"]];

            }
          

        } failure:^(NSError *error) {
            
        }];
    }
    else{
       
    }
   
    
}
- (void)notificationVTags:(NSNotification *)note {
    self.arr = [note.userInfo objectForKey:@"VTags"];
    NSLog(@"----%@", self.arr);
    if (self.arr.count == 1) {
        self.tag1 = [ self.arr objectAtIndex:0];
        self.tags.text = [NSString stringWithFormat:@"%@",self.tag1];

    }
    if (self.arr.count == 2) {
        self.tag1 = [ self.arr objectAtIndex:0];
        self.tag2 = [ self.arr objectAtIndex:1];
        self.tags.text = [NSString stringWithFormat:@"%@  %@",self.tag1,self.tag2];

    }
    [self.tableView reloadData];
}
//上传图片
- (IBAction)photo:(UIButton *)sender {
     BtnTag = [sender tag];

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
#pragma mark - UIImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *avatar = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(avatar)) {
        //返回为png图像。
        UIImage *imagenew = [self imageWithImageSimple:avatar scaledToSize:CGSizeMake((WIDTH-48)/3, (WIDTH-48)/3)];
        self.imageData = UIImagePNGRepresentation(imagenew);
    }else {
        //返回为JPEG图像。
        UIImage *imagenew = [self imageWithImageSimple:avatar scaledToSize:CGSizeMake((WIDTH-48)/3, (WIDTH-48)/3)];
        self.imageData = UIImageJPEGRepresentation(imagenew, 0.8);
    }
    // 参数设置
    NSString *endpoint = @"http://oss-cn-beijing.aliyuncs.com";
    // 明文设置secret的方式建议只在测试时使用，更多鉴权模式参考后面链接给出的官网完整文档的`访问控制`章节
    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:self.AccessKeyId secretKeyId:self.AccessKeySecret securityToken:self.SecurityToken];
    client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = @"xbkp-nihao";
    NSString *fileName = [NSString stringWithFormat:@"renzhengdav/%ld%c%c.jpg", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
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
            result = task.result;
            NSLog(@"%@",result);
            [self takePhoto];
            //把图片路径添加到数组
            self.photoMuArray = [[NSMutableArray alloc] initWithObjects:
                                            self.item1String,
                                            self.item2String,
                                            self.item3String,
                                            self.item4String,
                                            self.item5String,
                                            self.item6String,
                                            nil];
            [posters removeAllObjects];
            for (NSString *photoUrl in  self.photoMuArray) {
                if (photoUrl.length > 0) {
                    [posters addObject:photoUrl];
                }
            }
            NSLog(@"%@",posters);
        }
        else {
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
}
- (void)takePhoto {
    if (BtnTag == 1) {
        self.item1String = [NSString stringWithFormat:@"%@",result];
        [self.oneBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.item1String]] forState:UIControlStateNormal];
        self.imageViewOne = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuaxin"]];
        self.imageViewOne.frame = CGRectMake(0, 0, 34, 34);
        [self.oneBtn addSubview:self.imageViewOne];
   }
    if (BtnTag == 2) {
       self.item2String = [NSString stringWithFormat:@"%@",result];
        [self.twoBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.item2String]] forState:UIControlStateNormal];
        self.imageViewTwo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guanbi"]];
        self.imageViewTwo.frame = CGRectMake(0, 0, 34, 34);
        [self.twoBtn addSubview:self.imageViewTwo];
    }

    if (BtnTag == 3) {
        self.item3String = [NSString stringWithFormat:@"%@",result];
        [self.fourBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.item3String]] forState:UIControlStateNormal];
        self.imageViewThree = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guanbi"]];
        self.imageViewThree.frame = CGRectMake(0, 0, 34, 34);
        [self.fourBtn addSubview:self.imageViewThree];
    }
    if (BtnTag == 4) {
        self.item4String = [NSString stringWithFormat:@"%@",result];
        [self.fiveBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.item4String]] forState:UIControlStateNormal];
        self.imageViewFour = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guanbi"]];
        self.imageViewFour.frame = CGRectMake(0, 0, 34, 34);
        [self.fiveBtn addSubview:self.imageViewFour];
   }
    if (BtnTag == 5) {
        self.item5String = [NSString stringWithFormat:@"%@",result];
        [self.sixBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.item5String]] forState:UIControlStateNormal];
        self.imageViewFive = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guanbi"]];
        self.imageViewFive.frame = CGRectMake(0, 0, 34, 34);
        [self.sixBtn addSubview:self.imageViewFive];
  }

    if (BtnTag == 6) {
        self.item6String = [NSString stringWithFormat:@"%@",result];
        [self.eightBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.item6String]] forState:UIControlStateNormal];
        self.imageViewSix = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guanbi"]];
        self.imageViewSix.frame = CGRectMake(0, 0, 34, 34);
        [self.eightBtn addSubview:self.imageViewSix];
  }

    [self.tableView reloadData];
    
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
 *  @return <#return value description#>
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
//监听滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];

}
//点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        //手机
    }
    if (indexPath.row == 2) {
    }
      if (indexPath.row == 3) {
          //身高
          IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"" delegate:self];
          [picker setTag:2];
          picker.toolbarTintColor = [UIColor whiteColor];
          picker.titleColor = [UIColor whiteColor];
          //        picker.titleFont = [UIFont systemFontOfSize:16];
          picker.toolbarButtonColor = [UIColor blackColor];
          [picker setIsRangePickerView:YES];
          [picker setTitlesForComponents:@[@[@"1"],@[@"80",@"79",@"78",@"77",@"76",@"75",@"74",@"73",@"72",@"71",@"70",@"69",@"68",@"67",@"66",@"65",@"64",@"63",@"62",@"61",@"60"],@[@"cm"]]];
          [picker selectIndexes:@[[NSNumber numberWithInt:0],[NSNumber numberWithInt:12]] animated:YES];
          [picker show];
          
         
      }
    if (indexPath.row == 4) {
        //体重
        IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"" delegate:self];
        [picker setTag:3];
        picker.toolbarTintColor = [UIColor whiteColor];
        picker.titleColor = [UIColor whiteColor];
        //        picker.titleFont = [UIFont systemFontOfSize:16];
        picker.toolbarButtonColor = [UIColor blackColor];
        [picker setIsRangePickerView:YES];
        [picker setTitlesForComponents:@[@[@"60",@"59",@"58",@"57",@"56",@"55",@"54",@"53",@"52",@"51",@"50",@"49",@"48",@"47",@"46",@"45",@"44",@"43",@"42",@"41",@"40"],@[@"KG"]]];
        [picker selectIndexes:@[[NSNumber numberWithInt:15]] animated:YES];
        [picker show];
        
    }
    if (indexPath.row == 5) {
        //星座
        IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"" delegate:self];
        [picker setTag:4];
        picker.toolbarTintColor = [UIColor whiteColor];
        picker.titleColor = [UIColor whiteColor];
        //        picker.titleFont = [UIFont systemFontOfSize:16];
        picker.toolbarButtonColor = [UIColor blackColor];
        [picker setIsRangePickerView:YES];
        [picker setTitlesForComponents:@[@[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"]]];
        [picker show];
       

    }
    if (indexPath.row == 6) {
        NSString *address = @"北京";
        NSArray *array = [address componentsSeparatedByString:@" "];
        
        NSString *province = @"";//省
        NSString *city = @"";//市
        NSString *county = @"";//县
        if (array.count > 2) {
            province = array[0];
            city = array[1];
            county = array[2];
        } else if (array.count > 1) {
            province = array[0];
            city = array[1];
        } else if (array.count > 0) {
            province = array[0];
        }
        [self.regionPickerView showPickerWithProvinceName:province cityName:city countyName:county];
       
    }
    if (indexPath.row == 7) {
        introduceViewController *intro = [[introduceViewController alloc]init];
        intro.backBlock = ^(NSString *text) {
            self.peopleJieshao.text = text;
            //            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        };
        [self.navigationController pushViewController:intro animated:YES];
        
    }
    if (indexPath.row == 8) {
        //形象标签
        TagViewController *tag = [[TagViewController alloc]init];
        tag.backBlock1 = ^(NSString *text) {
            self.tag1 = text;
        };
        tag.backBlock2 = ^(NSString *text) {
            self.tag2 = text;
        };
        [self.navigationController pushViewController:tag animated:YES];
       
    }
    if (indexPath.row == 9) {
        signViewController *sign = [[signViewController alloc]init];
        sign.backBlock = ^(NSString *text) {
            self.sign.text = text;
        };
        [self.navigationController pushViewController:sign animated:YES];
    }
}
- (HXProvincialCitiesCountiesPickerview *)regionPickerView {
    if (!_regionPickerView) {
        _regionPickerView = [[HXProvincialCitiesCountiesPickerview alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        __weak typeof(self) wself = self;
        _regionPickerView.completion = ^(NSString *provinceName,NSString *cityName) {
            __strong typeof(wself) self = wself;
            if ([provinceName isEqualToString:@"国外"]) {
                self.country = @"国外";
                provincename = cityName;
             
                self.city.text = [NSString stringWithFormat:@"%@%@",self.country,cityName];

            }else{
                self.country = @"中国";
                provincename = provinceName;
                cityname = cityName;
                self.city.text = [NSString stringWithFormat:@"%@%@%@",self.country,provinceName,cityName];

            }
        };
        [self.navigationController.view addSubview:_regionPickerView];
    }
    return _regionPickerView;
}

#pragma mark - IQActionSheetPickerViewDelegate

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles
{
    NSLog(@"%@",titles);
    if (pickerView.tag == 2) {
        self.strM = [titles objectAtIndex:0];
        self.strCM = [titles objectAtIndex:1];

        self.hetght.text = [NSString stringWithFormat:@"%@%@cm", self.strM,self.strCM];
    }
    if (pickerView.tag == 3) {
        self.weighOne = [titles objectAtIndex:0];
//        self.weighTwo = [titles objectAtIndex:1];
        self.weight.text = [NSString stringWithFormat:@"%@KG", self.weighOne];

    }
    if (pickerView.tag == 4) {
        self.star.text = [titles lastObject];

    }
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(BOOL)shouldAutorotate
{
    return YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES];
//}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [self.view endEditing:YES];
//    return YES;
//}
@end

