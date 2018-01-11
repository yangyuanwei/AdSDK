//
//  MResultData.h
//  ADViewDemo
//
//  Created by 杨远威 on 2018/1/5.
//  Copyright © 2018年 ISNC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDataModel.h"

@interface MResultData : NSObject
/**
 * 响应吗
 */
@property (nonatomic, copy) NSString *code;

/**
 * msg
 */
@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) MDataModel *result;
@end
