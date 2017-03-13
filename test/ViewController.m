//
//  ViewController.m
//  test
//
//  Created by hejintao on 2017/3/6.
//  Copyright © 2017年 hither. All rights reserved.
//

#import "ViewController.h"
#import "HJTCollectionViewBindingHelper.h"
#import "BookShelfViewModel.h"
#import "VTGridViewCell.h"
#import "HJTViewModelServicesImpl.h"
#import "HJTPopMenu.h"
@interface ViewController ()<UICollectionViewDelegate,HJTPopupMenuDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (strong, nonatomic) HJTCollectionViewBindingHelper *tripBindingHelper;

@property (strong, nonatomic) BookShelfViewModel *viewModel;

@property (copy,nonatomic)NSString *userSelectedItem;
@property (strong,nonatomic)NSArray *userSelectedDic;
@property (nonatomic,strong)UIButton *menuBtn;

/**
 *  数据服务
 */
@property (strong, nonatomic) HJTViewModelServicesImpl *viewModelService;


@end

@implementation ViewController

-(instancetype)initWithViewModel:(BookShelfViewModel *)viewModel{
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _userSelectedItem = @"click";
    _userSelectedDic = @[@"click",@"score",@"date"];
    
    [self bindAndConfigViewModel];
    [self configNavSelectMenu];
}

-(void)configNavSelectMenu{
    _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _menuBtn.frame = CGRectMake(0, 0, 50, 40);
    [self.view addSubview:_menuBtn];
    [_menuBtn setTitle:@"人气" forState:UIControlStateNormal];
    [_menuBtn setImage:[UIImage imageNamed:@"navi_filter_normal_"] forState:UIControlStateNormal];
    [_menuBtn setTintColor:[UIColor whiteColor]];
    _menuBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    CGFloat spacing = 3.0;
    
    CGSize imageSize = _menuBtn.imageView.frame.size;
    _menuBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);
    
    CGSize titleSize = _menuBtn.titleLabel.frame.size;
    _menuBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);
    [_menuBtn addTarget:self action:@selector(showNavMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:_menuBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

-(void)showNavMenu:(UIButton *)sender{
    [HJTPopMenu showRelyOnView:sender titles:@[@"人气", @"评分", @"更新"] icons:nil menuWidth:120 delegate:self];
}

-(void)PopupMenuDidSelectedAtIndex:(NSInteger)index PopupMenu:(HJTPopMenu *)PopupMenu{
    
    NSArray *titles = @[@"人气", @"评分", @"更新"];
    [_menuBtn setTitle:[NSString stringWithFormat:@"%@",titles[index]] forState:UIControlStateNormal];
    _userSelectedItem = _userSelectedDic[index];
    [self tapNavBarMenuAction];
}

#pragma mark -- handle tapAction
-(void)tapNavBarMenuAction{
    self.viewModel.keyWord = _userSelectedItem;
    [self.viewModel.requestDataCommand execute:@1];
    [self.collectionView reloadData];
}

#pragma mark -- bind ViewModel
-(void)bindAndConfigViewModel{
    
    self.viewModelService = [[HJTViewModelServicesImpl alloc] initModelServiceImpl];
    
    self.viewModel = [[BookShelfViewModel alloc] initWithServices:self.viewModelService];
    
    self.viewModel.searchUrl = @"?comic_sort=baihe";
    self.viewModel.keyWord = _userSelectedItem;
    [self.viewModel.requestDataCommand execute:@1];
    
    self.tripBindingHelper = [HJTCollectionViewBindingHelper bindingHelperForCollectionView:self.collectionView sourceSignal:RACObserve(self.viewModel, bookShelfData) selectionCommand:nil templateCell:@"VTGridViewCell" withViewModel:self.viewModel];
    self.tripBindingHelper.delegate = self;
    
    @weakify(self);
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.requestDataCommand execute:@1];
    }];
    [[self.viewModel.requestDataCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable executing) {
        @strongify(self);
        if (!executing.boolValue) {
            [self.collectionView.mj_header endRefreshing];
        }
    }];
    
    // 加载更多
    self.collectionView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.bookShelfMoreDataCommand execute:@1];
    }];
    [[self.viewModel.bookShelfMoreDataCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable executing) {
        @strongify(self);
        if (!executing.boolValue) {
            [self.collectionView.mj_footer endRefreshing];
        }
    }];
}

-(UICollectionView *)collectionView{
    NSInteger _cellSpace;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if (IS_IPHONE_4_OR_LESS) {
        _cellSpace = 0.62 * SCREEN_WIDTH-35;
    }else if (IS_IPHONE_5AND5S){
        _cellSpace = 0.62 * SCREEN_WIDTH-40;
    }else if (IS_IPHONE_6AND6S){
        _cellSpace = 0.62 * SCREEN_WIDTH-48;
    }else if (IS_IPHONE_6PAND6SP){
        _cellSpace = 0.62 * SCREEN_WIDTH-55;
    }
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    layout.itemSize = CGSizeMake((SCREEN_WIDTH-60)/3, _cellSpace);;
    return HJT_LAZY(_collectionView, ({
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:collectionView];
        collectionView;
    }));
}


@end
