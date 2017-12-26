//
//  ShopContractsCell.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/26.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "ShopContractsCell.h"
#import "NSString+HLY.h"

@implementation ShopContractsCell
{
    NSString *_title;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _title = title;
        
    }
    return self;
}

- (void)setupAllSubViews{
    
    UILabel *titleLab = [UILabel new];
    titleLab.textColor =Color_Theme;
    titleLab.backgroundColor = Color_Back_Gray;
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.text = [NSString stringWithFormat:@"  %@",_title];
    [self.contentView addSubview:titleLab];
    titleLab.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(30);
    
    UIImageView *headImgView = [UIImageView new];
    [self.contentView addSubview:headImgView];
    headImgView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(titleLab, 10)
    .widthIs(55 *ScaleX)
    .heightEqualToWidth();
    [headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_BASEIP,_model.avatar]] placeholderImage:[UIImage imageNamed:@"common_image_empty"]];
     [self setupAutoHeightWithBottomView:headImgView bottomMargin:10];
    
    UILabel *nameLab = [UILabel new];
    [self.contentView addSubview:nameLab];
    nameLab.sd_layout
    .leftSpaceToView(headImgView, 10)
    .topEqualToView(headImgView)
    .heightIs(30)
    .autoWidthRatio(0);
    nameLab.text = [NSString stringWithFormat:@"昵称:%@",_model.name];
    [nameLab setSingleLineAutoResizeWithMaxWidth:200];
    nameLab.font = [UIFont systemFontOfSize:14];
    
    UILabel *sexLab = [UILabel new];
    [self.contentView addSubview:sexLab];
    sexLab.sd_layout
    .leftEqualToView(nameLab)
    .topSpaceToView(nameLab, 0)
    .heightRatioToView(nameLab, 1)
    .autoWidthRatio(0);
    NSString *sexStr = [_model.sex isEqualToString:@"0"]?@"女士":@"先生";
    sexLab.text = [NSString stringWithFormat:@"性别:%@",sexStr];
    [sexLab setSingleLineAutoResizeWithMaxWidth:100];
    sexLab.font = [UIFont systemFontOfSize:14];
    
    UILabel *wxLab = [UILabel new];
    [self.contentView addSubview:wxLab];
    wxLab.sd_layout
    .topEqualToView(nameLab)
    .rightSpaceToView(self.contentView, 50)
    .heightRatioToView(nameLab, 1)
    .autoWidthRatio(0);
    NSString *wxStr = [NSString emptyOrNilStr:_model.wx];
    wxLab.text = [NSString stringWithFormat:@"微信:%@",wxStr];
    wxLab.font = [UIFont systemFontOfSize:14];
    [wxLab setSingleLineAutoResizeWithMaxWidth:160];
    
    UILabel *qqLab = [UILabel new];
    [self.contentView addSubview:qqLab];
    qqLab.sd_layout
    .topSpaceToView(wxLab, 0)
    .rightSpaceToView(self.contentView, 50)
    .heightRatioToView(sexLab, 1)
    .autoWidthRatio(0);
    NSString *qqStr = [NSString emptyOrNilStr:_model.qq];
    qqLab.text = [NSString stringWithFormat:@"QQ:%@",qqStr];
    qqLab.font = [UIFont systemFontOfSize:14];
    [qqLab setSingleLineAutoResizeWithMaxWidth:160];
    
    UIImageView *phoneView = [UIImageView new];
    [self.contentView addSubview:phoneView];
    phoneView.sd_layout
    .leftSpaceToView(wxLab, 5)
    .rightSpaceToView(self.contentView, 5)
    .centerYEqualToView(headImgView)
    .heightEqualToWidth();
    [phoneView setImage:[UIImage imageNamed:@"phone_tag"]];
    
    
}
- (void)setModel:(ShopContactsModel *)model{
    _model = model;
    [self setupAllSubViews];
}
@end
