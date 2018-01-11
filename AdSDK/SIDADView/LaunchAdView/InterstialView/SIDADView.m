//
//  SIDADView.m
//

#import "SIDADView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface SIDADView()

@property(retain, nonatomic) IBOutletCollection(NSObject) NSArray* superid_ad_closeTargets;
@property(retain,nonatomic) UIButton        *closeBtn;
@property(retain,nonatomic) UIView          *bgView;
@property(retain,nonatomic) UILabel         *titleLable;
@property(retain,nonatomic) UILabel         *subTitleLable;
@property(retain,nonatomic) UIView          *titleBgView;
@property(retain,nonatomic) UIImageView     *adImageView;
@property(retain,nonatomic) NSDictionary    *characterDitionary;

/**图片的点击按钮*/
@property (nonatomic, retain) UIButton *imageBtn;
@end

@implementation SIDADView

- (id)init{
    
    __block typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        weakSelf = [super init];
        if (self) {
            
            self.frame = CGRectMake(0, 0, Screen_width, Screen_height);
            self.backgroundColor = [UIColor clearColor];
            UIView *maskView = ({
                
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
                view.backgroundColor = [UIColor blackColor];
                view.alpha = 0.7;
                view;
            });
            [self addSubview:maskView];
            
            _bgView = ({
                
                UIView *view =[[UIView alloc]initWithFrame: CGRectMake(0, 0, 0.8125*Screen_width, 1.46*0.825*Screen_width)];
                view.frame = CGRectMake(0, 0, 0.8125*Screen_width, 1.46*0.825*Screen_width);
                view.center = CGPointMake(Screen_width/2, Screen_height/2);
                if (isIphone4) {
                    
                    self.center = CGPointMake(Screen_width/2, Screen_height/2+20);
                }
                view.backgroundColor = [UIColor whiteColor];
                view.layer.cornerRadius = 6.0;
                view.clipsToBounds = YES;
                view.layer.borderWidth=1;
//                view.layer.borderColor=superid_ad_color_title.CGColor;
                  view.layer.borderColor=[UIColor clearColor].CGColor;
                view;
                
            });
            
            [self addSubview:_bgView];
            
            _closeBtn = ({
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];;
               
                //             btn.frame = CGRectMake(VIEW_BX(_bgView) *0.5, 30, 33, 33);
                if (isIphone4) {
                    
                    btn.frame = CGRectMake(VIEW_BX(_bgView)-32, 12, 33, 33);
                    
                }else if (kDevice_Is_iPhoneX){
                     btn.frame = CGRectMake(VIEW_BX(_bgView)-32, 90, 33, 33);
                }else{
                     btn.frame = CGRectMake(VIEW_BX(_bgView)-32, 30, 33, 33);
                }
                [btn setBackgroundImage:[self imageOfSuperid_ad_close] forState:normal];
                [btn addTarget:self action:@selector(closeBtnClickEventHandle) forControlEvents:UIControlEventTouchUpInside];
                
                btn;
            });
            
            [self addSubview:_closeBtn];
            
            _titleBgView = ({
                
                //            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_W(_bgView), 0.2105*VIEW_H(_bgView))];
                UIView *view =[[UIView alloc] init];
                view.frame = CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height);
                //            view.center = CGPointMake(Screen_width/2, Screen_height/2);
                view.backgroundColor = [UIColor whiteColor];
                view;
            });
            [_bgView addSubview:_titleBgView];
            
            _titleLable = ({
                
                UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, VIEW_W(_titleBgView), 40)];
                lable.backgroundColor = [UIColor clearColor];
                //            lable.numberOfLines = 0;
                lable.textAlignment = NSTextAlignmentCenter;
                lable.font = [UIFont systemFontOfSize:25];
                lable.textColor = superid_ad_color_title;
                lable.text = @"公告";
                lable;
            });
            [_titleBgView addSubview:_titleLable];
            
            _subTitleLable = ({
                
                UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, VIEW_BY(_titleLable)+5, VIEW_W(_titleBgView)- 40 , _bgView.frame.size.height - 100)];
                lable.numberOfLines = 0;
                lable.backgroundColor = [UIColor clearColor];
                lable.font = [UIFont systemFontOfSize:20];
                //            lable.textColor = superid_ad_color_tips;
                lable.textAlignment = NSTextAlignmentCenter;
                lable.textColor = superid_ad_color_title;
                
                
                
                
                lable;
            });
            //
            [_titleBgView addSubview:_subTitleLable];
            
            //先影藏文字的东西
            _titleBgView.hidden = YES;
            
            _adImageView = ({
                
                UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEW_W(_bgView), VIEW_H(_bgView))];
                view;
                
            });
            
            [_bgView addSubview:_adImageView];
            
            
            _imageBtn = ({
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, VIEW_W(_bgView), VIEW_H(_bgView))];
                btn.backgroundColor = [UIColor clearColor];
                [btn addTarget:self action:@selector(adDetailWebViewBtn) forControlEvents:UIControlEventTouchUpInside];
                btn;
            });
            [_bgView addSubview:_imageBtn];
            
            NSArray *textArray = [[NSArray alloc]initWithObjects:@"含蓄",@"活泼",@"成熟",@"风趣",@"严肃",@"和蔼", nil];
            NSArray *keyArray  = [[NSArray alloc]initWithObjects:@"reserved",@"lively",@"mature",@"humorous",@"serious",@"kindly", nil];
            
            _characterDitionary = [[NSDictionary alloc]initWithObjects:textArray forKeys:keyArray];
        }
        
    });
    
    
    return self;
}

