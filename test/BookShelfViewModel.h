//
//  BookShelfViewModel.h
//  test
//
//  Created by hejintao on 2017/3/6.
//  Copyright © 2017年 hither. All rights reserved.
//

#import "HJTViewModel.h"
#import "HJTViewModelService.h"
#import "HJTViewModel.h"

@interface BookShelfViewModel : HJTViewModel

/**
 *  错误信号
 */
@property (strong, nonatomic) RACSignal *bookShelfConnectionErrors;
/**
 *  更多数据请求
 */
@property (strong, nonatomic) RACCommand *bookShelfMoreDataCommand;
/**
 *  更多错误信号
 */
@property (strong, nonatomic) RACSignal *bookShelfMoreConnectionErrors;
/**
 *  书架详情
 */
@property (strong, nonatomic) RACCommand *bookShelfDetailCommand;
/**
 *  书架详情数据
 */
@property (strong, nonatomic) NSArray *bookShelfData;

//search Url
@property (nonatomic,copy) NSString *searchUrl;
//key word
@property (nonatomic,copy) NSString *keyWord;


- (instancetype)initWithServices:(id<HJTViewModelService>)services;

@end
