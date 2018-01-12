//
//  WLWebController.m
//  WangliBank
//
//  Created by 王启镰 on 16/6/21.
//  Copyright © 2016年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "WYWebController.h"
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
#import "WLWebProgressLayer.h"
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
@interface WYWebController ()<UIWebViewDelegate>

@end

@implementation WYWebController
{
    UIWebView *_webView;
    
    WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self setupUI];
}

- (void)setupUI {
    if (kDevice_Is_iPhoneX) {

        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }else{
         _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    }
    _webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [_webView loadRequest:request];
    
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (kDevice_Is_iPhoneX) {
        _progressLayer = [WYWebProgressLayer layerWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, 2)];
    }else{
         _progressLayer = [WYWebProgressLayer layerWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 2)];
    }
    [self.view.layer addSublayer:_progressLayer];
    [_progressLayer startLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_progressLayer finishedLoad];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_progressLayer finishedLoad];
}

- (void)dealloc {
    NSLog(@"i am dealloc");
}

- (void)back{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        //退出
        if (self.backBlock) {
            self.backBlock();
        }
    }];
}
@end