- (void)showInView:(UIView *)view withFaceInfo: (NSDictionary *)info advertisementImageStr: (NSString *)imageStr borderColor: (UIColor *)color{
    

    [_adImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];


    if (color) {
        
        _bgView.layer.borderColor = color.CGColor;
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [view addSubview:self];
    });
    
}

- (void)showInView:(UIView *)view  withPublicNoticeText:(NSString *)noticeText{
    _titleBgView.hidden = NO;
  
   
    
    
    //宽度不变，根据字的多少计算label的高度
    CGSize size = [noticeText sizeWithFont:_subTitleLable.font constrainedToSize:CGSizeMake(_subTitleLable.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    //根据计算结果重新设置UILabel的尺寸
    [_subTitleLable setFrame:CGRectMake(20, VIEW_BY(_titleLable)+5, VIEW_W(_titleBgView)- 40 , size.height)];
    
//    //设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 6;
//
      _subTitleLable.textAlignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:18], NSParagraphStyleAttributeName:paragraphStyle};
    _subTitleLable.attributedText = [[NSAttributedString alloc]initWithString:noticeText attributes:attributes];
    
//     _subTitleLable.text = noticeText;
    
    self.imageBtn.userInteractionEnabled = NO;
    
    [view addSubview:self];
}


- (void)showWithFaceInfo: (NSDictionary *)info advertisementImage: (UIImage *)image borderColor: (UIColor *)color{
    
//    if (!info) {
//
//        return;
//    }

    _titleLable.text  =[self featureTransform:info];
    _adImageView.image = image;
    if (color) {
        
        _bgView.layer.borderColor = color.CGColor;

    }
    [[self getCurrentVC].view addSubview:self];
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
    
}

