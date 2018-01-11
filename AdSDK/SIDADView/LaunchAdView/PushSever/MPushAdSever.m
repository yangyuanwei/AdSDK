//
//  MPushAdSever.m
//  ADViewDemo
//
//  Created by 杨远威 on 2017/12/30.
//  Copyright © 2017年 ISNC. All rights reserved.
//

#import "MPushAdSever.h"
#import "GCDAsyncSocket.h"
#import "AFNetworking.h"
#import "RSA.h"
#import "RFIWriter.h"
#import "MessageDataPacketTool.h"
#import <CommonCrypto/CommonCryptor.h>
#import "LFCGzipUtility.h"
#import "MJExtension.h"
#import "MDataModel.h"
#import "MInterstital.h"
#import "Tool.h"

//push端口
//#define AllocHost @"http://192.168.19.11:9999"
//
//#pragma mark 初始化广告位端口
////内网测试环境
//#define Host @"http://192.168.19.15:8080"
//
////开发环境
////#define Host @"http://192.168.16.194:8080"
//
////外网
////#define Host @"http://test.stblapp.com"
//
////初始化广告位
//#define ADHost  [NSString stringWithFormat:@"%@/advertisement/api/advertisingbits/initAdvertisingbit",Host]

@interface MPushAdSever()<GCDAsyncSocketDelegate>

/** 盛放消息内容的数组  */
@property(nonatomic,strong)NSMutableArray *messages;


@property(nonatomic,strong)GCDAsyncSocket *socket;
/**  发送心跳的计时器 */
@property(nonatomic,strong)NSTimer *timer;
/**  一条消息接收到的次数（半包处理） */
@property(nonatomic,assign)int recieveNum;
/**  接收到消息的body Data */
@property(nonatomic,strong)NSMutableData *messageBodyData;

/** 连接次数  */
@property(nonatomic,assign)int connectNum;
/** host  */
@property(nonatomic,copy)NSString *host;
/** port  */
@property(nonatomic,assign)int port;

@property (nonatomic, strong)  MInterstital *globalInterstial;

/**广告位参数*/
@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, strong) NSString *tag;

@end
@implementation MPushAdSever

- (NSMutableData *)messageBodyData{
    
    if (_messageBodyData == nil) {
        _messageBodyData = [[NSMutableData alloc] init];
    }
    return _messageBodyData ;
}

- (NSMutableArray *)messages{
    if (_messages == nil) {
        _messages = [[NSMutableArray alloc] init];
    }
    return _messages;
}

//初始化
- (instancetype)initWthAdvertisingID:(NSString *)advertisingId appID:(NSString *)appId AdType:(MPushAdSever_AD_TYPE)type AdHeight:(CGFloat)adHeight AdWidth:(CGFloat)adWidth{
    
    static MPushAdSever *pushSever = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pushSever = [[MPushAdSever alloc] init];
        
    });
    self.advertisingId = advertisingId;
    self.appId = appId;
    self.type = type;
    self.AdHeight = adHeight;
    self.AdWidth = adWidth;
    
    return self;
}

- (instancetype)initWithAdDict:(NSDictionary *)dict{
    static MPushAdSever *pushSever = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pushSever = [[MPushAdSever alloc] init];
        
    });
    self.advertisingId = dict[@"appId"];
    self.dict = dict;
    [self setUpAd];
    return self;
}

- (void)connectPushSever{
    // 1.建立连接
    [self networkReachability];
    
    //开启异步线程初始化广告位
    
}

/** 绑定用户 */
- (void)bindUser:(NSString *)userId Tag:(NSString *)tag{
    
    [self.messages addObject:@"绑定用户..."];
    //    [self messageTableViewReloadData];
    //绑定用户
    self.userId = userId;
    self.tag = tag;
    //    [self.socket writeData:[MessageDataPacketTool bindDataWithUserId:self.userId andIsUnbindFlag:NO] withTimeout:-1 tag:222];
    [self.socket writeData:[MessageDataPacketTool bindDataWithUserId:self.userId andIsUnbindFlag:NO Tag:tag] withTimeout:-1 tag:222];
}


//登出时解绑用户
- (void)unbindUser{
    if (self.userId) {
        [self.messages addObject:@"解绑用户"];
        //        [self messageTableViewReloadData];
        //解绑用户
        [self.socket writeData:[MessageDataPacketTool bindDataWithUserId:self.userId andIsUnbindFlag:YES Tag:self.tag] withTimeout:-1 tag:222];
        self.userId = nil;
    }
}

