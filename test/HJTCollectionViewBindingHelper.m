//
//  HJTCollectionViewBindingHelper.m
//  test
//
//  Created by hejintao on 2017/3/6.
//  Copyright © 2017年 hither. All rights reserved.
//

#import "HJTCollectionViewBindingHelper.h"
#import "HJTReactiveView.h"
#import "HJTViewModel.h"
#import <UIScrollView+EmptyDataSet.h>

@interface HJTCollectionViewBindingHelper ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (strong,nonatomic) UICollectionView *collectionView;

@property (strong,nonatomic) NSArray *data;

@property (strong, nonatomic) RACCommand *didSelectionCommand;

@property (copy, nonatomic) NSString *cellIdentifier;

@property (strong, nonatomic) HJTViewModel  *viewModel;

@end

@implementation HJTCollectionViewBindingHelper

-(instancetype)initWithCollectionView:(UICollectionView*)collectionView sourceSignal:(RACSignal *)source selectionCommand:(RACCommand *)didSelectionCommand withCellType:(NSDictionary *)CellTypeDic withViewModel:(HJTViewModel *)viewModel{
    if (self = [super init]) {
        
        _collectionView = collectionView;
        _data = [NSArray array];
        _didSelectionCommand = didSelectionCommand;
        _viewModel = viewModel;
        
        @weakify(self);
        [source subscribeNext:^(id x) {
            @strongify(self);
            self.data = x;
            [self.collectionView reloadData];
        }];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        
        
        NSString *cellType = CellTypeDic[@"cellType"];
        _cellIdentifier = CellTypeDic[@"cellName"];
        if ([cellType isEqualToString:@"codeType"]) {
            
            Class cell =  NSClassFromString(_cellIdentifier);
            [_collectionView registerClass:cell forCellWithReuseIdentifier:_cellIdentifier];
            
        }else{
            
            UINib *templateCellNib = [UINib nibWithNibName:_cellIdentifier bundle:nil];
            [_collectionView registerNib:templateCellNib forCellWithReuseIdentifier:_cellIdentifier];
        }
        
        [viewModel.requestDataCommand.executing subscribeNext:^(NSNumber *executing) {
            @strongify(self)
            UIView *emptyDataSetView = [self.collectionView.subviews.rac_sequence objectPassingTest:^(UIView *view) {
                return [NSStringFromClass(view.class) isEqualToString:@"DZNEmptyDataSetView"];
            }];
            emptyDataSetView.alpha = 1.0 - executing.floatValue;
        }];
        
    }
    return self;
}

+(instancetype)bindingHelperForCollectionView:(UICollectionView *)collectionView sourceSignal:(RACSignal *)source selectionCommand:(RACCommand *)didSelectionCommand templateCell:(NSString *)templateCell withViewModel:(HJTViewModel *)viewModel{
    NSDictionary *cellDic = @{@"cellType":@"codeType",@"cellName":templateCell};
    return [[HJTCollectionViewBindingHelper alloc] initWithCollectionView:collectionView sourceSignal:source selectionCommand:didSelectionCommand withCellType:cellDic withViewModel:viewModel];
}

+(instancetype)bindingHelperForCollectionView:(UICollectionView *)collectionView sourceSignal:(RACSignal *)source selectionCommand:(RACCommand *)didSelectionCommand templateCellWithNib:(NSString *)templateCell withViewModel:(HJTViewModel *)viewModel{
    NSDictionary *cellDic = @{@"cellType":@"nibType",@"cellName":templateCell};
    return [[HJTCollectionViewBindingHelper alloc] initWithCollectionView:collectionView sourceSignal:source selectionCommand:didSelectionCommand withCellType:cellDic withViewModel:viewModel];
}

#pragma mark - UICollectionViewDeleGate && DataSource
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.collectionView.mj_footer.hidden = (self.data.count == 0) ? YES : NO;
    return self.data.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    id<HJTReactiveView> cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    [cell bindViewModel:self.viewModel withParams:@{@"DataIndex":@(indexPath.row)}];
    return (UICollectionViewCell *)cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self.didSelectionCommand execute:self.data[indexPath.row]];
    if ([self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    
    NSString *text;
    if (self.viewModel.netWorkStatus == YYReachabilityStatusNone) {
        
        text = @"网络君失联了,请检查你的网络设置!";
    }else{
        text = @"此页面可能去火星旅游了!";
    }
    UIFont *font = [UIFont systemFontOfSize:17];
    UIColor *textColor = [UIColor grayColor];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    if (self.viewModel.netWorkStatus == YYReachabilityStatusNone) {
        return [UIImage imageNamed:@"NoNetwork"];
    }else{
        return [UIImage imageNamed:@"NoData"];
    }
    
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *text;
    if (self.viewModel.netWorkStatus == YYReachabilityStatusNone) {
        
        text = @"检查网络设置";
    }else{
        text = @"重新加载";
    }
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *textColor = [UIColor lightGrayColor];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *imageName = @"";
    
    if (state == UIControlStateNormal) imageName = [imageName stringByAppendingString:@"button_background_normal"];
    if (state == UIControlStateHighlighted) imageName = [imageName stringByAppendingString:@"button_background_highlight"];
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsMake(-19.0, -61.0, -19.0, -61.0);
    
    return [[[UIImage imageNamed:imageName] resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}
#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return (self.data.count == 0) ? YES : NO;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return RGBCOLOR(251, 247, 237);
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    
    if (self.viewModel.netWorkStatus == YYReachabilityStatusNone) {
        NSURL *url= [NSURL URLWithString:@"prefs:root=Network"];
        if( [[UIApplication sharedApplication] canOpenURL:url] ) {
            
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                [[UIApplication sharedApplication] openURL:url options:@{}completionHandler:nil];
            }else{
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }else{
        [self.viewModel.requestDataCommand execute:@1];
    }
}

#pragma mark = UICollectionViewDelegate forwarding

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.delegate respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.delegate respondsToSelector:aSelector]) {
        return self.delegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end
