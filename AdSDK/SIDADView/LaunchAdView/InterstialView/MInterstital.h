//
//  MInterstital.h
//  M广通 插屏广告
//
//  Created by 杨远威 on 2017/12/26.
//  Copyright © 2017年 ISNC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import"MInterstitalDelegate.h"
#import "MDataModel.h"

@interface MInterstital : NSObject



/**
 * The delegate to receive callbacks
 */
@property (nonatomic, weak) id<MInterstitalDelegate>delegate ;

/**
 * 初始化插屏广告id
 * @param advertisingId :插屏广告id
 */
- (instancetype)initWithAppID:(NSString*)Appid  AdvertisingID:(NSString *)advertisingId;


/**
 * interstitial（插屏广告）展示到当前的控制器中
 @param viewController : 指定的控制器
 */
- (void)showFromViewController:(UIViewController *)viewController;

/**
 * 将插屏广告展示到窗口
 */
-(void)showFromOtherWindows:(MDataModel *)model;

@end
