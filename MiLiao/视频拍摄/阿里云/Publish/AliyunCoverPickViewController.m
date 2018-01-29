//
//  AliyunCoverPickViewController.m
//  qusdk
//
//  Created by Worthy on 2017/11/7.
//  Copyright © 2017年 Alibaba Group Holding Limited. All rights reserved.
//

#import "AliyunCoverPickViewController.h"
#import "AliyunPublishTopView.h"
#import "AliyunCoverPickView.h"

#import <VODUpload/VODUploadSVideoClient.h>
#import <sys/utsname.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define buttonTag   2000
@interface AliyunCoverPickViewController () <AliyunPublishTopViewDelegate, AliyunCoverPickViewDelegate,UITextFieldDelegate,VODUploadSVideoClientDelegate> {
    UIView *_line;
    UILabel *_label;
    NSUserDefaults      *_userDefaults;
}
@property (nonatomic, strong) AliyunPublishTopView *topView;
@property (nonatomic, strong) UIImageView *coverView;
@property (nonatomic, strong) AliyunCoverPickView *pickView;
@property (nonatomic, strong) UITextField *titleView;

@property (nonatomic, strong) VODUploadSVideoClient *client;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIView    *backGroundView;

@end

@implementation AliyunCoverPickViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = ML_Color(97, 97, 97, 1);
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ML_Color(97, 97, 97, 1);
    _userDefaults = [NSUserDefaults standardUserDefaults];
     [self addNotifications];
    [self setupSubviews];
    _client = [[VODUploadSVideoClient alloc] init];
    _client.delegate = self; dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.pickView loadThumbnailData];
    });
}

- (void)setupSubviews {
    self.topView = [[AliyunPublishTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, StatusBarHeight+44)];
    
    self.topView.nameLabel.text = @"封面和标题";

    [self.topView.cancelButton setTitle:@"" forState:UIControlStateNormal];

    [self.topView.finishButton setTitle:@"" forState:UIControlStateNormal];
    self.topView.delegate = self;
    self.topView.delegate = self;
    [self.view addSubview:self.topView];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(15, 27, 40, 30);
    [_backButton setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backBarButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    CGFloat pickWith = ScreenWidth - 56;
//    CGFloat factor = _outputSize.height/_outputSize.width;
    CGFloat factor = 16/9;

    CGFloat width = ScreenWidth;
    CGFloat heigt = ScreenWidth * factor;
    CGFloat maxheight = ScreenHeight-StatusBarHeight-69-SafeBottom -pickWith/8 - 30;
    
    if(heigt > maxheight){
        heigt = maxheight;
        width = heigt / factor;
    }
    CGFloat offset = (maxheight-heigt)/2;
   
    self.coverView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH-(9*heigt)/16)/2, StatusBarHeight+44+offset, (9*heigt)/16, heigt)];
    [self.view addSubview:self.coverView];
    
    
    self.pickView = [[AliyunCoverPickView alloc] initWithFrame:CGRectMake(28, self.coverView.frame.origin.y+self.coverView.frame.size.height+20, pickWith, pickWith/8)];
    self.pickView.delegate = self;
    self.pickView.videoPath = _videoPath;
    self.pickView.outputSize = _outputSize;
   
    [self.view addSubview:self.pickView];