- (void)connectToHost{
    // 获取分配的 主机ip 和 端口号
    NSString *urlStr =AllocHost;
    AFHTTPSessionManager *mng = [AFHTTPSessionManager manager];
    mng.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html",nil];
    [mng.requestSerializer setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    mng.requestSerializer= [AFHTTPRequestSerializer serializer];
    mng.responseSerializer= [AFHTTPResponseSerializer serializer];
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    [mng.requestSerializer setValue:currentVersion forHTTPHeaderField:@"version"];
    [mng GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseObjectStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (responseObjectStr.length < 3) {
            return ;
        }
        NSArray *hostArr = [responseObjectStr componentsSeparatedByString:@":"];
        NSString *host = hostArr[0];
        //         NSString *host = hostArr[1];
        //        NSArray *hostArrs= [host componentsSeparatedByString:@","];
        //        NSString *hosts = hostArrs[1];
        //        self.host = hosts;
        self.host = host;
        int port = [hostArr[1] intValue];
        self.port = port;
        NSLog(@"%@---%d",host,port);
        
        // 创建一个Socket对象
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        
        // 连接
        NSError *error = nil;
        [_socket connectToHost:host onPort:port error:&error];
        //        [_socket connectToHost:hosts onPort:port error:&error];
        
        [self.messages addObject:@"socketConnectToHost"];
        //        [self messageTableViewReloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error-----%@",error);
    }];
    
}

/**
 *  网络环境变化判断
 */
- (void)networkReachability{
    //创建网络监听管理者对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    /*
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,//未识别的网络
     AFNetworkReachabilityStatusNotReachable     = 0,//不可达的网络(未连接)
     AFNetworkReachabilityStatusReachableViaWWAN = 1,//2G,3G,4G...
     AFNetworkReachabilityStatusReachableViaWiFi = 2,//wifi网络
     };
     */
    //设置监听
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未识别的网络");
                //                self.navigationItem.title = @"未识别的网络";
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"不可达的网络(未连接)");
                //                self.navigationItem.title = @"网络不可用";
                [self.socket disconnect];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"2G,3G,4G...的网络");
                [self connectToHost];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi的网络");
                [self connectToHost];
                break;
            default:
                break;
        }
    }];
    //开始监听
    [manager startMonitoring];
}

#pragma mark -GCDAsyncSocketDelegate
// 连接主机成功
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"连接主机成功");
    //    self.title = @"连接成功";
    [self.messages addObject:@"socketDidConnectToHost"];
    //    if (![MessageDataPacketTool isFastConnect]) {
    [self.messages addObject:@"发送握手数据"];
    //    [self messageTableViewReloadData];
    [sock writeData:[MessageDataPacketTool handshakeMessagePacketData] withTimeout:-1 tag:222];
    //        return;
    //    }
    
    //    [self.messages addObject:@"发送快速重连数据"];
    //    [self messageTableViewReloadData];
    //    [sock writeData:[MessageDataPacketTool fastConnect] withTimeout:-1 tag:222];
    
}

// 与主机断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    [self clearHeartBeatTimer];
    if(err){
        NSLog(@"断开连接 %@",err);
        //        self.title = @"连接错误";
        _connectNum ++;
        if (_connectNum < MPMaxConnectTimes) {
            sleep(_connectNum+2);
            NSError *error = nil;
            [_socket connectToHost:self.host onPort:self.port error:&error];
        }
    } else{
        NSLog(@"断开连接 %@",err);
    }
    [self.messages addObject:@"socketDidDisconnect"];
    //    [self messageTableViewReloadData];
}

// 数据成功发送到服务器
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"数据成功发送到服务器");
    //数据发送成功后，自己调用一下读取数据的方法，接着_socket才会调用下面的代理方法
    [_socket readDataWithTimeout:-1 tag:tag];
}

// 读取到数据时调用
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    
    //心跳
    if (data.length == 1) {
        return ;
    }
    
    // 半包处理
    int length = 0;
    if (_recieveNum < 1) {
        
        NSData *lengthData = [data subdataWithRange:NSMakeRange(0, 4)];
        [lengthData getBytes: &length length: sizeof(length)];
        NTOHL(length);
    }
    
    if (length > data.length - 13) {
        _recieveNum ++ ;
        [self.messageBodyData appendData:data];
        length = 0;
        return;
    }
    
    
    [self.messageBodyData appendData:data];
    
    length = 0;
    _recieveNum = 0;
    
    IP_PACKET packet ;
    if (self.messageBodyData == nil) {
        //读取到的数据
        packet = [MessageDataPacketTool handShakeSuccessResponesWithData:data];
    } else {
        packet = [MessageDataPacketTool handShakeSuccessResponesWithData:self.messageBodyData];
    }
    self.messageBodyData = nil;
    //解密以前的body
    NSData *body_data = [NSData dataWithBytes:packet.body length:packet.length];
    switch (packet.cmd) {
            
        case MpushMessageBodyCMDHandShakeSuccess:
            NSLog(@"握手成功");
            
            [self.messages addObject:@"握手成功"];
            
            [self processHandShakeDataWithPacket:packet andData:body_data];
            break;
            
        case MpushMessageBodyCMDLogin: //登录
            
            break;
            
        case MpushMessageBodyCMDLogout: //退出
            
            break;
        case MpushMessageBodyCMDBind: //绑定
            NSLog(@"MpushMessageBodyCMDUnbind--绑定成功");
            break;
        case MpushMessageBodyCMDUnbind: //解绑
            
            break;
        case MpushMessageBodyCMDFastConnect: //快速重连
            
            NSLog(@"MpushMessageBodyCMDUNFastConnect");
            [self.messages addObject:@"快速重连成功"];
            //            [self messageTableViewReloadData];
            [self addHeartBeatTimer:[MPUserDefaults doubleForKey:MPHeartbeatData]];
            break;
            
        case MpushMessageBodyCMDStop: //暂停
            break;
            
        case MpushMessageBodyCMDResume: //重新开始
            break;
            
        case MpushMessageBodyCMDError: //错误
            [MessageDataPacketTool errorWithBody:body_data];
            break;
            
        case MpushMessageBodyCMDOk: //ok
            //            [MessageDataPacketTool okWithBody:body_data];
            [self.messages addObject:@"操作成功!"];
            //            [self messageTableViewReloadData];
            break;
            
        case MpushMessageBodyCMDHttp: // http代理
        {
            NSLog(@"ok======聊天=========");
            [self.messages addObject:@"成功调用http代理"];
            //            [self messageTableViewReloadData];
            NSData *bodyData = [MessageDataPacketTool processFlagWithPacket:packet andBodyData:body_data];
            HTTP_RESPONES_BODY responesBody = [MessageDataPacketTool chatDataSuccessWithData:bodyData];
            NSLog(@"--%d",responesBody.statusCode);
        }
            break;
        case MpushMessageBodyCMDPush:  //收到的push消息
            [self processRecievePushMessageWithPacket:packet andData:body_data];
            
            break;
            
        case MpushMessageBodyCMDChat: //聊天
            break;
            
        default:
            break;
    }
    
    [sock readDataWithTimeout:-1 tag:tag];//持续接收服务端放回的数据
}



