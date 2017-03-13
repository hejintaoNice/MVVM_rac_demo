//
//                                  _oo8oo_
//                                 o8888888o
//                                 88" . "88
//                                 (| -_- |)
//                                 0\  =  /0
//                               ___/'==='\___
//                             .' \\|     |// '.
//                            / \\|||  :  |||// \
//                           / _||||| -:- |||||_ \
//                          |   | \\\  -  /// |   |
//                          | \_|  ''\---/''  |_/ |
//                          \  .-\__  '-'  __/-.  /
//                        ___'. .'  /--.--\  '. .'___
//                     ."" '<  '.___\_<|>_/___.'  >' "".
//                    | | :  `- \`.:`\ _ /`:.`/ -`  : | |
//                    \  \ `-.   \_ __\ /__ _/   .-` /  /
//                =====`-.____`.___ \_____/ ___.`____.-`=====
//                                  `=---=`
//
//
//               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//                          佛祖保佑         永无bug

#import "VTGridViewCell.h"
#import "BookShelfViewModel.h"
@interface VTGridViewCell()

@property (nonatomic,strong)UIView *translucentView;

@property (nonatomic,strong)UIActivityIndicatorView *acView;

@end

@implementation VTGridViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];

        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica" size:13.f];
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        
        _translucentView  = [[UIView alloc]init];

//        UIColor *light = RGBCOLOR(85, 152, 220, 0.76);
//        UIColor *dark = rgba(68, 68, 68, 0.8);
//        _translucentView.dk_backgroundColorPicker = DKColorPickerWithColors(light,dark,FlatRed);
        _translucentView.backgroundColor = RGBCOLOR(85, 152, 220);
        [self.contentView addSubview:_translucentView];

        _commentLabel = [[UILabel alloc] init];
        _commentLabel.textAlignment = NSTextAlignmentRight;
        _commentLabel.font = [UIFont systemFontOfSize:11.f];
        _commentLabel.textColor = [UIColor whiteColor];
        [_translucentView addSubview:_commentLabel];
        
        _acView  = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _acView.center = CGPointMake(self.contentView.frame.size.width/2, self.contentView.frame.size.height/2);
        [self.contentView addSubview:_acView];
        
        
        
        [self configConstraints];
    }
    return self;
}

-(void)configConstraints{
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-34);
    }];
    
    [_translucentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_imageView);
        make.bottom.equalTo(_imageView.mas_bottom).offset(0);
        make.height.equalTo(@20);
    }];
    
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_translucentView.mas_centerY);
        make.left.equalTo(_translucentView);
        make.right.equalTo(_translucentView).offset(-8);
        make.top.bottom.equalTo(_translucentView);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.mas_bottom).offset(0);
        make.height.equalTo(@34);
        make.left.right.equalTo(self);
    }];
}



-(void)bindViewModel:(id)viewModel withParams:(NSDictionary *)params{
    BookShelfViewModel *bookShelfViewModel = viewModel;
    Recommend *model = bookShelfViewModel.bookShelfData[[params[@"DataIndex"]integerValue]];
    _titleLabel.text = model.comic_name;
    NSString *string = model.last_chapter_name;
    NSArray *array = [string componentsSeparatedByString:@" "];
    _commentLabel.text = array[0];
    
    
    NSString *str = IMG;
    NSString *strr = [str stringByReplacingOccurrencesOfString:@"$$" withString:[NSString stringWithFormat:@"%@",model.comic_id]];
    
    [_acView startAnimating];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:strr] placeholderImage:nil options:SDWebImageContinueInBackground | SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if ([NSThread isMainThread]) {
            [_acView stopAnimating];
        }
        
        
    }];
}



@end