//    self.view.backgroundColor = [AliyunIConfig config].backgroundColor;
    
    self.titleView = [[UITextField alloc] initWithFrame:CGRectMake(_coverView.frame.origin.x+5, _pickView.frame.origin.y-100, _coverView.frame.size.width-10, 54)];
    self.titleView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"点击输入标题..." attributes:@{NSForegroundColorAttributeName: rgba(188, 190, 197, 1)}];
    self.titleView.tintColor = [AliyunIConfig config].timelineTintColor;;
    self.titleView.textColor = [UIColor whiteColor];
    [self.titleView setFont:[UIFont systemFontOfSize:14]];
    self.titleView.returnKeyType = UIReturnKeyDone;
    self.titleView.delegate = self;
    self.titleView.backgroundColor = [AliyunIConfig config].backgroundColor;
    [self.view addSubview:self.titleView];
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(_coverView.frame.origin.x+5, _titleView.frame.origin.y+_titleView.frame.size.height-2, _titleView.frame.size.width, 1)];
    _line.backgroundColor = rgba(90, 98, 120, 1);
    [self.view addSubview:_line];
    _label = [[UILabel alloc] initWithFrame:CGRectMake(_titleView.frame.origin.x, _line.frame.origin.y+3, _line.frame.size.width, 14)];
    _label.textColor = rgba(110, 118, 139, 1);
    _label.text = @"最多不超过20个字";
    _label.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:_label];
    
    _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, HEIGHT/4, WIDTH-40, 20)];
    _stateLabel.textColor = [UIColor whiteColor];
    _stateLabel.font = [UIFont systemFontOfSize:14.0];
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    
    
    NSArray *buttonArr = [NSArray arrayWithObjects:@"保存",@"发布", nil];
    for (int i = 0; i < buttonArr.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = buttonTag+i;
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [button setTitle:buttonArr[i] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5.0;
        [button addTarget:self action:@selector(buttonSelect:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.frame = CGRectMake(28, HEIGHT-62, 75, 34);
            button.backgroundColor = NavColor;
            [button setTitleColor:Color255 forState:UIControlStateNormal];
        } else {
            button.frame = CGRectMake(WIDTH-28-75, HEIGHT-62, 75, 34);
            button.backgroundColor = NavColor;
            [button setTitleColor:Color255 forState:UIControlStateNormal];
        }
        [self.view addSubview:button];
    }
    _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _backGroundView.backgroundColor = ML_Color(0, 0, 0, 0.49);
    _backGroundView.hidden = YES;
    [self.view addSubview:_backGroundView];
    
    [self.view addSubview:_stateLabel];
    
}
#pragma mark - 下方按钮点击
- (void)buttonSelect:(UIButton *)button {
    if (button.tag == buttonTag) {
        if ([self isCanUsePhotos]) {
            [self saveVideo:_videoPath];
        } else {
            PHFetchResult *fetchResult = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
          
        }
        
    } else {
        if (_titleView.text.length > 0&&_titleView.text.length <= 20) {
            _stateLabel.hidden = NO;
            _stateLabel.text = @"";
            _backGroundView.hidden = NO;
            _finishHandler(_coverView.image);
            NSString *coverPath = [_taskPath stringByAppendingPathComponent:@"cover.png"];
            NSData *data = UIImagePNGRepresentation(_coverView.image);
            [data writeToFile:coverPath atomically:YES];
            //    NSLog(@"---------------%@",_coverView.image);
            [PublicManager NetGetgetOSSVideoToken:[_userDefaults objectForKey:@"token"] success:^(NSDictionary *info) {
                NSInteger resultCode = [info[@"resultCode"] integerValue];
                NSLog(@"-----%@",info);
                if (resultCode == SUCCESS) {
               
                    NSString *keyId = [[info objectForKey:@"data"] objectForKey:@"AccessKeyId"];
                    NSString *AccessKeySecret = [[info objectForKey:@"data"] objectForKey:@"AccessKeySecret"];
                    NSString *SecurityToken = [[info objectForKey:@"data"] objectForKey:@"SecurityToken"];
                    VodSVideoInfo *info = [VodSVideoInfo new];
                    info.title = _titleView.text;
                    
                    [_client uploadWithVideoPath:_videoPath imagePath:coverPath svideoInfo:info accessKeyId:keyId accessKeySecret:AccessKeySecret accessToken:SecurityToken];
                } else {
                    
                }
                
            } failure:^(NSError *error) {
                NSLog(@"error%@",error);
            }];
        } else {
            _stateLabel.hidden = NO;
            _stateLabel.text = @"视频标题格式不正确";
        }
        
    }
}
//videoPath为视频下载到本地之后的本地路径
- (void)saveVideo:(NSString *)videoPath{
    if (_videoPath) {
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(_videoPath)) {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum(_videoPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
        
    }
}
//保存视频完成之后的回调
- (void)video:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        [self videoSaveAlert:@"保存视频失败"];
        NSLog(@"保存视频失败%@", error.localizedDescription);
    }
    else {
         [self videoSaveAlert:@"保存视频成功"];
        NSLog(@"保存视频成功");
    }
    
}
- (BOOL)isCanUsePhotos {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}
- (void)videoSaveAlert:(NSString *)str {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancleAction];
   [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - notification

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)backBarButtonSelect:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)keyboardWillShow:(NSNotification *)note {
   
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSValue *aValue = [note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
 
//    if (offset<0) {
        [UIView animateWithDuration:duration animations:^{
            _titleView.frame = CGRectMake(_coverView.frame.origin.x+5, HEIGHT-height, _coverView.frame.size.width-10, 54);
            _line.frame = CGRectMake(_titleView.frame.origin.x, _titleView.frame.origin.y+_titleView.frame.size.height-2, _titleView.frame.size.width, 1);
            _label.frame = CGRectMake(_titleView.frame.origin.x, _line.frame.origin.y+3, _titleView.frame.size.width, 14);
            
        }];
//    }
}

- (void)keyboardWillHide:(NSNotification *)note {
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        _titleView.frame = CGRectMake(_coverView.frame.origin.x+5,_pickView.frame.origin.y-100, _coverView.frame.size.width-10, 54);
        _line.frame = CGRectMake(_titleView.frame.origin.x, _titleView.frame.origin.y+_titleView.frame.size.height-2, _titleView.frame.size.width, 1);
        _label.frame = CGRectMake(_titleView.frame.origin.x, _line.frame.origin.y+3, _titleView.frame.size.width, 14);
    }];
}
#pragma mark - top view delegate

