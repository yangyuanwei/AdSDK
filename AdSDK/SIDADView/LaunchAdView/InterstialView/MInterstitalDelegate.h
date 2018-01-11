//
//  MInterstitalDelegate.h
//  M广通
//
//  Created by 杨远威 on 2017/12/26.
//  Copyright © 2017年 ISNC. All rights reserved.
/**
   监听 MInterstital 声明周期 接收到的通知
   注意 ：此侦听器中的所有事件都将在应用程序的UI线程上调用
 */

#import <Foundation/Foundation.h>

@class MInterstital;
@protocol MInterstitalDelegate<NSObject>

@required
/**
 * 广告服务器返回了一个广告
 */
-(void)interstitialDidReceiveAd:(MInterstital *)interstitial;



@optional

/**
 * Notifies the delegate that the interstitial has finished loading and can be shown instantly.
 */
-(void)interstitialDidFinishLoading:(MInterstital*)interstitial;
/**
 * Notifies the delegate that the interstitial has failed to load with some error.
 */
//-(void)interstitial:(MInterstital*)interstitial didFailToLoadWithError:(MRequestStatus*)error;
/**
 * Notifies the delegate that the interstitial would be presented.
 */
-(void)interstitialWillPresent:(MInterstital*)interstitial;
/**
 * Notifies the delegate that the interstitial has been presented.
 */
-(void)interstitialDidPresent:(MInterstital *)interstitial;
/**
 * Notifies the delegate that the interstitial has failed to present with some error.
 */
//-(void)interstitial:(MInterstital*)interstitial didFailToPresentWithError:(MRequestStatus*)error;
/**
 * Notifies the delegate that the interstitial will be dismissed.
 */
-(void)interstitialWillDismiss:(MInterstital*)interstitial;
/**
 * Notifies the delegate that the interstitial has been dismissed.
 */
-(void)interstitialDidDismiss:(MInterstital*)interstitial;
/**
 * Notifies the delegate that the interstitial has been interacted with.
 */
-(void)interstitial:(MInterstital*)interstitial didInteractWithParams:(NSDictionary*)params;
/**
 * Notifies the delegate that the user has performed the action to be incentivised with.
 */
-(void)interstitial:(MInterstital*)interstitial rewardActionCompletedWithRewards:(NSDictionary*)rewards;
/**
 * Notifies the delegate that the user will leave application context.
 */
-(void)userWillLeaveApplicationFromInterstitial:(MInterstital*)interstitial;


@end

