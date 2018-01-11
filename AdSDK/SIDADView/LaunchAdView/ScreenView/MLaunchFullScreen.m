//
//  MLaunchFullScreen.m
//  ADViewDemo
//
//  Created by 杨远威 on 2017/12/27.
//  Copyright © 2017年 ISNC. All rights reserved.
//

#import "MLaunchFullScreen.h"
#import "MLaunchFullView.h"
#import <UIImageView+WebCache.h>
#import "WYWebController.h"
#import <AFNetworking.h>
#import "MDataModel.h"
#import "MResultData.h"
#import "MJExtension.h"
#import "Tool.h"
#import <UIKit/UIKit.h>

////开屏广告
//
////内网测试环境
//#define Host @"http://192.168.19.15:8080"
//
////开发环境
////#define Host @"http://192.168.16.194:8080"
////外网
////#define Host @"http://test.stblapp.com"
//
//
////#define OpenAdHost @"http://192.168.16.194:8080/api/advertisingbits/getAdvertisingbit"
//#define OpenAdHost  [NSString stringWithFormat:@"%@/advertisement/api/advertisingbits/getAdvertisingbit",Host]
//
////点击广告
//#define ClickHost  @"http://192.168.16.101:8080/api/click/addClick"

static NSString *const adImageName = @"adImageName";
static NSString *const adUrl = @"adUrl";
@interface MLaunchFullScreen()

@property(strong, nonatomic) MLaunchFullView *fullView;

@property(strong, nonatomic) NSString *appid;
@property(strong, nonatomic) NSString *advertisingId;
@property(strong, nonatomic) NSString *placementName;
@property(strong, nonatomic) NSString *platForm;
@property(strong, nonatomic) NSString *adType;
@property(strong, nonatomic) NSString *clickAct;
@property (nonatomic, assign) NSUInteger timerInValue;
@property (nonatomic, strong)  MDataModel *model;
@property (nonatomic, assign) BOOL isShow;

@end

@implementation MLaunchFullScreen

- (instancetype)initWithAppID:(NSString *)appid AdvertisingID:(NSString *)advertisingId{
    
    self.isShow = NO;
    static MLaunchFullScreen *mLaunchFull;
        __weak typeof(self) WeakSelf = self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mLaunchFull = [[MLaunchFullScreen alloc] init];
    });
    
    self.appid = appid;
    self.advertisingId = advertisingId;

    self.platForm = @"ios";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOK) name:@"AdisOK" object:nil];
    
    return self;
}
- (void)setAdFrame:(CGRect)frame ButtonTitle:(NSString *)title TimerIntValue:(int)timerInValue{
    
    MLaunchFullView *fullView = [[MLaunchFullView alloc] initWithFrame:frame buttonTitle:title TimerInteValue:timerInValue];
    
    self.fullView = fullView;
    __block typeof(self) WeakSelf = self;
    self.fullView.OpenAd_close_Block = ^{
        if (WeakSelf.closeAdBlock) {
            
            WeakSelf.closeAdBlock();
           
        }
    };
    

    self.fullView.OpenAd_open_Block = ^{
        if (WeakSelf.fullView.imageV.image) {//有图片
            
            NSDictionary *dict = @{
                                   @"adId":WeakSelf.advertisingId,
                                   @"appId":WeakSelf.appid,
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
            webVC.url = WeakSelf.model.clickActContent.webUrl;
            [[WeakSelf getCurrentVC] presentViewController:nav animated:YES completion:nil];
             NSLog(@"打开启动页广告");
        }else{
            NSLog(@"无启动页广告加载");
        }
    };
    self.timerInValue = timerInValue;
   
}


- (void)loadAd{

                //请求广告
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *dict = @{
                           @"appId":self.appid,
                           @"advertisingbitId":self.advertisingId
                           };
    [manager POST:OpenAdHost parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MResultData *dataModel = [MResultData mj_objectWithKeyValues:responseObject];
        switch ([dataModel.code integerValue]) {
            case 700:
                NSLog(@"启动页请求成功无内容");
                break;
                
            case 200:
                NSLog(@"启动页请求成功并有相应内容");
                break;
                
            case 500:
                NSLog(@"启动页请求系统异常");
                break;
                
            case 206:
                NSLog(@"启动页请求参数不正确");
                break;
                
            default:
                break;
        }
        if ([dataModel.code isEqualToString:@"700"]) {//成功无内容
            NSLog(@"成功无内容");
        }
        MDataModel *model = dataModel.result;
        self.model = model;
        //         [self.fullView.imageV sd_setImageWithURL:[NSURL URLWithString:model.formContent.img]];
        //         [self.fullView.imageV sd_setImageWithURL:[NSURL URLWithString:@"http://120.76.53.52/advertisement/api/ad/advertising/advertising/filePicUrl?name=20171225162137.png"]];
        
//        model.formContent.img = @"https://ss3.baidu.com/-fo3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=2d6e81b5fd36afc3110c39658319eb85/908fa0ec08fa513d08b6a0ab376d55fbb2fbd9a3.jpg";
        [self.fullView.imageV sd_setImageWithURL:[NSURL URLWithString:model.formContent.img] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self.fullView startWithTime:self.timerInValue];
            
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)loadMyAd{
    
    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
    NSString *filePath = [Tool getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
    
    BOOL isExist = [Tool isFileExistWithFilePath:filePath];
    if (isExist) { // 图片存在
        
        //将图片的路径传出去，展示图片
        self.fullView.filePath = filePath;
        
    }else{ //图片不存在
        
        //请求广告
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSDictionary *dict = @{
                               @"appId":self.appid,
                               @"advertisingbitId":self.advertisingId
                               };
        [manager POST:OpenAdHost parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            MResultData *dataModel = [MResultData mj_objectWithKeyValues:responseObject];
            
            switch ([dataModel.code integerValue]) {
                case 700:
                    NSLog(@"启动页请求成功无内容");
                    break;
                    
                case 200:
                    NSLog(@"启动页请求成功并相应内容");
                    break;
                    
                case 500:
                    NSLog(@"启动页请求系统异常");
                    break;
                    
                case 206:
                    NSLog(@"启动页请求参数不正确");
                    break;
                    
                default:
                    break;
            }
            if ([dataModel.code isEqualToString:@"700"]) {//成功无内容
                NSLog(@"成功无内容");
            }
            MDataModel *model = dataModel.result;
            self.model = model;
            //         [self.fullView.imageV sd_setImageWithURL:[NSURL URLWithString:model.formContent.img]];
            //         [self.fullView.imageV sd_setImageWithURL:[NSURL URLWithString:@"http://120.76.53.52/advertisement/api/ad/advertising/advertising/filePicUrl?name=20171225162137.png"]];
            

//            [Tool getAdvertisingImage:self.model.formContent.img];
//            [self.fullView startWithTime:self.timerInValue];
            model.formContent.img = @"http://120.76.53.52/advertisement/api/ad/advertising/advertising/filePicUrl?name=2;0171225162137.png";
            [self.fullView.imageV sd_setImageWithURL:[NSURL URLWithString:model.formContent.img] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [self.fullView startWithTime:self.timerInValue];
                
            }];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }
}

- (void)showFromViewController:(UIViewController *)viewController{
//    self.fullView.frame = viewController.view.frame;
    [viewController.view addSubview:self.fullView];
    self.isShow = YES;
    
}


- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

#pragma mark Notification
- (void)receiveOK{
 //初始化广告位成功，才去请求广告
    [self loadAd];
    if (self.isOkShowAdBlock) {
        self.isOkShowAdBlock();
    }
   
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
