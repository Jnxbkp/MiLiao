//
//  PayWebViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "PayWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "NSURLRequest+NSURLRequestWithIgnoreSSL.h"

//#import <AlipaySDK/AlipaySDK.h>

@interface PayWebViewController ()<UIWebViewDelegate,NSURLSessionDelegate>
{
    NSURLRequest*_originRequest;
    
    NSURLConnection*_urlConnection;
    
    BOOL _authenticated;
}
@property (nonatomic, strong)UIWebView * webView;
@property (nonatomic, strong)NSURL * url;
@property (nonatomic, strong)JSContext * context;
@property (nonatomic ,strong)NSString * alipayCode;//支付宝返回的状态码
@property (nonatomic, strong) NSString *backCode;//点击系统左上角的返回app的状态码，这里随便给一个值，前提是你和H5端商量好的值
@end

@implementation PayWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"支付"];
    self.view.backgroundColor = ML_Color(248, 248, 248, 1);
    self.alipayCode = @"";//给初始值
    self.backCode = @"";//给初始值
    [self wwebview];

}
- (void)wwebview
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - ML_TopHeight)];
    self.webView.delegate = self;
    // https://devapi.jnxbkp.com:9999  HLRequestUrl
    NSString *urlStr = [NSString stringWithFormat:@"%@/payment/index?token=%@&username=%@&totalFee=%@",HLRequestUrl,[YZCurrentUserModel sharedYZCurrentUserModel].token,[YZCurrentUserModel sharedYZCurrentUserModel].username,self.money];
    
//    NSString *urlStr = [NSString stringWithFormat:@"%@/payment/index?token=%@&username=%@&totalFee=0.01",HLRequestUrl,[YZCurrentUserModel sharedYZCurrentUserModel].token,[YZCurrentUserModel sharedYZCurrentUserModel].username];

    NSLog(@"支付宝连接~~~~~~~~~%@",urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];
    [NSURLRequest allowsAnyHTTPSCertificateForHost:@"https"];
    _originRequest = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:_originRequest];
    [self.view addSubview:self.webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // NOTE: ------  对alipays:相关的scheme处理 -------
    // NOTE: 若遇到支付宝相关scheme，则跳转到本地支付宝App
//    NSString* reqUrl = request.URL.absoluteString;
//    if ([reqUrl hasPrefix:@"alipays://"] || [reqUrl hasPrefix:@"alipay://"]) {
//        // NOTE: 跳转支付宝App
//        BOOL bSucc = [[UIApplication sharedApplication]openURL:request.URL];
//
//        // NOTE: 如果跳转失败，则跳转itune下载支付宝App
//        if (!bSucc) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                           message:@"未检测到支付宝客户端，请安装后重试。"
//                                                          delegate:self
//                                                 cancelButtonTitle:@"立即安装"
//                                                 otherButtonTitles:nil];
//            [alert show];
//        }
//        return NO;
//    }
    return YES;
    
  
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    __weak typeof(self) weakSelf = self;
    //初始化content
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 打印异常,由于JS的异常信息是不会在OC中被直接打印的,所以我们在这里添加打印异常信息,
    self.context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
    };
     if (![self.alipayCode isEqualToString:@""])
     {
         //表示有值
         NSString *alipayCodeJS=[NSString stringWithFormat:@"h5端的方法名('%@')",self.alipayCode];
         //准备执行的js代码
         [self.context evaluateScript: alipayCodeJS];//通过oc方法调用js的alert
         self.alipayCode = @""; //给回空值
     }
    //GCD 防止主线程卡死
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        // 一个异步的任务，例如网络请求，耗时的文件操作等等
        self.context[@"finish"] = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
            
        };
    });
    
    
}
//最后在写一个在支付过程中直接点击左上角的返回App的处理当点击左上角返回App的时候回调用AppDelegate.h用的这个方法
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"resumeBack" object:nil userInfo:nil];
//}
@end
