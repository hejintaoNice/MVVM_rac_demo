//
//  HJTViewModelService.h
//  test
//
//  Created by hejintao on 2017/3/6.
//  Copyright © 2017年 hither. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJTBookShelfProtocol.h"
@protocol HJTViewModelService <NSObject>

//获取书架详情服务
-(id<HJTBookShelfProtocol>) getBookShelfService;

@end
