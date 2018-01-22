//
//  ShoppingCarCell.m
//  BanTangShop
//
//  Created by tzsoft on 2018/1/19.
//  Copyright © 2018年 HLY. All rights reserved.
//

#import "ShoppingCarCell.h"

@implementation ShoppingCarCell
{
    UIImageView *_imgView;
    UILabel *_nameLab;
    UILabel *_brandLab;
    UILabel *_flavorLab;
    UILabel *_priceLab;
    UILabel *_countLab;
    UIButton *_selectBtn;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupAllSubViews];
    }
    return self;
}

- (void)setupAllSubViews{
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_selectBtn];
    _selectBtn.sd_layout
    .leftSpaceToView(self.contentView, 5)
    .centerYEqualToView(self.contentView)
    .widthIs(40)
    .heightIs(40);
    [_selectBtn setImage:[UIImage imageNamed:@"bt_weixuan"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"bt_xuanzhong"] forState:UIControlStateSelected];
    [_selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _imgView = [UIImageView new];
    [self.contentView addSubview:_imgView];
    _imgView.sd_layout
    .leftSpaceToView(_selectBtn, 5)
    .topSpaceToView(self.contentView, Margin_X/2)
    .bottomSpaceToView(self.contentView, Margin_X/2)
    .widthEqualToHeight();
    _imgView.sd_cornerRadius = @(5);
    
    for (int i = 0; i < 4; i ++) {
        UILabel *lab = [UILabel new];
        [self.contentView addSubview:lab];
        lab.sd_layout
        .leftSpaceToView(_imgView, 5)
        .topSpaceToView(self.contentView, i *20 + 10)
        .heightIs(20)
        .rightSpaceToView(self.contentView, i== 3?100 : 30);
        lab.font = [UIFont systemFontOfSize:14];
        if(i == 0){
            _nameLab = lab;
            _nameLab.textColor = Color_Theme;
            _nameLab.font = [UIFont systemFontOfSize:16];
        }else if(i == 1){
            _brandLab = lab;
            
        }else if(i == 2){
            _flavorLab = lab;
        
        }else{
            _priceLab = lab;
            _priceLab.textColor = Color_Theme;
        }
        
    }
    _countLab = [UILabel new];
    [self.contentView addSubview:_countLab];
    _countLab.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .topEqualToView(_priceLab)
    .leftSpaceToView(_priceLab, 5)
    .heightRatioToView(_priceLab, 1);
    _countLab.textAlignment = NSTextAlignmentRight;
    _countLab.textColor = Color_Text_Gray;
    _countLab.font = [UIFont systemFontOfSize:14];
}

- (void)setModel:(ShoppingCarModel *)model{
    _model = model;
    _nameLab.text = model.foodName;
    _brandLab.text = [NSString stringWithFormat:@"品牌:%@",model.brand];
    _flavorLab.text = [NSString stringWithFormat:@"口味:%@",model.flavor];
    _priceLab.text = [NSString stringWithFormat:@"￥%@",model.total_price];
    _countLab.text = [NSString stringWithFormat:@"x%@",model.buy_num];
    _selectBtn.selected = model.isSelected;
    FoodModel *food = model.food;
    NSDictionary *tempDict = (NSDictionary *)food;
    NSString *str = [NSString stringWithFormat:@"%@",tempDict[@"avatar"]];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_BASEIP,str]] placeholderImage:[UIImage imageNamed:@"common_image_empty"]];
}

- (void)selectBtnClick{
    self.cellSelectBtncClick(_selectBtn);
}
@end
