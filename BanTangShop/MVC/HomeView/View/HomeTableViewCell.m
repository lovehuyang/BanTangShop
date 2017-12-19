//
//  HomeTableViewCell.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/18.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell
{
    FoodListModel *_food;
    UIImageView *_imgView;
    UILabel *_foodNameLab;
    UIView *_starBackView;// 存放星星的容器
    UILabel *_contentLab;
    UILabel *_priceLab;
    UILabel *_catagoryLab;// 分类
    UILabel *_flavourLab;// 口味
    UILabel *_sealCount;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    _imgView = [UIImageView new];
    [self.contentView addSubview:_imgView];
    _imgView.sd_layout
    .leftSpaceToView(self.contentView, Margin_X)
    .topSpaceToView(self.contentView, Margin_X)
    .widthIs(80)
    .heightEqualToWidth();
    _imgView.sd_cornerRadius = @(5);
    
    _starBackView = [UIView new];
    [self.contentView addSubview:_starBackView];
    _starBackView.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .topEqualToView(_imgView)
    .widthIs(75)
    .heightIs(25);
    _starBackView.backgroundColor = [UIColor whiteColor];
    CGFloat star_w = 15;
    for (int i = 0; i < 5; i ++) {
        UIButton *tempBtn = [UIButton new];
        [_starBackView addSubview:tempBtn];
        tempBtn.sd_layout
        .centerYEqualToView(_starBackView)
        .widthIs(star_w)
        .heightIs(star_w)
        .leftSpaceToView(_starBackView, star_w * i);
        [tempBtn setBackgroundImage:[UIImage imageNamed:@"img_star_middle_n"] forState:UIControlStateNormal];
        [tempBtn setBackgroundImage:[UIImage imageNamed:@"img_star_middle_s"] forState:UIControlStateSelected];
        tempBtn.tag = 10 + i;
    }
    _foodNameLab = [UILabel new];
    [self.contentView addSubview:_foodNameLab];
    _foodNameLab.sd_layout
    .leftSpaceToView(_imgView, 5)
    .topEqualToView(_imgView)
    .heightRatioToView(_starBackView, 1)
    .rightSpaceToView(_starBackView, 5);
    _foodNameLab.font = [UIFont boldSystemFontOfSize:14];
    _foodNameLab.textColor = Color_Theme;
    _foodNameLab.backgroundColor = [UIColor whiteColor];
    
    _contentLab = [UILabel new];
    [self.contentView addSubview:_contentLab];
    _contentLab.sd_layout
    .topSpaceToView(_foodNameLab, 0)
    .leftEqualToView(_foodNameLab)
    .widthRatioToView(_foodNameLab, 1)
    .heightRatioToView(_foodNameLab, 1.6);
    _contentLab.font = [UIFont systemFontOfSize:13];
    _contentLab.numberOfLines = 0;
    _contentLab.textAlignment = NSTextAlignmentLeft;
    
    _priceLab = [UILabel new];
    [self.contentView addSubview:_priceLab];
    _priceLab.sd_layout
    .leftEqualToView(_contentLab)
    .topSpaceToView(_contentLab, 0)
    .heightRatioToView(_foodNameLab, 1)
    .autoWidthRatio(0);
    _priceLab.textColor = Color_Theme;
    _priceLab.font = [UIFont systemFontOfSize:13];
    [_priceLab setSingleLineAutoResizeWithMaxWidth:100];
    
    _catagoryLab = [UILabel new];
    [self.contentView addSubview:_catagoryLab];
    _catagoryLab.sd_layout
    .leftSpaceToView(_priceLab, 0)
    .topEqualToView(_priceLab)
    .bottomEqualToView(_priceLab)
    .autoWidthRatio(0);
    _catagoryLab.textColor = [UIColor grayColor];
    _catagoryLab.font= [UIFont systemFontOfSize:13];
    [_catagoryLab setSingleLineAutoResizeWithMaxWidth:100];
    
    _sealCount = [UILabel new];
    [self.contentView addSubview:_sealCount];
    _sealCount.sd_layout
    .rightEqualToView(_starBackView)
    .topEqualToView(_priceLab)
    .heightRatioToView(_priceLab, 1);
    [_sealCount setSingleLineAutoResizeWithMaxWidth:100];
    _sealCount.textColor = [UIColor grayColor];
    _sealCount.font = [UIFont systemFontOfSize:13];
    
    // 口味
    _flavourLab = [UILabel new];
    [self.contentView addSubview:_flavourLab];
    _flavourLab.sd_layout
    .rightSpaceToView(_sealCount, 0)
    .topEqualToView(_sealCount)
    .bottomEqualToView(_sealCount)
    .autoWidthRatio(0);
    _flavourLab.textColor = [UIColor grayColor];
    _flavourLab.font = [UIFont systemFontOfSize:13];
    [_flavourLab setSingleLineAutoResizeWithMaxWidth:100];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_BASEIP,_food.avatar]] placeholderImage:[UIImage imageNamed:@"common_image_empty"]];
    _foodNameLab.text = _food.foodName;
    _contentLab.text = _food.content;
    _priceLab.text = [NSString stringWithFormat:@"¥:%@",_food.price_New];
    [self setStartStatus];// 设置星星的状态
    _sealCount.text = [NSString stringWithFormat:@"已售:%@",_food.sell_count];
}

- (void)setStartStatus{
    NSInteger starNum = [_food.stars integerValue];
    for (UIButton *starBtn in _starBackView.subviews) {
        if (starBtn.tag - 10 <starNum) {
            starBtn.selected = YES;
        }
    }
}

-(void)setFood:(FoodListModel *)food{
    _food = food;
    [self getFoodCatagory];// 获取食品分类
    [self getFoodFlavour];// 获取食品口味
}
// 获取食品分类
- (void)getFoodCatagory{
    Model *model = [[InfoDBAccess sharedInstance]getInfoFromTable:Table_FoodCatagory_ENUM andId:[_food.catagory stringValue]];
    _catagoryLab.text = [NSString stringWithFormat:@"|%@",model.name];
}
// 获取食品口味
- (void)getFoodFlavour{
    Model *model = [[InfoDBAccess sharedInstance]getInfoFromTable:Table_FoodFlavour_ENUM andId:[_food.flavor stringValue]];
    _flavourLab.text = [NSString stringWithFormat:@"%@|",model.name];
}

- (void)getFoodDetailById{
    NSDictionary *paraDict = @{@"foodId":_food.ID};
    [HLYNetWorkObject requestWithMethod:GET ParamDict:paraDict url:URL_GETFOODDETAILBYID successBlock:^(id requestData, NSDictionary *dataDict) {
        
    } failureBlock:^(NSInteger errCode, NSString *msg) {
        
    }];
}
@end
