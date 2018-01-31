//================================================================================
//
// (c) Copyright China Digital Video (Beijing) Limited, 2016. All rights reserved.
//
// This code and information is provided "as is" without warranty of any kind,
// either expressed or implied, including but not limited to the implied
// warranties of merchantability and/or fitness for a particular purpose.
//
//--------------------------------------------------------------------------------
//   Birth Date:    Jan 13. 2017
//   Author:        NewAuto video team
//================================================================================

#import "ViewController.h"
#import "NvsStreamingContext.h"
#import "NvsLiveWindow.h"
#import "NvsCaptureVideoFx.h"
#import "FxTableViewCell.h"
#import "UIColor+Hex.h"
#import "UIView+Frame.h"
#import "NvsFxDescription.h"

#import "QBImagePickerController.h"
#import "NvsVideoTrack.h"
#import "GenerationView.h"

//#import "AliyunMediaConfig.h"
#import "AliyunCompositionViewController.h"

#import "AliyunImportHeaderView.h"
#import "AliyunAlbumViewController.h"
#import "AliyunCompositionCell.h"
#import "AliyunCompositionPickView.h"
#import "AliyunPhotoLibraryManager.h"
#import "AliyunCompositionInfo.h"
#import "AliyunPathManager.h"
#import "AVAsset+VideoInfo.h"
#import "AliyunCompressManager.h"
//#import <AliyunVideoSDKPro/AliyunEditor.h>
//#import <AliyunVideoSDKPro/AliyunImporter.h>
#import "QUMBProgressHUD.h"
#import "AliyunMediator.h"
#import <sys/utsname.h>

#import "AliyunCoverPickViewController.h"
#import "QUProgressView.h"



#define NS_TIMELINE_WIDTH 720
#define NS_TIMELINE_HEIGHT 1280

typedef enum {
    EDIT_TYPE_NONE = 0,
    EDIT_TYPE_BEAUTY,
    EDIT_TYPE_ZOOM,
    EDIT_TYPE_EXPOSE,
    EDIT_TYPE_FX
}EDIT_TYPE;

@interface ViewController ()<NvsStreamingContextDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate,QBImagePickerControllerDelegate,GenerationViewDelegate,UINavigationControllerDelegate> {
    

    NvsVideoTrack       *_videoTrack;
    NSString            *outputFilePath;//最后一段录制的视频路径
    GenerationView      *generationView;
    NSString            *compileVideo;//打包生成的视频
    NSString            *_compileVideoDir;
    NvsTimeline         *_timeline;
}

@property (weak, nonatomic) IBOutlet NvsLiveWindow *liveWindow;
@property (weak, nonatomic) IBOutlet UIImageView *imageAutoFocusRect;
@property (weak, nonatomic) IBOutlet UIView *functionButtonContainerView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;

@property (weak, nonatomic) IBOutlet UIImageView *fxSelectImageView;
@property (weak, nonatomic) IBOutlet UIButton *beautyButton;
@property (weak, nonatomic) IBOutlet UIImageView *beautyImageView;
@property (weak, nonatomic) IBOutlet UIView *beautyContainerView;
@property (weak, nonatomic) IBOutlet UIView *zoomContainerView;
@property (weak, nonatomic) IBOutlet UIView *exposeContainerView;
@property (weak, nonatomic) IBOutlet UIView *zoomBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *exposeBackgroundView;
@property (weak, nonatomic) IBOutlet UISlider *exposeSlider;
@property (weak, nonatomic) IBOutlet UISlider *zoomSlider;
@property (weak, nonatomic) IBOutlet UISlider *strengthSlider;
@property (weak, nonatomic) IBOutlet UISlider *reddeningSlider;
@property (weak, nonatomic) IBOutlet UISlider *whiteningSlider;
@property (weak, nonatomic) IBOutlet UIView *reddeningBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *strengthBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *whiteningBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *reddeningValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *whiteningValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *strengthValueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *autoFocusImageView;
@property (weak, nonatomic) IBOutlet UIImageView *zoomImageView;
@property (weak, nonatomic) IBOutlet UIImageView *exposeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *flashImageView;
@property (weak, nonatomic) IBOutlet UIImageView *switchFacingImageView;
@property (weak, nonatomic) IBOutlet UITableView *fxTableView;
@property (weak, nonatomic) IBOutlet UIButton *autoFocusButton;
@property (weak, nonatomic) IBOutlet UIButton *zoomButton;
@property (weak, nonatomic) IBOutlet UIButton *exposeButton;

@property (strong, nonatomic) UIButton *flashButton;
@property (strong, nonatomic) UIButton *switchFacingButton;
@property (strong, nonatomic) UIButton *fxSelectButton;

@property (weak, nonatomic) IBOutlet UIButton *openBeautyButton;
@property (weak, nonatomic) IBOutlet UIButton *captureWithFxButton;

//需要的
@property (nonatomic, strong)UIButton   *backButton;
@property (nonatomic, strong)UIButton   *nextButton;
@property (nonatomic, strong)UIButton   *updateButton;
@property (strong, nonatomic) UIImagePickerController *moviePicker;//视频选择器

@property (nonatomic, strong) AliyunMediaConfig *compositionConfig;
@property (nonatomic, strong) QUProgressView *progressView;//进度条
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, assign) int count;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIView *animationView;


@end

@implementation ViewController {
    bool _isAutoFocus;
    bool _supportAutoFocus;
    bool _supportAutoExposure;
    bool _useBeauty;
    bool _captureWithFx;
    unsigned int _currentDeviceIndex;
    UITapGestureRecognizer *_tapRecognizer;
    NvsStreamingContext *_context;
    NSMutableArray *_fxNameArray;
    NSMutableString *_fxPackageId;
    EDIT_TYPE _editType;
    NSIndexPath *_selectedIndexPath;
    NSString *_currentFxName;
    NSTimer *_autoFocusViewVisibleTimer;
    
    NSString *_captureDir;
}