/**
 *  心跳
 */
- (void)heartbeatSend{
    
    [self.messages addObject:@"发送心跳"];
    //    [self messageTableViewReloadData];
    [_socket writeData:[MessageDataPacketTool heartbeatPacketData] withTimeout:-1 tag:123];
}


/**
 *  处理push收到的消息
 *
 *  @param packet    协议包
 *  @param body_data 协议包body data
 */
- (void)processRecievePushMessageWithPacket:(IP_PACKET)packet andData:(NSData *)body_data{
    id content = [MessageDataPacketTool processRecievePushMessageWithPacket:packet andData:body_data];
    
    MDataModel *model = [MDataModel mj_objectWithKeyValues:content];
    NSLog(@"model = %@",model);
    NSDictionary *dict = @{@"content":model};
    
    //集团广告  MPushAdSever_AD_TYPE_GLOBAL = 7
    if ([model.adTypeNum integerValue] == 7) {
        [self showGlobalPushView:model];
    }else{
        //其他自定义插屏广告
        //要告诉插屏有数据了.发送数据到MInterstitals
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RecievePushData" object:nil userInfo:dict];
    }
    
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 *  处理心跳响应的数据
 *
 *  @param bodyData 握手ok的bodyData
 */
- (void) processHeartDataWithData:(NSData *)bodyData{
    NSLog(@"接收到心跳");
}

/**
 *  处理握手ok响应的数据
 *
 *  @param bodyData 握手ok的bodyData
 */
- (void) processHandShakeDataWithPacket:(IP_PACKET)packet andData:(NSData *)body_data{
    NSLog(@"currentThread--%@",[NSThread currentThread]);
    [MessageDataPacketTool HandSuccessBodyDataWithData:body_data andPacket:packet];
    [self addHeartBeatTimer:[MPUserDefaults doubleForKey:MPHeartbeatData]];
}

/// 增加心跳定时器
- (void)addHeartBeatTimer:(NSTimeInterval)time{
    NSLog(@"MPHeartbeatData--%.2f",[MPUserDefaults doubleForKey:MPHeartbeatData]);
    dispatch_async(dispatch_get_main_queue(), ^{
        _timer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(heartbeatSend) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    });
}

/// 清除心跳定时器
- (void)clearHeartBeatTimer{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_timer invalidate];
        _timer = nil;
    });
}


- (void)showGlobalPushView:(MDataModel *)model{
    self.globalInterstial = [[MInterstital alloc] initWithAppID:self.appId  AdvertisingID:self.advertisingId];
    [self.globalInterstial showFromOtherWindows:model];
}

- (void)setUpAd{
    AFHTTPSessionManager *mng = [AFHTTPSessionManager manager];
    mng.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html",nil];
    [mng.requestSerializer setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    mng.requestSerializer= [AFHTTPRequestSerializer serializer];
    mng.responseSerializer= [AFJSONResponseSerializer serializer]; //请求用json 格式
    mng.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [mng.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mng POST:ADHost parameters:_dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"初始化广告位成功");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AdisOK" object:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"初始化广告位失败");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AdisNOTOK" object:nil];
    }];
    
}

//- (void)loadAd{
//
//    //请求广告
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//
//    NSDictionary *dict = @{
//                           @"appId":self.appid,
//                           @"advertisingbitId":self.advertisingId
//                           };
//    [manager POST:OpenAdHost parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        MDataModel *model  = [MDataModel mj_objectWithKeyValues:responseObject];
//        self.model = model;
//
//    }
//}

@end