-(void)cancelButtonClicked {

}

-(void)finishButtonClicked {

}
- (void)pauseClicked {
    [_client pause];
}
- (void)resumeClicked {
    [_client resume];
}
- (void)cancelClicked {
    [_client cancel];
}
#pragma mark - callback

-(void)uploadFailedWithCode:(NSString *)code message:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        _stateLabel.text = [NSString stringWithFormat:@"failed:%@",message];
        _backGroundView.hidden = YES;
        NSLog(@"------error>>%@",message);
    });
}

-(void)uploadSuccessWithVid:(NSString *)vid imageUrl:(NSString *)imageUrl {
    NSLog(@"wz successvid:%@, imageurl:%@",vid, imageUrl);
    dispatch_async(dispatch_get_main_queue(), ^{
        _stateLabel.text = [NSString stringWithFormat:@"success"];
        
        [HLLoginManager NetPostSaveVideotoken:[_userDefaults objectForKey:@"token"] videoId:vid videoName:_titleView.text videoUrl:imageUrl success:^(NSDictionary *info) {
            NSLog(@"success--%@",info);
            _backGroundView.hidden = YES;
            NSString *code = [NSString stringWithFormat:@"%@",[info objectForKey:@"resultCode"]];
            if ([code isEqualToString:@"200"]) {
                [self showAlert:@"视频上传成功" withViewController:self];
            } else {
                [self showAlert:@"视频上传失败，请重新上传" withViewController:self];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"error%@",error);
         
            _backGroundView.hidden = YES;
            [self showAlert:@"视频上传失败，请重新上传" withViewController:self];
        }];
        
    });
}

-(void)uploadProgressWithUploadedSize:(long long)uploadedSize totalSize:(long long)totalSize {
    dispatch_async(dispatch_get_main_queue(), ^{
        _stateLabel.text = [NSString stringWithFormat:@"%d %%",(int)(uploadedSize * 100/totalSize)];
    });
}
- (void)showAlert:(NSString *)message withViewController:(UIViewController *)viewController {
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self kindUpdateMessage:message];
    }];
    [alertCon addAction:okAction];
    [viewController presentViewController:alertCon animated:YES completion:nil];
}
- (void)kindUpdateMessage:(NSString *)message {
    if ([message isEqualToString:@"视频上传成功"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        
    }
}
-(void)uploadTokenExpired {
    NSLog(@"uploadTokenExpired");
}

-(void)uploadRetry {
    NSLog(@"uploadRetry");
}

-(void)uploadRetryResume {
    NSLog(@"uploadRetryResume");
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - pick view delegate

-(void)pickViewDidUpdateImage:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        _coverView.image = image;
    });
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_titleView resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField; {
    _stateLabel.hidden = YES;
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
    
}
@end