// 恢复采集预览状态
- (void)resumeCapturePreview {
   
    if (!_context)
        return;
    // 判断当前引擎状态是否为采集预览状态，避免重复启动采集预览引起引擎停止再启动，造成启动慢或者其他不良影响
    if ([self getCurrentEngineState] == NvsStreamingEngineState_CapturePreview)
        return;
    
    [self.recordButton setTitle:@"开始拍" forState:UIControlStateNormal];
    if ([_context captureDeviceCount] > 1)
        [self.switchFacingButton setEnabled:YES];
   
    // 开启采集预览
    [self startCapturePreview];
}

// 获取当前引擎状态
- (NvsStreamingEngineState) getCurrentEngineState {
    return [_context getStreamingEngineState];
}

- (void)clear {
    _context = nil;
    [NvsStreamingContext destroyInstance];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [self stopAnimation];
//    NSLog(@"============");
}
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    [self resetSettings];
    _isAutoFocus = false;
    _supportAutoFocus = false;
    _supportAutoExposure = false;
    _useBeauty = false;
    _captureWithFx = false;
    
    //每次进来清空目录
    [self clearDir];
    // 初始化NvsStreamingContext
    _context = [NvsStreamingContext sharedInstance];
    if (!_context)
        return;
    
    // 可用采集设备的数量
    if ([_context captureDeviceCount] == 0) {
        NSLog(@"没有可用于采集的设备");
        return;
    }
    
    // 将采集预览输出连接到NvsLiveWindow控件
    if (![_context connectCapturePreviewWithLiveWindow:self.liveWindow]) {
        NSLog(@"连接预览窗口失败");
        return;
    }
 
    if (![self startCapturePreview]) {
        return;
    }
    
    [self initRadiusControls];
    
    if ([_context captureDeviceCount] > 1)
        [self.switchFacingButton setEnabled:YES];
    
    // 是否为前置摄像头
    if ([_context isCaptureDeviceBackFacing:0])
        _currentDeviceIndex = 0;
    else
        _currentDeviceIndex = 1;
    
    self.imageAutoFocusRect.center = CGPointMake(self.liveWindow.frame.size.width / 2, self.liveWindow.frame.size.height / 2);
    
    // 由于本示例程序需要演示采集特效，所以需要安装一个采集特效包
    _fxPackageId = [[NSMutableString alloc] initWithString:@""];
    bool package1Valid = true;
    NSString *appPath =[[NSBundle mainBundle] bundlePath];
    NSString *package1Path = [appPath stringByAppendingPathComponent:@"7FFCF99A-5336-4464-BACD-9D32D5D2DC5E.videofx"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:package1Path]) {
        NSLog(@"包裹1不存在");
        package1Valid = false;
    } else {
        // 此处采用同步安装方式，如果包裹过大可采用异步方式
        NvsAssetPackageManagerError error = [_context.assetPackageManager installAssetPackage:package1Path license:nil type:NvsAssetPackageType_VideoFx sync:YES assetPackageId:_fxPackageId];
        if (error != NvsAssetPackageManagerError_NoError && error != NvsAssetPackageManagerError_AlreadyInstalled) {
            NSLog(@"包裹1安装失败");
            package1Valid = false;
        }
    }
    _currentFxName = @"None";
    // 初始化特效tableview
    _fxNameArray = [NSMutableArray arrayWithObject:@"None"];
    // 获取全部内嵌采集视频特效的名称
    [_fxNameArray addObjectsFromArray:[_context getAllBuiltinCaptureVideoFxNames]];
    if (package1Valid)
        [_fxNameArray addObject:@"Package1"];
    
    self.fxTableView.dataSource = self;
    self.fxTableView.delegate = self;
    _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.recordButton setEnabled:YES];
    [self getBeautyInfo];
    // 给NvsStreamingContext设置回调接口
    _context.delegate = self;
    [self addBackButton];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.hidden = YES;
    _nextButton.frame = CGRectMake(WIDTH-80, ML_StatusBarHeight+10, 60, 30);
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    _nextButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    _nextButton.backgroundColor = NavColor;
    _nextButton.layer.cornerRadius = 4.0;
    [_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextButton];
    for (int i = 0; i < 3; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(WIDTH-55, _nextButton.frame.origin.y+47+52*i, 35, 35);
        button.layer.cornerRadius = 17.0;
        button.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
     

        if (i == 0) {
            _flashButton = button;
            [_flashButton setImage:[UIImage imageNamed:@"flash_off"] forState:UIControlStateNormal];
            [_flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_flashButton];
        } else if (i == 1) {
            _switchFacingButton = button;
            [_switchFacingButton setImage:[UIImage imageNamed:@"switch_facing"] forState:UIControlStateNormal];
            [_switchFacingButton addTarget:self action:@selector(switchFacingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_switchFacingButton];
            
        } else {
            _fxSelectButton = button;
            [_fxSelectButton setImage:[UIImage imageNamed:@"fx"] forState:UIControlStateNormal];
            [_fxSelectButton addTarget:self action:@selector(fxSelectButtonChanged:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_fxSelectButton];
            
        }
        
    }
    

    _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (UI_IS_IPHONE6PLUS) {
        _updateButton.frame = CGRectMake(_recordButton.frame.origin.x*Iphone6Size+65+44, HEIGHT-ML_TabBarHeight-43, 50, 50);
    } else {
        _updateButton.frame = CGRectMake(WIDTH-50-44, HEIGHT-ML_TabBarHeight-43, 50, 50);
    }
    
    [_updateButton setTitle:@"上传" forState:UIControlStateNormal];
    _updateButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    _updateButton.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
    _updateButton.layer.cornerRadius = _beautyButton.frame.size.height/2;
    [_updateButton addTarget:self action:@selector(updateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_updateButton];
    
    [self setupParamData];
    
    _liveWindow.frame = CGRectMake(0, 0, WIDTH, ML_TopHeight);
}

//返回按钮
- (void)addBackButton {
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(15, ML_StatusBarHeight+7, 40, 30);
    [_backButton setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backBarButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    //录制时间显示
    self.timerLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,ML_StatusBarHeight+10, 100, 15)];
    self.timerLabel.hidden = YES;
    self.timerLabel.textColor = Color255;
    self.timerLabel.text = @"00:00";
    self.timerLabel.font = [UIFont systemFontOfSize:13.0];
    [self.view addSubview:_timerLabel];
    
    _backGroundView = [[UILabel alloc]initWithFrame:CGRectMake(0, ML_StatusBarHeight,WIDTH , 5)];
    _backGroundView.backgroundColor = [UIColor lightGrayColor];
    _backGroundView.alpha = 0.5;
    _backGroundView.hidden = YES;
    
    
    _animationView = [[UILabel alloc]initWithFrame:CGRectMake(-WIDTH, ML_StatusBarHeight, WIDTH, 5)];
    _animationView.backgroundColor = NavColor;
    _animationView.hidden = YES;
    
    [self.view addSubview:_backGroundView];
    [self.view addSubview:_animationView];
}

#pragma mark - 设置录制参数
- (void)setupParamData {
    _compositionConfig = [[AliyunMediaConfig alloc] init];
    _compositionConfig.minDuration = 2.0;
    _compositionConfig.maxDuration = 10*60.0;
    _compositionConfig.fps = 25;
    _compositionConfig.gop = 5;
    _compositionConfig.videoQuality = 1;
    _compositionConfig.outputSize = CGSizeMake(540, 720);
    _compositionConfig.cutMode = AliyunMediaCutModeScaleAspectFill;
    _compositionConfig.videoOnly = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 获取美颜相关系数
- (void)getBeautyInfo {
    NvsFxDescription *fxDescription = [_context getVideoFxDescription:@"Beauty"];
    NSArray* paramInfoArray = [fxDescription getAllParamsInfo];
    
    for (NSDictionary *dic in paramInfoArray) {
        NSString* paramName = [dic objectForKey:@"paramName"];
        if ([paramName isEqualToString:@"Strength"]) {
            double maxValue = [[dic objectForKey:@"floatMaxVal"] floatValue];
            self.strengthSlider.maximumValue = maxValue * 100;
            double strengthValue = [[dic objectForKey:@"floatDefVal"] floatValue];
            self.strengthSlider.value =strengthValue * 100;
            NSString* strengthStr = [NSString stringWithFormat:@"%.2f",strengthValue];
            [self.strengthValueLabel setText:strengthStr];
            
        } else if ([paramName isEqualToString:@"Whitening"]) {
            double maxValue = [[dic objectForKey:@"floatMaxVal"] floatValue];
            self.whiteningSlider.maximumValue = maxValue * 100;
            double whiteningValue =[[dic objectForKey:@"floatDefVal"] floatValue];
            self.whiteningSlider.value = whiteningValue * 100;
            NSString* illuminaitonStr = [NSString stringWithFormat:@"%.2f",whiteningValue];
            [self.whiteningValueLabel setText:illuminaitonStr];
        } else if ([paramName isEqualToString:@"Reddening"]) {
            double maxValue = [[dic objectForKey:@"floatMaxVal"] floatValue];
            self.reddeningSlider.maximumValue = maxValue * 100;
            double reddeingValue =[[dic objectForKey:@"floatDefVal"] floatValue];
            self.reddeningSlider.value = reddeingValue * 100;
            NSString* illuminaitonStr = [NSString stringWithFormat:@"%.2f",reddeingValue];
            [self.reddeningValueLabel setText:illuminaitonStr];
        }
    }
}

- (void)initRadiusControls {
    [self setRadius:self.fxSelectButton];
    [self setRadius:self.beautyButton];
    [self setRadius:self.autoFocusButton];
    [self setRadius:self.zoomButton];
    [self setRadius:self.exposeButton];
    [self setRadius:self.flashButton];
    [self setRadius:self.switchFacingButton];
    [self setRadius:self.captureWithFxButton];
    self.zoomBackgroundView.layer.cornerRadius = 15;
    self.exposeBackgroundView.layer.cornerRadius = 15;
    self.whiteningBackgroundView.layer.cornerRadius = 15;
    self.reddeningBackgroundView.layer.cornerRadius = 15;
    self.strengthBackgroundView.layer.cornerRadius = 15;
}

// 聚焦
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.liveWindow];
    CGFloat rectHalfWidth = self.imageAutoFocusRect.frame.size.width / 2;
    if (point.x - rectHalfWidth < 0 || point.x + rectHalfWidth > self.liveWindow.frame.size.width || point.y - rectHalfWidth < 0 || point.y + rectHalfWidth > self.liveWindow.frame.size.height)
        return;
    
    self.imageAutoFocusRect.center = point;
    if (_supportAutoFocus)      // 支持自动聚焦则自动聚焦
        [_context startAutoFocus:self.imageAutoFocusRect.center];
    else if (_supportAutoExposure)  // 支持自动曝光则自动曝光
        [_context startAutoExposure:self.imageAutoFocusRect.center];
    [self setAutoFocusVisibleTimer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }else if ([touch.view isKindOfClass:[UITableView class]])
    {
        return NO;
    }
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIView"]) {
        return NO;
    }
    return YES;
}

