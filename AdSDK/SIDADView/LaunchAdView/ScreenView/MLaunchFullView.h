//
//  MLaunchFullView.h
//  ADViewDemo
//
//  Created by 杨远威 on 2017/12/29.
//  Copyright © 2017年 ISNC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLaunchFullView : UIView

@property (weak, nonatomic)UIImageView *imageV;
/**
 * 退出开屏广告
 */
@property (nonatomic, copy) void(^OpenAd_close_Block)();
@property (nonatomic, copy) void(^OpenAd_open_Block)();

/**
 *自定义广告尺寸，默认为全屏
 * frame： 广告尺寸
 * title: 退出按钮的文字
 @param instancetype
 @return
 */

- (instancetype)initWithFrame:(CGRect)frame buttonTitle:(NSString *)title TimerInteValue:(int)timerInteValue;

- (void)startWithTime:(NSInteger)timeLine;

/**
 *  图片路径
 */
@property (nonatomic, copy) NSString *filePath;
@end
