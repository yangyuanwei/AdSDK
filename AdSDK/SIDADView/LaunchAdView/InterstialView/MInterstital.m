//
//  MInterstital.m
//
//
//  Created by 杨远威 on 2017/12/26.
//  Copyright © 2017年 ISNC. All rights reserved.
//

#import "MInterstital.h"
#import <AFHTTPSessionManager.h>
#import "Tool.h"
#import "SIDADView.h"
#import "MJExtension.h"
#import "MDataModel.h"
#import "WYWebController.h"
#import "GSKeyChainDataManager.h"
///*
// *广告类型
// */
//typedef NS_ENUM(NSUInteger, MPushAdSever_AD_TYPE) {
//    MPushAdSever_AD_TYPE_INLINE = 0 , //inline 广告
//    MPushAdSever_AD_TYPE_INT = 1,    //插屏广告（主要）
//    MPushAdSever_AD_TYPE_OPEN = 2,   //开屏广告（主要）
//    MPushAdSever_AD_TYPE_EXT = 3,    //推广墙广
//    MPushAdSever_AD_TYPE_IF = 4,   //信息流广告
//    MPushAdSever_AD_TYPE_AUDIO = 5, //音频广告
//    MPushAdSever_AD_TYPE_PAUSE = 6, //暂停广告
//     MPushAdSever_AD_TYPE_GLOBAL = 7, //集团广告
//    MPushAdSever_AD_TYPE_UNRECOGNIZED = -1, //未知广告
//};

/*
 广告形式
 */
typedef NS_ENUM(NSUInteger,MPushAdSever_AdForm) {
    MPushAdSever_AdForm_TEXT = 0, //文本
    MPushAdSever_AdForm_IMG = 1, //图片
    MPushAdSever_AdForm_H5 = 2,  //html5
    MPushAdSever_AdForm_GIF = 3, //动画
    MPushAdSever_AdForm_VIDEO = 4, //视频
    MPushAdSever_AdForm_FORM_EXT = 5,//推广墙(文字)
    MPushAdSever_AdForm_PUSH_IMG_TEXT = 6, //推送图文
    MPushAdSever_AdForm_SINGLE_IMG = 7, //单个图
    MPushAdSever_AdForm_AUDIO = 8,    //音频
    MPushAdSever_AdForm_UNRECOGNIZED = -1, //未知
};

/*
 *  广告点击效果
 */
typedef NS_ENUM(NSUInteger,MPushAdSever_ClickEffect) {
    MPushAdSever_ClickEffect_NORMAL = 0,    //无效果
    MPushAdSever_ClickEffect_PHONE = 1,// 拨打电话
    MPushAdSever_ClickEffect_WEB = 2,    //打开网页
    MPushAdSever_ClickEffect_DOWNLOAD = 3,  //下载应用
    MPushAdSever_ClickEffect_MAP = 4,  //打开地图
    MPushAdSever_ClickEffect_VIDEO = 5,  //播放视频
    MPushAdSever_ClickEffect_AUDIO = 6,  //播放音频
    MPushAdSever_ClickEffect_UNRECOGNIZED = -1, //未知
};
#define ScreenBounds [UIScreen mainScreen].bounds
#define Screen_With [UIScreen mainScreen].bounds.size.width
#define Screen_Height  [UIScreen mainScreen].bounds.size.height


//#define ClickHost  @"http://192.168.16.101:8080/api/click/addClick"
@interface MInterstital()

@property(strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong)  SIDADView *adView;
@property (nonatomic, strong) NSString *advertisingId ;
@property (nonatomic, strong) NSString *appid ;
@property (nonatomic, strong)  MDataModel *model ;
@end

@implementation MInterstital
{
    NSDictionary *adDict;
    NSDictionary *adFullDict;
}
- (instancetype)initWithAppID:(NSString*)Appid  AdvertisingID:(NSString *)advertisingId;{
    
    //    static MInterstital *minterstital = nil;
    //    static dispatch_once_t onceToken;
    //    __weak typeof(self) WeakSelf = self;
    //    dispatch_once(&onceToken, ^{
    MInterstital  *minterstital = [[MInterstital alloc] init];
    [self setUpSIADView];
    //    });
    //    [adSever requestOpenAd];
    //    return adSever;
    self.advertisingId = advertisingId;
    self.appid = Appid;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedPushData:) name:@"RecievePushData" object:nil];
    return self;
}

