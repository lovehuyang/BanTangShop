//
//  AddressCell.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/29.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

{
    UILabel *_nameLab;
    UILabel *_phoneLab;
    UILabel *_districtLab;// 街道
    UILabel *_addressLab;
    UIButton *_setDefaultBtn;// 设为默认按钮
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupAllSubviews];
    }
    return self;
}

- (void)setupAllSubviews{
    
    _nameLab = [UILabel new];
    _phoneLab = [UILabel new];
    _districtLab = [UILabel new];
    _addressLab = [UILabel new];
    _setDefaultBtn = [UIButton new];
    UILabel *tipLab = [UILabel new];
    [self.contentView sd_addSubviews:@[_nameLab,_phoneLab,_districtLab,_addressLab,_setDefaultBtn,tipLab]];
    
    _nameLab.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 5)
    .heightIs(25)
    .widthIs(200);
    
    _setDefaultBtn.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .widthIs(30)
    .heightEqualToWidth()
    .centerYEqualToView(self.contentView);
    [_setDefaultBtn setImage:[UIImage imageNamed:@"bt_weixuan"] forState:UIControlStateNormal];
     [_setDefaultBtn setImage:[UIImage imageNamed:@"bt_xuanzhong"] forState:UIControlStateSelected];
    _setDefaultBtn.selected = NO;

    tipLab.sd_layout
    .topSpaceToView(_setDefaultBtn, 0)
    .leftEqualToView(_setDefaultBtn)
    .rightEqualToView(_setDefaultBtn)
    .heightIs(15);
    tipLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setDefaultBtnClick)];
    [tipLab addGestureRecognizer:tap];
    
    _phoneLab.sd_layout
    .rightSpaceToView(_setDefaultBtn, 5)
    .topEqualToView(_nameLab)
    .heightRatioToView(_nameLab, 1)
    .widthIs(100);
    
    _districtLab.sd_layout
    .topSpaceToView(_nameLab, 0)
    .leftEqualToView(_nameLab)
    .rightSpaceToView(_setDefaultBtn, 5)
    .heightRatioToView(_nameLab, 1);
    
    _addressLab.sd_layout
    .leftEqualToView(_nameLab)
    .topSpaceToView(_districtLab, 0)
    .rightSpaceToView(_setDefaultBtn, 5)
    .autoHeightRatio(0);
    
    _phoneLab.textAlignment = NSTextAlignmentRight;
    tipLab.textAlignment = NSTextAlignmentCenter;
    
    _nameLab.font = [UIFont systemFontOfSize:15];
    _phoneLab.font = _nameLab.font;
    tipLab.font = [UIFont systemFontOfSize:12];
    _districtLab.font = [UIFont systemFontOfSize:14];
    _addressLab.font = _districtLab.font;
    _districtLab.textColor = Color_Text_Gray;
    _addressLab.textColor = Color_Text_Gray;
    tipLab.textColor = Color_Text_Gray;
    tipLab.text = @"默认";
    
    [_setDefaultBtn addTarget:self action:@selector(setDefaultBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setAddress:(AddressModel *)address{
    _address = address;
    _nameLab.text = _address.name;
    _phoneLab.text = _address.phone;
    _districtLab.text = _address.district;
    _addressLab.text = _address.address;
    _setDefaultBtn.selected = _address.isdefault;
    [self setupAutoHeightWithBottomView:_addressLab bottomMargin:5];
}

- (void)setDefaultBtnClick{
    if(_setDefaultBtn.selected == NO){
        self.setDefaultAddress(_address);
    }
}
@end
