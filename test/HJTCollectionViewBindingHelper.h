//
//  HJTCollectionViewBindingHelper.h
//  test
//
//  Created by hejintao on 2017/3/6.
//  Copyright © 2017年 hither. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HJTViewModel;

@interface HJTCollectionViewBindingHelper : NSObject

@property (weak, nonatomic) id<UICollectionViewDelegate> delegate;

/**
 代码创建cell时调用
 
 @param collectionView CollectionView
 @param source 数据信号
 @param didSelectionCommand cell选中信号
 @param templateCell cell的类名
 @param viewModel viewModel
 @return 配置好的tableview
 */
+ (instancetype) bindingHelperForCollectionView:(UICollectionView *)collectionView
                              sourceSignal:(RACSignal *)source
                          selectionCommand:(RACCommand *)didSelectionCommand
                              templateCell:(NSString *)templateCell
                             withViewModel:(HJTViewModel *)viewModel;
/**
 xib创建cell时调用
 
 @param collectionView CollectionView
 @param source 数据信号
 @param didSelectionCommand cell选中信号
 @param templateCell Nib的类名
 @param viewModel viewModel
 @return 配置好的tableview
 */
+ (instancetype) bindingHelperForCollectionView:(UICollectionView *)collectionView
                              sourceSignal:(RACSignal *)source
                          selectionCommand:(RACCommand *)didSelectionCommand
                       templateCellWithNib:(NSString *)templateCell
                             withViewModel:(HJTViewModel *)viewModel;

@end
