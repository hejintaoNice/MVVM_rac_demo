//
//  HJTViewModel.h
//  test
//
//  Created by hejintao on 2017/3/6.
//  Copyright © 2017年 hither. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJTViewModel : NSObject

/**
 *  数据请求
 */
@property (strong, nonatomic) RACCommand *requestDataCommand;
/**
 *  网络状态
 */
@property (assign , nonatomic) YYReachabilityStatus  netWorkStatus;

@end
