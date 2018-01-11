//
//  MLaunchFullView.m
//  ADViewDemo
//
//  Created by 杨远威 on 2017/12/29.
//  Copyright © 2017年 ISNC. All rights reserved.
//

//Screen Height and width
#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width
#define VIEW_BX(view) (view.frame.origin.x + view.frame.size.width)
#define VIEW_BY(view) (view.frame.origin.y + view.frame.size.height)
//Get View size:
#define VIEW_W(view)  (view.frame.size.width)
#define VIEW_H(view)  (view.frame.size.height)

/*屏幕视频*/
#define iPhoneX ([UIScreen mainScreen].bounds.size.height == 812)
#define iPhone6P ([UIScreen mainScreen].bounds.size.height == 736)
#define iPhone6 ([UIScreen mainScreen].bounds.size.height == 667)
#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)
#define iPhone4 ([UIScreen mainScreen].bounds.size.height == 480)
#import "MLaunchFullView.h"

@interface MLaunchFullView()


@property (weak, nonatomic)UIButton *closeBtn;
@property (weak, nonatomic)UIButton *openBtn;
@property (nonatomic, assign) int timerInterValue;
@property (nonatomic, strong) NSString *btnTitle;
@end

@implementation MLaunchFullView
{
        dispatch_source_t _timer;
}


- (instancetype)initWithFrame:(CGRect)frame buttonTitle:(NSString *)title TimerInteValue:(int)timerInteValue{
    if (self = [super initWithFrame:frame]) {
        self.btnTitle = title;
        //        self.backgroundColor = [UIColor whiteColor];
        UIImageView *imageV = [[UIImageView alloc] init];
        self.imageV = imageV;
        imageV.frame = frame;
        self.timerInterValue = timerInteValue;
        imageV.userInteractionEnabled = YES;
        [self addSubview:imageV];
        
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *titles =  [NSString stringWithFormat:@"%@ %d",title,timerInteValue];
        [closeBtn setTitle:titles forState: UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [closeBtn addTarget:self action:@selector(closeButton) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.45]];
        
        self.closeBtn = closeBtn;
        [self addSubview:closeBtn];
        
        UIButton *openBtn = [[UIButton alloc] init];
        openBtn.backgroundColor = [UIColor clearColor];
        [openBtn addTarget:self action:@selector(imageBtn) forControlEvents:UIControlEventTouchUpInside];
        self.openBtn = openBtn;
        [self addSubview:openBtn];
        
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageV.frame = self.frame;
    if (iPhoneX) {
        self.closeBtn.frame = CGRectMake(VIEW_BX(self)-90, 35, 80, 40);
        self.closeBtn.layer.cornerRadius = 15.0f;
        self.closeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }else if (iPhone6P){
        self.closeBtn.frame = CGRectMake(VIEW_BX(self)-90, 35, 75, 35);
        self.closeBtn.layer.cornerRadius = 15.0f;
        self.closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }else if (iPhone6){
        self.closeBtn.frame = CGRectMake(VIEW_BX(self)-90, 35, 65, 30);
        self.closeBtn.layer.cornerRadius = 15.0f;
        self.closeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }else if (iPhone5){
        self.closeBtn.frame = CGRectMake(VIEW_BX(self)-85, 35, 63, 30);
        self.closeBtn.layer.cornerRadius = 15.0f;
        self.closeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }else if (iPhone4){
        self.closeBtn.frame = CGRectMake(VIEW_BX(self)-80, 35, 64, 30);
        self.closeBtn.layer.cornerRadius = 15.0f;
        self.closeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    self.openBtn.frame = CGRectMake(0, 80, Screen_width, Screen_height - 60 );
    [self insertSubview:self.imageV belowSubview:self.closeBtn];
    
    
}


//关闭广告
- (void)closeButton{
    NSLog(@"closeButton:");
    [self removeFromSuperview];
    if (self.OpenAd_close_Block) {
        self.OpenAd_close_Block();
    }
}

- (void)imageBtn{
    
    if (self.OpenAd_open_Block) {
        self.OpenAd_open_Block();
    }
}

- (void)startWithTime:(NSInteger)timeLine{
    
    __weak typeof(self) weakSelf = self;
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //退出
                [self closeButton];
                //移初广告
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.closeBtn setTitle:[NSString stringWithFormat:@"%@ %ld",self.btnTitle,(long)timeOut] forState:UIControlStateNormal];
                
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    self.imageV.image = [UIImage imageWithContentsOfFile:filePath];
}

-(void) pauseTimer{
    if(_timer){
        dispatch_suspend(_timer);
    }
}
-(void) resumeTimer{
    if(_timer){
        dispatch_resume(_timer);
    }
}
-(void) stopTimer{
    if(_timer){
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}
@end

