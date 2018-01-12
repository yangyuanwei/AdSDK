//
//  MLaunchFullScreen.h
//  ADViewDemo
//
//  Created by 杨远威 on 2017/12/27.
//  Copyright © 2017年 ISNC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface MLaunchFullScreen : NSObject

/**
 * 退出广告时回调
 */
@property (nonatomic, copy) void(^closeAdBlock)(void);
/**
 * 是否初始化广告位成功，回调代表 可以展示
 */
@property (nonatomic, copy) void(^isOkShowAdBlock)(void);


/**
 初始化广告位

 @param appid ：应用id
 @param advertisingId ：广告位id
 @return MLaunchFullScreen
 */
- (instancetype)initWithAppID:(NSString *)appid AdvertisingID:(NSString *)advertisingId;

/**
 设置广告位尺寸 （默认为全屏）
 
 @param frame ：广告位尺寸
 @param title ：“退出”按钮的文字
 @param timerInValue  ：倒计时时间（页面停留的时间）
 */
- (void)setAdFrame:(CGRect)frame ButtonTitle:(NSString *)title TimerIntValue:(int)timerInValue;


/**
 将启动页广告添加到当前的控制器

 @param viewController 当前控制器
 */
- (void)showFromViewController:(UIViewController *)viewController;

@end
