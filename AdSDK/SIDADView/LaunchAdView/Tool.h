//
//  Tool.h
//  ADViewDemo
//
//  Created by 杨远威 on 2017/12/26.
//  Copyright © 2017年 ISNC. All rights reserved.
//

//内网测试环境
//#define Host @"http://192.168.19.15:8080"
//开发环境
//#define Host @"http://192.168.16.194:8080"
//外网
//#define Host @"http://test.stblapp.com"

#import <Foundation/Foundation.h>
#define kUserDefaults [NSUserDefaults standardUserDefaults]



#pragma mark 推送服务器请求
#define AllocHost @"http://192.168.19.11:9999"  //小龙环境




#pragma mark 初始化广告位端口
#define ADHost  @"http://192.168.19.15:8080/advertisement/api/advertisingbits/initAdvertisingbit"   //内网测试环境
//#define ADHost  @"http://192.168.16.194:8080/advertisement/api/advertisingbits/initAdvertisingbit" //开发环境
//#define ADHost  @"http://test.stblapp.com/advertisement/api/advertisingbits/initAdvertisingbit" //外网体验


#pragma mark 广告点击率统计端口
#define ClickHost  @"http://192.168.16.101:8080/api/click/addClick"  //俊杰环境



#pragma mark 启动页广告请求
#define OpenAdHost @"http://192.168.19.15:8080/api/advertisingbits/getAdvertisingbit" //内网测试环境
//#define OpenAdHost @"http://192.168.16.194:8080/api/advertisingbits/getAdvertisingbit" //开发环境
//#define OpenAdHost @"http://test.stblapp.com/api/advertisingbits/getAdvertisingbit"  //外网体验




@interface Tool : NSObject
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 *  设置启动页广告
 */
+ (void)setupAdvertWithImageStr;

/**
 *  判断文件是否存在
 */
+(BOOL)isFileExistWithFilePath:(NSString *)filePath;

/**
 *  初始化广告页面
 */
+ (void)getAdvertisingImage :(NSString *)imageUrl;

/**
 *  下载新图片
 */
+ (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName;

/**
 *  删除旧图片
 */
+ (void)deleteOldImage;

/**
 *  根据图片名拼接文件路径
 */
+ (NSString *)getFilePathWithImageName:(NSString *)imageName;
@end
