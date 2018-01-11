//
//  MPushAdSever.h
//  ADViewDemo
//
//  Created by 杨远威 on 2017/12/30.
//  Copyright © 2017年 ISNC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 *广告类型
 */
typedef NS_ENUM(NSUInteger, MPushAdSever_AD_TYPE) {
    MPushAdSever_AD_TYPE_INLINE = 0 , //inline 广告
    MPushAdSever_AD_TYPE_INT = 1,    //插屏广告（主要）
    MPushAdSever_AD_TYPE_OPEN = 2,   //开屏广告（主要）
    MPushAdSever_AD_TYPE_EXT = 3,    //推广墙广
    MPushAdSever_AD_TYPE_IF = 4,   //信息流广告
    MPushAdSever_AD_TYPE_AUDIO = 5, //音频广告
    MPushAdSever_AD_TYPE_PAUSE = 6, //暂停广告
    MPushAdSever_AD_TYPE_GLOBAL = 7, //集团广告
    MPushAdSever_AD_TYPE_UNRECOGNIZED = -1, //未知广告
};


@interface MPushAdSever : NSObject

/** 广告位id  */
@property (nonatomic, copy) NSString *advertisingId;

/** 后台生成的应用 id  */
@property (nonatomic, copy) NSString *appId;

/** 广告类型  */
@property (nonatomic, assign) MPushAdSever_AD_TYPE  type;

/** 广告位高度  */
@property (nonatomic, assign) CGFloat AdHeight;

/** 广告位宽度  */
@property (nonatomic, assign) CGFloat AdWidth;


/** 绑定的用户id  */
@property(nonatomic,copy)NSString *userId;


/**
 初始化广告位

 @param advertisingId   -广告位id
 @param appId   - 应用id
 @param type   - 广告类型
 @param height -广告位高度
 @param width  -广告位宽度
 @return
 */
//- (instancetype)initWthAdvertisingID:(NSString *)advertisingId appID:(NSString *)appId AdType:(MPushAdSever_AD_TYPE)type AdHeight:(CGFloat)adHeight AdWidth:(CGFloat)adWidth;


/**初始化广告位*/
- (instancetype)initWithAdDict:(NSDictionary *)dict;

/** 连接服务器 */
- (void)connectPushSever;

/** 登录时，绑定用户 */
- (void)bindUser:(NSString *)userId Tag:(NSString *)tag;

/** 退出登录时 解绑用户 */
- (void)unbindUser;
@end