- (void)resetSettings {
    [self setEditType:EDIT_TYPE_NONE];
    [self.recordButton setEnabled:NO];
    [self.flashButton setEnabled:NO];
    [self.autoFocusButton setEnabled:NO];
    [self.zoomSlider setEnabled:NO];
    [self.exposeSlider setEnabled:NO];
    [_flashImageView setImage:[UIImage imageNamed:@"flash_off"]];
    self.imageAutoFocusRect.hidden = YES;
    self.imageAutoFocusRect.frame = CGRectMake(0, 0, self.liveWindow.frame.size.width / 10, self.liveWindow.frame.size.width / 10);
}

- (void)updateSettingsWithCapability:(unsigned int)deviceIndex {
    // 获取采集设备的能力描述
    NvsCaptureDeviceCapability *capability = [_context getCaptureDeviceCapability:deviceIndex];
    if (!capability)
        return;
    
    // 是否支持闪光灯
    if (capability.supportFlash) {
        [self.flashButton setEnabled:YES];
    }
    
    _supportAutoFocus = capability.supportAutoFocus;    // 是否支持自动聚焦
    _supportAutoExposure = capability.supportAutoExposure;  // 是否支持自动曝光
    if (_supportAutoExposure || _supportAutoExposure) {
        [self.autoFocusButton setEnabled:YES];
    }
    
    // 是否支持缩放
    if (capability.supportZoom) {
        [self.zoomSlider setMinimumValue:1];
        [self.zoomSlider setMaximumValue:capability.maxZoomFactor > 5 ? 5 : capability.maxZoomFactor];
        [self.zoomSlider setValue:[_context getZoomFactor]];
        [self.zoomSlider setEnabled:YES];
    }
    
    // 是否支持曝光补偿
    if (capability.supportExposureBias) {
        [self.exposeSlider setMinimumValue:capability.minExposureBias];
        [self.exposeSlider setMaximumValue:capability.maxExposureBias];
        [self.exposeSlider setValue:[_context getExposureBias]];
        [self.exposeSlider setEnabled:YES];
    }
}
- (NSString *)capturePath {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *captureDir = [docPath stringByAppendingPathComponent:@"capture"];
    return captureDir;
}
- (NSString *)captureVideoPath {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    _captureDir = [docPath stringByAppendingPathComponent:@"capture"];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *files = [fm contentsOfDirectoryAtPath:_captureDir error:nil];
    NSString *videoPath = [_captureDir stringByAppendingPathComponent:@"capture_1.mov"];
    if (files.count == 0) {
        return videoPath;
    }
    NSString *videoName = [NSString stringWithFormat:@"capture_%d.mov",(int)(files.count+1)];
    videoPath = [_captureDir stringByAppendingPathComponent:videoName];
    return videoPath;
}
- (IBAction)startRecording:(id)sender {
    if ([self getCurrentEngineState] != NvsStreamingEngineState_CaptureRecording) {
        // 获取输出文件路径
        outputFilePath = [self captureVideoPath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:outputFilePath]) {
            NSError *error;
            if ([[NSFileManager defaultManager] removeItemAtPath:outputFilePath error:&error] == NO) {
                NSLog(@"removeItemAtPath failed, error: %@", error);
                return;
            }
        }

        // 开始录制
        [_context startRecordingWithFx:outputFilePath];
        [self recorderViewHidden];
        //计时器
        [self startBtnClick];

        [self.recordLabel setText:@""];
        [self.recordButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self.switchFacingButton setEnabled:NO];
        return;
    }
    
    // 停止录制
    [_context stopRecording];
    [self recorderViewShow];
    
    [self stopAnimation];
    [self.recordLabel setText:@"开始拍"];
    [self.recordButton setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    if ([_context captureDeviceCount] > 1)
        [self.switchFacingButton setEnabled:YES];
}
//点击录制隐藏按钮
- (void)recorderViewHidden {
    _nextButton.hidden = YES;
    _updateButton.hidden = YES;
    _functionButtonContainerView.hidden = YES;
    _fxSelectButton.hidden = YES;
    _fxSelectImageView.hidden = YES;
    _beautyImageView.hidden = YES;
    _beautyButton.hidden = YES;
    _beautyContainerView.hidden = YES;
    _fxTableView.hidden = YES;

}
//录制完成
- (void)recorderViewShow {
    _updateButton.hidden = NO;
    _functionButtonContainerView.hidden = NO;
    _fxSelectButton.hidden = NO;
    _fxSelectImageView.hidden = NO;
    _beautyImageView.hidden = NO;
    _beautyButton.hidden = NO;
    _flashButton.hidden = NO;
    _switchFacingButton.hidden = NO;
    [self setEditType:EDIT_TYPE_NONE];
    
}
//开始计时
- (void)startBtnClick {
    _animationView.hidden = NO;
    _backGroundView.hidden = NO;
    _backButton.hidden = YES;
    _timerLabel.hidden = NO;
    _nextButton.hidden = YES;
    _flashButton.hidden = YES;
    _switchFacingButton.hidden = YES;
    _fxSelectButton.hidden = YES;
    
    _animationView.frame = CGRectMake(-WIDTH, ML_StatusBarHeight, WIDTH, 5);
    
    [self startAnimation];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.count = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(repeatShowTime:) userInfo:@"admin" repeats:YES];
}
//时间戳开始
- (void)repeatShowTime:(NSTimer *)tempTimer {
    
    self.count++;
    if (self.count >= 2) {
        _nextButton.hidden = NO;
    }
    self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d",self.count/60,self.count%60];
    if (self.count == 31) {
        [_context stopRecording];
        [self recorderViewShow];
        [self stopAnimation];
        
        _nextButton.hidden = YES;
        [self.recordLabel setText:@"开始拍"];
        [self.recordButton setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *captureDir = [docPath stringByAppendingPathComponent:@"capture"];
        _compositionConfig.outputPath = outputFilePath;
        CGSize _outputSize = [_compositionConfig fixedSize];
        
        AliyunCoverPickViewController *vc = [AliyunCoverPickViewController new];
        vc.outputSize = _outputSize;
        vc.taskPath = captureDir;
        vc.videoPath = outputFilePath;
        vc.finishHandler = ^(UIImage *image) {
            //        _image = image;
            //        _coverImageView.image = image;
            //        _backgroundView.image = image;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 进度条动画
- (void)startAnimation {
   
    [UIView animateWithDuration:30 animations:^{
        [UIView setAnimationDelay:0];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        CGPoint point = _animationView.center;
        point.x += WIDTH;
        [_animationView setCenter:point];

    } completion:^(BOOL finished){
        _animationView.frame = CGRectMake(0, ML_StatusBarHeight, WIDTH, 5);
        
       
    }];
}
//停止动画
- (void)stopAnimation {
    _backButton.hidden = NO;
    _animationView.hidden = YES;
    _backGroundView.hidden = YES;
    _timerLabel.hidden = YES;
    _count = 0;
    _timerLabel.text = @"00:00";
    
    [_timer invalidate];
    [_animationView.layer removeAllAnimations];
}
//延时显示
- (void)beganCapture:(NSTimer *)timer {
    _nextButton.hidden = NO;
}

#pragma mark - 点击下一步
- (void)nextButtonClick:(UIButton *)but {
 
    [_context stopRecording];
    [self recorderViewShow];
    [self stopAnimation];
    
    _nextButton.hidden = YES;
    [self.recordLabel setText:@"开始拍"];
    [self.recordButton setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *captureDir = [docPath stringByAppendingPathComponent:@"capture"];
    _compositionConfig.outputPath = outputFilePath;
    CGSize _outputSize = [_compositionConfig fixedSize];
    
    AliyunCoverPickViewController *vc = [AliyunCoverPickViewController new];
    vc.outputSize = _outputSize;
    vc.taskPath = captureDir;
    vc.videoPath = outputFilePath;
    vc.finishHandler = ^(UIImage *image) {
//        _image = image;
//        _coverImageView.image = image;
//        _backgroundView.image = image;
    };
    [self.navigationController pushViewController:vc animated:YES];
   
}
#pragma mark - 点击上传
- (void)updateButtonClick:(UIButton *)button {
    
    [_context stopRecording];
    [self recorderViewShow];
    _nextButton.hidden = YES;
    [_timer invalidate];
    [self.recordLabel setText:@"开始拍"];
    [self.recordButton setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    
    //    mediaInfo.backgroundColor = [UIColor blackColor];
    AliyunCompositionViewController *composVC = [[AliyunCompositionViewController alloc]init];
//    UIViewController *vc = [[AliyunMediator shared] editModule];
    [composVC setValue:_compositionConfig forKey:@"compositionConfig"];

    [self.navigationController pushViewController:composVC animated:YES];
    
    
}
#pragma mark - 界面
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
//    NSMutableArray* descArray = [NSMutableArray array];
    [_videoTrack removeAllClips];

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    @autoreleasepool {
        for (PHAsset *asset in assets) {
            if (asset.mediaType == PHAssetMediaTypeImage)
                [_videoTrack appendClip:asset.localIdentifier];
            else {
                __weak __typeof(self) weakSelf = self;
                [[PHImageManager defaultManager] requestAVAssetForVideo:asset
                                                                options:[PHVideoRequestOptions new] resultHandler:^(AVAsset * avAsset, AVAudioMix * audioMix, NSDictionary * info) {

                                                                    dispatch_async(queue, ^{

                                        [weakSelf addClip:avAsset withIndex:0];

                                                                        dispatch_semaphore_signal(semaphore);
                                                                    });
                                                                }];
            }
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)addClip:(AVAsset *)avAsset withIndex:(NSUInteger)index {
    NSLog(@"-----------------insert asset");
    // 在指定位置插入片段
    AVURLAsset *urlAsset = (AVURLAsset *)avAsset;
    [_videoTrack insertClip:urlAsset.URL.absoluteString clipIndex:(unsigned int)index];
    
}
- (void)preparePlay{
     [self stopCapturePreview];
    //创建timeline
    if (!_timeline) {
        NvsVideoResolution videoEditRes;
        videoEditRes.imageWidth = NS_TIMELINE_WIDTH;
        videoEditRes.imageHeight = NS_TIMELINE_HEIGHT;
        videoEditRes.imagePAR = (NvsRational){1, 1};
        NvsRational videoFps = {25, 1};
        NvsAudioResolution audioEditRes;
        audioEditRes.sampleRate = 48000;
        audioEditRes.channelCount = 2;
        audioEditRes.sampleFormat = NvsAudSmpFmt_S16;
        _timeline = [_context createTimeline:&videoEditRes videoFps:&videoFps audioEditRes:&audioEditRes];
    }
    //连接livewindow
    [_context connectTimeline:_timeline withLiveWindow:_liveWindow];
    //添加视频
    if (!_videoTrack) {
        _videoTrack = [_timeline appendVideoTrack];
    }
    [_videoTrack removeAllClips];
    [_videoTrack appendClip:outputFilePath];
    NSLog(@"--------->>>video%lld---%@",_videoTrack.duration,outputFilePath);
    [_context seekTimeline:_timeline timestamp:0 videoSizeMode:NvsVideoPreviewSizeModeLiveWindowSize flags:0];
    
    generationView = [[GenerationView alloc] initWithFrame:self.view.frame];
    generationView.delegate = self;
    [self.view addSubview:generationView];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *fileDir = [fm contentsOfDirectoryAtPath:[self capturePath] error:nil];
    [_videoTrack removeAllClips];
    for (NSString *file in fileDir) {
        [_videoTrack appendClip:[[self capturePath] stringByAppendingPathComponent:file]];
    }
    _compileVideoDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]  stringByAppendingPathComponent:@"compileVideoDir"];
    compileVideo = [_compileVideoDir stringByAppendingPathComponent:@"compileVideo.mp4"];
    
    if ([fm fileExistsAtPath:compileVideo]) {
        [fm removeItemAtPath:compileVideo error:nil];
    }
    _context.delegate = self;
    NSLog(@"-----------------%@-------%lld",compileVideo,_timeline.duration);
    
    [_context compileTimeline:_timeline startTime:0 endTime:_timeline.duration outputFilePath:compileVideo videoResolutionGrade:NvsCompileVideoResolutionGrade720 videoBitrateGrade:NvsCompileBitrateGradeMedium flags:0];
   
}
- (void)stopCapturePreview{
    if(!_context)
        return;
    
//    if(_stHumanAction)
//        [_stHumanAction setCurrentParticleEffect:nil effectDesc:nil];
    
    [_context removeAllCaptureVideoFx];
    [_context stop];
}
- (void)clearDir {
    NSFileManager *fm = [NSFileManager defaultManager];
    _compileVideoDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]  stringByAppendingPathComponent:@"compileVideoDir"];
    compileVideo = [_compileVideoDir stringByAppendingPathComponent:@"compileVideo.mp4"];
    if ([fm fileExistsAtPath:compileVideo]) {
        [fm removeItemAtPath:compileVideo error:nil];
    }
    
    NSString *videosPath = [self capturePath];
    NSArray *videosName = [fm contentsOfDirectoryAtPath:videosPath error:nil];
    for (NSString *fileName in videosName) {
        NSString *filePath = [videosPath stringByAppendingPathComponent:fileName];
        [fm removeItemAtPath:filePath error:nil];
    }
}
- (void)didCompileProgress:(NvsTimeline *)timeline progress:(int)progress {
    NSLog(@"%d",progress);
    [generationView setProgress:progress];
}

- (void)didCompileFinished:(NvsTimeline *)timeline {
    NSLog(@"打包完成");
    [generationView finish];
    UISaveVideoAtPathToSavedPhotosAlbum(compileVideo, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    
//        QUMBProgressHUD *hud = [QUMBProgressHUD showHUDAddedTo:self.view animated:YES];
//
////        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
////        NSString *captureDir = [docPath stringByAppendingPathComponent:@"capture"];
////    //    NSString *root = [AliyunPathManager compositionRootDir];
////        NSString *root = captureDir;
////        NSFileManager *fm = [NSFileManager defaultManager];
////        NSArray *fileDir = [fm contentsOfDirectoryAtPath:[self capturePath] error:nil];
////        [_videoTrack removeAllClips];
////        for (NSString *file in fileDir) {
////            [_videoTrack appendClip:[[self capturePath] stringByAppendingPathComponent:file]];
////        }
//        NSString *compileVideoDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]  stringByAppendingPathComponent:@"compileVideoDir"];
////        compileVideo = [compileVideoDir stringByAppendingPathComponent:@"compileVideo.mp4"];
//
//        NSLog(@"------------------->>>%@------%@-----%@",outputFilePath,compileVideoDir,compileVideo);
//         CGSize _outputSize = [_compositionConfig fixedSize];
//        AliyunImporter *importor = [[AliyunImporter alloc] initWithPath:_compileVideoDir outputSize:_outputSize];
//
//        AliyunCompositionInfo *info = [[AliyunCompositionInfo alloc]init];
//        info.type = AliyunCompositionInfoTypeVideo;
//    //    info.asset =
//
//        [importor addVideoWithPath:compileVideo animDuration:0];
//
//        // set video param
//        AliyunVideoParam *param = [[AliyunVideoParam alloc] init];
//        param.fps = _compositionConfig.fps;
//        param.gop = _compositionConfig.gop;
//        param.bitrate = _compositionConfig.bitrate;
//        param.videoQuality = (AliyunVideoQuality)_compositionConfig.videoQuality;
//        param.scaleMode = (AliyunScaleMode)_compositionConfig.cutMode;
//        [importor setVideoParam:param];
//        // generate config
//        [importor generateProjectConfigure];
//     //output path
////            _compositionConfig.outputPath = [[[AliyunPathManager compositionRootDir]
////                                              stringByAppendingPathComponent:[AliyunPathManager uuidString]]
////                                             stringByAppendingPathExtension:@"mp4"];
//        _compositionConfig.outputPath = compileVideo;
//        // edit view controller
//
//        // 发布页面合成视频
//        AliyunPublishViewController *vc = [[AliyunPublishViewController alloc] init];
//        vc.taskPath = _compileVideoDir;
//        vc.config = _compositionConfig;
//        vc.outputSize = _outputSize;
//        NSLog(@"-------------%@--------%@----%@",_compileVideoDir,_compositionConfig.outputPath,outputFilePath);
//        dispatch_async(dispatch_get_main_queue(), ^{
////            [hud hideAnimated:YES];
//            [self presentViewController:vc animated:YES completion:nil];
//            //            [self.navigationController pushViewController:editVC animated:YES];
//        });
//    HLUploadVideoViewController *uploadVC = [[HLUploadVideoViewController alloc]init];
//    uploadVC.videoPath = compileVideo;
//    [self presentViewController:uploadVC animated:YES completion:nil];
}

- (void)didCompileCompleted:(NvsTimeline *)timeline isCanceled:(BOOL)isCanceled {
    NSLog(@"finish and is Canceled");
    [generationView fail];
}

- (void)didCompileFailed:(NvsTimeline *)timeline {
    NSLog(@"打包失败！");
    [generationView fail];
}
#pragma - mark save Video to album
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存成功" message:@"已保存到相册" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存失败" message:@"保存到相册失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma - mark GenrerationViewDelegate
- (void)generationView:(GenerationView*)generationView finishClick:(Boolean)isFinish {
    
    if (isFinish) {
        
        //清空目录
        [self clearDir];
        
        [_context connectCapturePreviewWithLiveWindow:_liveWindow];
        if (![self startCapturePreview]) {
            return;
        }
        if ([_context captureDeviceCount] > 1)
            [self.switchFacingButton setEnabled:YES];
        // 是否为前置摄像头
        if ([_context isCaptureDeviceBackFacing:0])
            _currentDeviceIndex = 0;
        else
            _currentDeviceIndex = 1;
        
        [self.recordButton setEnabled:YES];
        // 给NvsStreamingContext设置回调接口
        _context.delegate = self;
    } else {
       
        [self stopCapturePreview];
    }
    [generationView removeFromSuperview];
    
}
- (bool) startCapturePreview {
    if(![_context startCapturePreview:_currentDeviceIndex videoResGrade:NvsVideoCaptureResolutionGradeHigh flags:NvsStreamingEngineCaptureFlag_CaptureBuddyHostVideoFrame aspectRatio:nil]) {
        NSLog(@"启动预览失败");
        [_recordButton setEnabled:false];
    }else {
        NSLog(@"---------->>>");
        [_recordButton setEnabled:true];
    }
    return true;
}

- (void)didCaptureDeviceCapsReady:(unsigned int)captureDeviceIndex {
    if (captureDeviceIndex != _currentDeviceIndex)
        return;
    [self updateSettingsWithCapability:captureDeviceIndex];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _fxNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fxCellIdentifier = @"FxTableViewCell";
    FxTableViewCell *cell = [self.fxTableView dequeueReusableCellWithIdentifier:fxCellIdentifier];
    if(cell == nil){
        cell= [[[NSBundle mainBundle]loadNibNamed:fxCellIdentifier owner:nil options:nil] firstObject];
    }
    NSString *fxName = [_fxNameArray objectAtIndex:indexPath.row];
    cell.fxNameLabel.text = fxName;
    [cell.fxImage setImage:[UIImage imageNamed:@"none"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([_selectedIndexPath isEqual:indexPath])
        return;
    NSIndexPath *oldIndexPath = _selectedIndexPath;
    if(oldIndexPath){
        FxTableViewCell *oldCell = [self cellAtIndexPath:oldIndexPath];
        [oldCell.fxThumbBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"#ffffff" alpha:1]];
    }
    _selectedIndexPath = indexPath;
    FxTableViewCell *newCell = [self cellAtIndexPath:indexPath];
    [newCell.fxThumbBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"#3db5fe" alpha:1]];
    // 删除所有采集特效
    [_context removeAllCaptureVideoFx];
    if(_useBeauty) {
        NvsCaptureVideoFx *fx = [_context appendBeautyCaptureVideoFx];
        [fx setFloatVal:@"Strength" val:_strengthSlider.value*0.01];
        [fx setFloatVal:@"Whitening" val:_whiteningSlider.value*0.01];
        [fx setFloatVal:@"Reddening" val:_reddeningSlider.value*0.01];
    }
    NSString *fxName = [_fxNameArray objectAtIndex:indexPath.row];
    if(_currentFxName == fxName)
        return;
    
    _currentFxName = fxName;
    if ([fxName isEqualToString:@"None"])
        return;
    // 添加包裹特效
    if ([fxName isEqualToString:@"Package1"]) {
        [_context appendPackagedCaptureVideoFx:_fxPackageId];
        return;
    }
    // 添加内置特效
    [_context appendBuiltinCaptureVideoFx:fxName];
}

- (FxTableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath {
    return (FxTableViewCell*)[self.fxTableView cellForRowAtIndexPath:indexPath];
}

//开关自动聚焦
- (IBAction)autoFocusButtonPressed:(id)sender {
    if (!_isAutoFocus) {
        if (_supportAutoFocus)      // 支持自动聚焦则自动聚焦
            [_context startAutoFocus:self.imageAutoFocusRect.center];
        else if (_supportAutoExposure)  // 支持自动曝光则自动曝光
            [_context startAutoExposure:self.imageAutoFocusRect.center];
        
        if (!_tapRecognizer) {
            _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            _tapRecognizer.numberOfTapsRequired = 1;
            _tapRecognizer.delegate = self;
        }
        [self.liveWindow addGestureRecognizer:_tapRecognizer];
        _isAutoFocus = true;
        [self.autoFocusButton setBackgroundColor:[UIColor colorWithHexString:@"#3db5f4" alpha:0.8]];
        [self setAutoFocusVisibleTimer];
    } else {
        // 取消自动聚焦
        if (_supportAutoFocus)
            [_context cancelAutoFocus];
        [self.liveWindow removeGestureRecognizer:_tapRecognizer];
        _isAutoFocus = false;
        [self.autoFocusButton setBackgroundColor:[UIColor colorWithHexString:@"#000000" alpha:0.3]];
        [self removeAutoFocusVisibleTimer];
    }

}

- (IBAction)zoomButtonPressed:(id)sender {
    if(self.zoomContainerView.hidden) {
        [self setEditType:EDIT_TYPE_ZOOM];
    } else {
        [self setEditType:EDIT_TYPE_NONE];
    }
}

- (IBAction)exposeButtonPressed:(id)sender {
    if(self.exposeContainerView.hidden) {
        [self setEditType:EDIT_TYPE_EXPOSE];
    } else {
        [self setEditType:EDIT_TYPE_NONE];
    }
}

// 开关闪光灯
- (void)flashButtonPressed:(id)sender {
    if(_context.isFlashOn) {
        [_context toggleFlash:false];
        [_flashButton setImage:[UIImage imageNamed:@"flash_off"] forState:UIControlStateNormal];
    } else {
        [_context toggleFlash:true];
        [_flashButton setImage:[UIImage imageNamed:@"flash_on"] forState:UIControlStateNormal];
    }
    
}

// 切换摄像头，需要使用新的相机设备索引重新启动采集预览
- (void)switchFacingButtonPressed:(id)sender {
    [self resetSettings];
    if(_currentDeviceIndex == 0)
        _currentDeviceIndex = 1;
    else
        _currentDeviceIndex = 0;
    [self startCapturePreview];
}

- (IBAction)captureWithFxButtonPressed:(id)sender {
    if(_captureWithFx) {
        _captureWithFx = false;
        [self.captureWithFxButton setBackgroundColor:[UIColor colorWithHexString:@"#000000" alpha:0.3]];
    } else {
        _captureWithFx = true;
        [self.captureWithFxButton setBackgroundColor:[UIColor colorWithHexString:@"#3db5f4" alpha:0.8]];
    }
}

//美颜
- (IBAction)beautyButtonPressed:(id)sender {
    if(self.beautyContainerView.hidden) {
        [self setEditType:EDIT_TYPE_BEAUTY];
    } else {
        [self setEditType:EDIT_TYPE_NONE];
    }
}

- (IBAction)openBeautyButtonPressed:(id)sender {
    if(!_useBeauty) {
        NvsCaptureVideoFx *fx = [_context appendBeautyCaptureVideoFx];
        [fx setFloatVal:@"Strength" val:_strengthSlider.value*0.01];
        [fx setFloatVal:@"Whitening" val:_whiteningSlider.value*0.01];
        [fx setFloatVal:@"Reddening" val:_reddeningSlider.value*0.01];
        _useBeauty = true;
        [_openBeautyButton setTitle:@"关闭美颜" forState:UIControlStateNormal];
    } else {
        int count = [_context getCaptureVideoFxCount];
        for(int i=0;i<count;i++) {
            NvsCaptureVideoFx *fx = [_context getCaptureVideoFxByIndex:i];
            NSString *name = fx.bultinCaptureVideoFxName;
            if([name  isEqual: @"Beauty"]) {
                [_context removeCaptureVideoFx:i];
                break;
            }
                
        }
        _useBeauty = false;
        [_openBeautyButton setTitle:@"开启美颜" forState:UIControlStateNormal];
    }
}

- (void)fxSelectButtonChanged:(id)sender {
    if(self.fxTableView.hidden) {
        [self setEditType:EDIT_TYPE_FX];
    } else {
        [self setEditType:EDIT_TYPE_NONE];
    }
}

//磨皮
- (IBAction)strengthSliderValueChanged:(id)sender {
    double value = self.strengthSlider.value * 0.01;
    NSString* valueStr = [NSString stringWithFormat:@"%.2f",value];
    [self.strengthValueLabel setText:valueStr];
    
    NvsCaptureVideoFx* fx = [_context getCaptureVideoFxByIndex:0];
    [fx setFloatVal:@"Strength" val:value];
}

//红润
- (IBAction)reddeningSliderValueChanged:(id)sender {
    double value = self.reddeningSlider.value * 0.01;
    NSString* valueStr = [NSString stringWithFormat:@"%.2f",value];
    [self.reddeningValueLabel setText:valueStr];
    
    NvsCaptureVideoFx* fx = [_context getCaptureVideoFxByIndex:0];
    [fx setFloatVal:@"Reddening" val:value];
}

//美白
- (IBAction)whiteningSliderValueChanged:(id)sender {
    double value = self.whiteningSlider.value * 0.01;
    NSString* valueStr = [NSString stringWithFormat:@"%.2f",value];
    [self.whiteningValueLabel setText:valueStr];
    
    NvsCaptureVideoFx* fx = [_context getCaptureVideoFxByIndex:0];
    [fx setFloatVal:@"Whitening" val:value];
}

//曝光补偿
- (IBAction)exposeSliderValueChanged:(id)sender {
    [_context setExposureBias:self.exposeSlider.value];
}

//缩放
- (IBAction)zoomSliderValueChanged:(id)sender {
    [_context setZoomFactor:self.zoomSlider.value];
}

- (void) setEditType:(EDIT_TYPE) editType{
    _editType = editType;
    [self updateEditContainerView];
    [self updateEditButtonState];
}

- (void)updateEditContainerView {
    switch (_editType) {
        case EDIT_TYPE_NONE:
            self.beautyContainerView.hidden = true;
            self.zoomContainerView.hidden = true;
            self.exposeContainerView.hidden = true;
            self.fxTableView.hidden = true;
            break;
        case EDIT_TYPE_BEAUTY:
            self.beautyContainerView.hidden = false;
            self.zoomContainerView.hidden = true;
            self.exposeContainerView.hidden = true;
            self.fxTableView.hidden = true;
            break;
        case EDIT_TYPE_EXPOSE:
            self.beautyContainerView.hidden = true;
            self.zoomContainerView.hidden = true;
            self.exposeContainerView.hidden = false;
            self.fxTableView.hidden = true;
            break;
        case EDIT_TYPE_ZOOM:
            self.beautyContainerView.hidden = true;
            self.zoomContainerView.hidden = false;
            self.exposeContainerView.hidden = true;
            self.fxTableView.hidden = true;
            break;
        case EDIT_TYPE_FX:
            self.beautyContainerView.hidden = true;
            self.zoomContainerView.hidden = true;
            self.exposeContainerView.hidden = true;
            self.fxTableView.hidden = false;
            break;
        default:
            break;
    }
}

- (void)updateEditButtonState {
    UIColor *clickedColor = [UIColor colorWithHexString:@"#3db5f4" alpha:0.8];
    UIColor *disableColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
    switch (_editType) {
        case EDIT_TYPE_NONE:
            [self.beautyButton setBackgroundColor:disableColor];
            [self.zoomButton setBackgroundColor:disableColor];
            [self.exposeButton setBackgroundColor:disableColor];
            [self.fxSelectButton setBackgroundColor:disableColor];
            break;
        case EDIT_TYPE_BEAUTY:
            [self.beautyButton setBackgroundColor:clickedColor];
            [self.zoomButton setBackgroundColor:disableColor];
            [self.exposeButton setBackgroundColor:disableColor];
            [self.fxSelectButton setBackgroundColor:disableColor];
            break;
        case EDIT_TYPE_ZOOM:
            [self.beautyButton setBackgroundColor:disableColor];
            [self.zoomButton setBackgroundColor:clickedColor];
            [self.exposeButton setBackgroundColor:disableColor];
            [self.fxSelectButton setBackgroundColor:disableColor];
            break;
        case EDIT_TYPE_EXPOSE:
            [self.beautyButton setBackgroundColor:disableColor];
            [self.zoomButton setBackgroundColor:disableColor];
            [self.exposeButton setBackgroundColor:clickedColor];
            [self.fxSelectButton setBackgroundColor:disableColor];
            break;
        case EDIT_TYPE_FX:
            [self.beautyButton setBackgroundColor:disableColor];
            [self.zoomButton setBackgroundColor:disableColor];
            [self.exposeButton setBackgroundColor:disableColor];
            [self.fxSelectButton setBackgroundColor:clickedColor];
            break;
        default:
            break;
    }
}

- (void) setRadius:(UIView*) view {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:view.bounds.size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = view.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

- (void)setAutoFocusVisibleTimer {
    self.imageAutoFocusRect.hidden = false;
    [_autoFocusViewVisibleTimer invalidate];
    _autoFocusViewVisibleTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                                              target:self
                                                            selector:@selector(handleProgressTimer:)
                                                            userInfo:nil
                                                             repeats:YES];
}

- (void)removeAutoFocusVisibleTimer {
    self.imageAutoFocusRect.hidden = true;
    [_autoFocusViewVisibleTimer invalidate];
}

- (void)handleProgressTimer:(NSTimer *)timer {
    [self removeAutoFocusVisibleTimer];
}

- (NSInteger)maxVideoSize{
    NSInteger max = 1080*1920;
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone4,1"]||[deviceString isEqualToString:@"iPhone3,1"]){
        max = 720*960;
    }
    if ([deviceString isEqualToString:@"iPhone5,2"]){
        max = 1080*1080;
        
    }
    return max;
    
}

//返回
- (void)backBarButtonSelect:(UIButton *)but {
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}
@end