- (void)closeBtnClickEventHandle{
    
    [self removeFromSuperview];
    _adImageView.image = nil;
    _titleLable.text = nil;
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)dealloc{
    
    _titleLable = nil;
    _adImageView = nil;
    _subTitleLable = nil;
    _bgView = nil;
    _titleBgView = nil;
    _closeBtn = nil;
//    if (self.cancelBlock) {
//        self.cancelBlock();
//    }
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

- (void)drawSuperid_ad_close
{
    //// Color Declarations
    UIColor* white = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
//        UIColor* white = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.8];
    
    //// yuan Drawing
    UIBezierPath* yuanPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(2, 2, 60, 61)];
    [white setStroke];
    yuanPath.lineWidth = 2;
    [yuanPath stroke];
    
    
    //// mid Drawing
    UIBezierPath* midPath = UIBezierPath.bezierPath;
    [midPath moveToPoint: CGPointMake(30.01, 32.5)];
    [midPath addLineToPoint: CGPointMake(18.74, 43.96)];
    [midPath addCurveToPoint: CGPointMake(18.74, 45.98) controlPoint1: CGPointMake(18.2, 44.51) controlPoint2: CGPointMake(18.19, 45.42)];
    [midPath addCurveToPoint: CGPointMake(20.73, 45.98) controlPoint1: CGPointMake(19.29, 46.54) controlPoint2: CGPointMake(20.18, 46.54)];
    [midPath addLineToPoint: CGPointMake(32, 34.52)];
    [midPath addLineToPoint: CGPointMake(43.27, 45.98)];
    [midPath addCurveToPoint: CGPointMake(45.26, 45.98) controlPoint1: CGPointMake(43.82, 46.54) controlPoint2: CGPointMake(44.71, 46.54)];
    [midPath addCurveToPoint: CGPointMake(45.26, 43.96) controlPoint1: CGPointMake(45.81, 45.42) controlPoint2: CGPointMake(45.8, 44.51)];
    [midPath addLineToPoint: CGPointMake(33.99, 32.5)];
    [midPath addLineToPoint: CGPointMake(45.26, 21.04)];
    [midPath addCurveToPoint: CGPointMake(45.26, 19.02) controlPoint1: CGPointMake(45.8, 20.49) controlPoint2: CGPointMake(45.81, 19.58)];
    [midPath addCurveToPoint: CGPointMake(43.27, 19.02) controlPoint1: CGPointMake(44.71, 18.46) controlPoint2: CGPointMake(43.82, 18.46)];
    [midPath addLineToPoint: CGPointMake(32, 30.48)];
    [midPath addLineToPoint: CGPointMake(20.73, 19.02)];
    [midPath addCurveToPoint: CGPointMake(18.74, 19.02) controlPoint1: CGPointMake(20.18, 18.46) controlPoint2: CGPointMake(19.29, 18.46)];
    [midPath addCurveToPoint: CGPointMake(18.74, 21.04) controlPoint1: CGPointMake(18.19, 19.58) controlPoint2: CGPointMake(18.2, 20.49)];
    [midPath addLineToPoint: CGPointMake(30.01, 32.5)];
    [midPath closePath];
    midPath.miterLimit = 4;
    
    midPath.usesEvenOddFillRule = YES;
    
    [white setFill];
    [midPath fill];
}

#pragma mark Generated Images
static UIImage* _imageOfSuperid_ad_close = nil;

- (UIImage*)imageOfSuperid_ad_close
{
    if (_imageOfSuperid_ad_close)
        return _imageOfSuperid_ad_close;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(64, 64), NO, 0.0f);
    [self drawSuperid_ad_close];
    
    _imageOfSuperid_ad_close = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return _imageOfSuperid_ad_close;
}

#pragma mark Customization Infrastructure

- (void)setSuperid_ad_closeTargets: (NSArray*)superid_ad_closeTargets
{
    _superid_ad_closeTargets = superid_ad_closeTargets;
    
    for (id target in self.superid_ad_closeTargets)
        [target setImage: self.imageOfSuperid_ad_close];
}

- (NSString *)featureTransform:(NSDictionary *)info{
    
    NSString *str = [NSString stringWithFormat:@"我是一个%@%@的%@",[self getUserCharacterStr:info],[self getUserAppearanceStrFromInfo:info],[self getGenerationStr:info]];
    return str;
    
}

- (NSString *)getUserCharacterStr:(NSDictionary *)dict{
    
    NSString *key = [dict objectForKey:@"character"];

    if (dict && key ) {
        
        if ([_characterDitionary objectForKey:key]) {
            
            return [_characterDitionary objectForKey:key];
        }else{
            
            return @"幸运";
        }
        
        
    }else{
        
        return @"幸运";
    }
}

- (NSString *)getUserAppearanceStrFromInfo: (NSDictionary *)dict{
    
    NSArray *tagsArray = [dict objectForKey:@"tags"];

    if (!tagsArray) {
        
        return @"";
    }
    BOOL isGoodLooking = NO;
    
    for (int i = 0; i<[tagsArray count]; i++) {
        
        if ([[tagsArray objectAtIndex:i]isEqualToString:@"goodLooking"]) {
            
            isGoodLooking = YES;
            
        }
    }
    if (isGoodLooking == YES) {
        
        if ([[dict objectForKey:@"gender"] isEqualToString:@"male"]) {
            
            return @"帅气";
        }else{
            
            return @"漂亮";
        }
        
    }else{
        
        return @"";
    }

}

- (NSString *)getGenerationStr:(NSDictionary *)info{

    NSString *str = [info objectForKey:@"generation"];
    if (str) {
        
        NSString *ageStr = [str substringToIndex:2];
        ageStr = [NSString stringWithFormat:@"%@后",ageStr];
        return ageStr;
    }else{
        
        return @"人";
    }
    
}

#pragma mark - GestureAction
- (void)adDetailWebViewBtn{
  
    if (self.openWebViewBlock) {
        self.openWebViewBlock();
    }
}

- (void)showInView{
    
}



@end
