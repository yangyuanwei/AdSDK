//
//  MDataModel.h
//  ADViewDemo
//
//  Created by 杨远威 on 2017/12/30.
//  Copyright © 2017年 ISNC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MFormContent : NSObject

@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *adForm;

/**
 * 集团广告的广告语  （纯文本  0）
 */
@property (nonatomic, copy) NSString *slogan;
@end


@interface MClickActContent : NSObject

@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, copy) NSString *clickAct;
@end



@interface MDataModel : NSObject


@property (nonatomic, copy) NSString *adId;
/*广告类型*/
@property (nonatomic, copy) NSString *adTypeNum;

@property (nonatomic, copy) NSString *adFormNum;

@property (nonatomic, copy) NSString *clickActNum;

@property (nonatomic, strong) MFormContent *formContent;

@property (nonatomic, strong) MClickActContent *clickActContent;



@end
