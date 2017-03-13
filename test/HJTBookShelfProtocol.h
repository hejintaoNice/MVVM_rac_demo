//
//  HJTBookShelfProtocol.h
//  test
//
//  Created by hejintao on 2017/3/6.
//  Copyright © 2017年 hither. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HJTBookShelfProtocol <NSObject>

@optional

//加载书架
- (RACSignal *)requestBookShelfDataSignal:(NSString *)requestUrl KeyWord:(NSString *)key;

// 加载首页更多数据
- (RACSignal *)requestBookShelfMoreDataSignal:(NSString *)requestUrl KeyWord:(NSString *)key;

@end