//收到推送消息
- (void)receivedPushData:(NSNotification *)notifi{
    id content= notifi.userInfo[@"content"];
    MDataModel *model = [MDataModel mj_objectWithKeyValues:content];
    NSLog(@"model = %@",model);
    self.model = model;
    
    [self load];
    
}

//全屏广告 （推送广告）
- (void)setUpSIADView{
    
    
    SIDADView *adView = [[SIDADView alloc]init];
    self.adView = adView;
    adView.cancelBlock = ^{
        NSLog(@"%@",[UIApplication sharedApplication].windows);
        UIWindow *keyWindow = [UIApplication sharedApplication].windows[0];
        [keyWindow makeKeyAndVisible];
        
    };
    
    __weak SIDADView *weakAdView = adView;
    adView.openWebViewBlock = ^{
        if ([self.model.clickActNum isEqualToString:@"0"]) {
            return ;
        }
        //点击了网页
        
        NSDictionary *dict = @{
                               @"adId":self.advertisingId,
                               @"appId":self.appid,
                               @"deviceId":[[UIDevice currentDevice].identifierForVendor UUIDString]
                               };
        
        AFHTTPSessionManager *mng = [AFHTTPSessionManager manager];
        mng.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html",nil];
        [mng.requestSerializer setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        mng.requestSerializer= [AFHTTPRequestSerializer serializer];
        mng.responseSerializer= [AFJSONResponseSerializer serializer]; //请求用json 格式
        mng.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [mng.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [mng POST:ClickHost parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"点击了广告");
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"点击广告失败");
            
        }];
        
        
        WYWebController *webVC = [WYWebController new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
        webVC.url = self.model.clickActContent.webUrl;
        [[weakAdView getCurrentVC] presentViewController:nav animated:YES completion:nil];
    };
    
    
    
    
}



- (instancetype)initWithPlacementID:(NSString *)placementID delegate:(id<MInterstitalDelegate>)delegate{
    
    return self;
}

/**
 Loads an MInterstitial
 */
- (void)load {
    //加载请求
    
    
    //请求成功。图片加载成功
    if ([self.delegate respondsToSelector:@selector(interstitialDidReceiveAd:)]) {
        
        [self.delegate interstitialDidReceiveAd:self];
    }
    
}
///**
// * To query if the interstitial is ready to be shown
// */
//- (BOOL)isReady{
//    return YES;
//}

/**
 Displays the interstitial on the screen
 @param viewController : this view controller will be used to present interestitial.
 */
- (void)showFromViewController:(UIViewController *)viewController{
    [self showFromOtherWindows:self.model];
    //  [self.adView showInView:viewController.view withFaceInfo:nil advertisementImageStr:self.model.formContent.img borderColor:nil];
}



-(void)showFromOtherWindows:(MDataModel *)model{
    self.model = model;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIWindow *window2 = [[UIWindow alloc] initWithFrame:ScreenBounds];
        self.window = window2;
        NSLog(@"广告的Window：%@",window2);
        window2.backgroundColor = [UIColor clearColor];
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [UIColor clearColor];
        vc.view.frame = ScreenBounds;
        window2.rootViewController = vc;
        
        
        if ([self.delegate respondsToSelector:@selector(interstitialWillPresent:)]) {
            [self.delegate interstitialWillPresent:self];
        }
        
        //推送集团公告
        if ([self.model.adFormNum integerValue] == MPushAdSever_AdForm_TEXT) {
            [self.adView showInView:vc.view withPublicNoticeText:self.model.formContent.slogan];
            //        [self.adView showInView:vc.view withPublicNoticeText:@"周末加班周末加班周末加班周末周末加班周末加班周末加班周末周末加班周末加班周末加班周末周末加班周末加班周末加班周末周末加班周末加班周末加班周末周末加班周末加班周末加班周末周末加班周末加班周末加班周末周末加班周末加班周末加班周末周末加班周末加班周末加班周末周末加班周末加班周末加班周末周末加班周末加班周末加班周末周末加班周末加班周末加班周末周末加班周末加班周末加班周末周末加班周末加班周末加班周末周末加班周末加班周末加班周末周末加班周末加班周末加班周末"];
            [self.window makeKeyAndVisible];
        }else{
            
            //    [self.adView showInView:vc.view withFaceInfo:nil advertisementImageStr:[self showFullAd:self.dic] borderColor:nil];
            [self.adView showInView:vc.view withFaceInfo:nil advertisementImageStr:self.model.formContent.img borderColor:nil];
            [self.window makeKeyAndVisible];
        }
    });
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RecievePushData" object:nil];
}
@end

