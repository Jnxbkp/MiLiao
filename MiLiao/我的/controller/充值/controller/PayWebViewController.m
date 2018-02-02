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
#import <AlipaySDK/AlipaySDK.h>

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
- (void)loadWithUrlStr:(NSString*)urlStr
{
    if (urlStr.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURLRequest *webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                        cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                    timeoutInterval:30];
            [self.webView loadRequest:webRequest];
        });
    }
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
//
    //新版本的H5拦截支付对老版本的获取订单串和订单支付接口进行合并，推荐使用该接口
    __weak typeof(self) weakSelf = self;
    //return YES为成功获取订单信息并发起支付流程；NO为无法获取订单信息，输入url是普通url
    BOOL isIntercepted = [[AlipaySDK defaultService] payInterceptorWithUrl:[request.URL absoluteString] fromScheme:@"MiLiao" callback:^(NSDictionary *result) {
        // 处理支付结果
        NSLog(@"%@", result);
        // isProcessUrlPay 代表 支付宝已经处理该URL
        if ([result[@"isProcessUrlPay"] boolValue]) {
            // returnUrl 代表 第三方App需要跳转的成功页URL
            NSString* urlStr = result[@"returnUrl"];
            [weakSelf loadWithUrlStr:urlStr];
        }
    }];

    if (isIntercepted) {
        return NO;
    }
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
@end
