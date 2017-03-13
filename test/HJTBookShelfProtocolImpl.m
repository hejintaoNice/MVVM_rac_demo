//
//  HJTBookShelfProtocolImpl.m
//  test
//
//  Created by hejintao on 2017/3/6.
//  Copyright © 2017年 hither. All rights reserved.
//

#import "HJTBookShelfProtocolImpl.h"
#import "Recommend.h"

@interface HJTBookShelfProtocolImpl ()
//item 数组
@property (strong,nonatomic) NSMutableArray *itemData;
//书架详情model
@property (strong, nonatomic) NSMutableDictionary *bookShelfData;
//加载更多
@property (assign,nonatomic) NSInteger current_page;
@end

@implementation HJTBookShelfProtocolImpl

-(instancetype)init{
    if (self = [super init]) {
        _current_page = 1;
    }
    return self;
}

- (RACSignal *)requestBookShelfDataSignal:(NSString *)requestUrl KeyWord:(NSString *)key{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [PPNetworkHelper GET:[NSString stringWithFormat:@"%@%@&orderby=%@&page=1",GetCategoryList,requestUrl,key] parameters:nil success:^(id responseObject) {
                [_itemData removeAllObjects];
                NSDictionary *dic = responseObject;
                NSArray *ary = dic[@"data"];
                [ary enumerateObjectsUsingBlock:^(NSDictionary *data, NSUInteger idx, BOOL * _Nonnull stop) {
                    Recommend *model = [Recommend modelWithDict:data];
                    [self.itemData addObject:model];
                }];
                
                [self.bookShelfData setValue:self.itemData forKey:@"bookShelfDataKey"];
                
                [subscriber sendNext:self.bookShelfData];
                [subscriber sendCompleted];
                
            } failure:^(NSError *error) {
                [subscriber sendError:error];
            }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}


- (RACSignal *)requestBookShelfMoreDataSignal:(NSString *)requestUrl KeyWord:(NSString *)key{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        if (self.current_page < 2) {
            self.current_page = 2;
        }
        
        [PPNetworkHelper GET:[NSString stringWithFormat:@"%@%@&orderby=%@&page=%ld",GetCategoryList,requestUrl,key,_current_page] parameters:nil success:^(id responseObject) {
            
            NSDictionary *dic = responseObject;
            NSArray *ary = dic[@"data"];
            NSString *total_page = dic[@"page"][@"total_page"];
            if (_current_page <= [total_page integerValue]) {
                _current_page ++;
            }
            [ary enumerateObjectsUsingBlock:^(NSDictionary *data, NSUInteger idx, BOOL * _Nonnull stop) {
                Recommend *model = [Recommend modelWithDict:data];
                [self.itemData addObject:model];
            }];
            
            [self.bookShelfData setValue:self.itemData forKey:@"bookShelfDataKey"];
            
            [subscriber sendNext:self.bookShelfData];
            [subscriber sendCompleted];
            
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

-(NSMutableArray *)itemData{
    return HJT_LAZY(_itemData, @[].mutableCopy);
}

-(NSMutableDictionary *)bookShelfData{
    return HJT_LAZY(_bookShelfData, @{}.mutableCopy);
}


@end
