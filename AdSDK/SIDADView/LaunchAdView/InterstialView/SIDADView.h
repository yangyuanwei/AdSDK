//
//  SIDADView.h
//  
//

#import <UIKit/UIKit.h>

#define superid_ad_color_title          HEXRGB(0x0099cc)
#define superid_ad_color_tips           HEXRGB(0x333333)

//RGB Color transform（16 bit->10 bit）
#define HEXRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//Screen Height and width
#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width
#define VIEW_BX(view) (view.frame.origin.x + view.frame.size.width)
#define VIEW_BY(view) (view.frame.origin.y + view.frame.size.height)
//Get View size:
#define VIEW_W(view)  (view.frame.size.width)
#define VIEW_H(view)  (view.frame.size.height)

//iPhone4
#define   isIphone4  [UIScreen mainScreen].bounds.size.height < 500
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@interface SIDADView : UIView

/**
 * 取消
 */
@property (nonatomic, copy)  void(^cancelBlock)();

/**
 * webview
 */
@property (nonatomic, copy) void(^openWebViewBlock)();

/**
 *  带NavigationBar呈现方法：
 *  @param info        使用一登登录后回调的Info，广告视窗的title会根据Info内容使用不同的文案，传入的内容为用户回调信息的persona部分
 *  @param image       开发者的广告图
 *  @param color       弹出视窗的边框颜色
 *
 */

- (void)showWithFaceInfo: (NSDictionary *)info advertisementImage: (UIImage *)image borderColor: (UIColor *)color;

/**纯文字的公告*/
- (void)showInView:(UIView *)view  withPublicNoticeText:(NSString *)noticeText;

//不带NavigationBar呈现方法：
- (void)showInView:(UIView *)view withFaceInfo: (NSDictionary *)info advertisementImageStr: (NSString *)imageStr borderColor: (UIColor *)color;

- (void)showInView;

- (UIViewController *)getCurrentVC;


/**
 绘制按钮背景图
 @return 
 */
- (UIImage*)imageOfSuperid_ad_close;


@end
