//
//  HJTReactiveView.h
//  test
//
//  Created by hejintao on 2017/3/6.
//  Copyright © 2017年 hither. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HJTReactiveView <NSObject>

/**
 绑定一个viewmodel给view
 
 @param viewModel Viewmodel
 */
- (void)bindViewModel:(id)viewModel withParams:(NSDictionary *)params;

@end
