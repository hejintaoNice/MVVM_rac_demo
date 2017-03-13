//
//  HJTViewModelServicesImpl.m
//  test
//
//  Created by hejintao on 2017/3/6.
//  Copyright © 2017年 hither. All rights reserved.
//

#import "HJTViewModelServicesImpl.h"
#import "HJTBookShelfProtocolImpl.h"

@interface HJTViewModelServicesImpl ()
//书架详情服务
@property (nonatomic,strong)HJTBookShelfProtocolImpl *bookShelfService;

@end

@implementation HJTViewModelServicesImpl

-(instancetype) initModelServiceImpl{
    if (self = [super init]) {
        _bookShelfService = [HJTBookShelfProtocolImpl new];
    }
    return self;
}

-(id<HJTBookShelfProtocol>)getBookShelfService{
    return self.bookShelfService;
}

@end
