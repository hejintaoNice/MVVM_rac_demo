//
//  BookShelfViewModel.m
//  test
//
//  Created by hejintao on 2017/3/6.
//  Copyright © 2017年 hither. All rights reserved.
//

#import "BookShelfViewModel.h"

@interface BookShelfViewModel ()

@property (strong , nonatomic) id<HJTViewModelService> services;

@end

@implementation BookShelfViewModel

-(instancetype)initWithServices:(id<HJTViewModelService>)services{
    if (self = [super init]) {
        _services = services;
        [self config];
    }
    return self;
}

-(void)config{
    _bookShelfData = [NSArray new];
    self.requestDataCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        if ([input integerValue] == YYReachabilityStatusNone) {
            
            self.netWorkStatus = YYReachabilityStatusNone;
            return [RACSignal empty];
            
        }else{
            
            return [[[_services getBookShelfService] requestBookShelfDataSignal:_searchUrl KeyWord:_keyWord] doNext:^(id x) {
                self.bookShelfData = [NSArray arrayWithArray:x[@"bookShelfDataKey"]];
            }];
        }
    }];
    
   _bookShelfMoreDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       return [[[_services getBookShelfService] requestBookShelfMoreDataSignal:_searchUrl KeyWord:_keyWord] doNext:^(id x) {
           self.bookShelfData = [NSArray arrayWithArray:x[@"bookShelfDataKey"]];
       }];
   }];
    
    _bookShelfDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        return [RACSignal empty];
    }];
    
    _bookShelfMoreConnectionErrors = _bookShelfMoreDataCommand.errors;
}

-(void)setKeyWord:(NSString *)keyWord{
    _keyWord = keyWord;
}

-(void)setSearchUrl:(NSString *)searchUrl{
    _searchUrl = searchUrl;
}

@end
