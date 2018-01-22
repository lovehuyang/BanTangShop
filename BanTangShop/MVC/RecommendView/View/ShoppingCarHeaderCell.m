//
//  ShoppingCarHeaderCell.m
//  BanTangShop
//
//  Created by tzsoft on 2018/1/22.
//  Copyright © 2018年 HLY. All rights reserved.
//

#import "ShoppingCarHeaderCell.h"

@implementation ShoppingCarHeaderCell
{
    UIButton *_titleBtn;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupAllsubViews];
    }
    return self;
}
- (void)setupAllsubViews{
    
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, ScrW, 35);
    view.backgroundColor = Color_Back_Gray;
    [self.contentView addSubview:view];
    
    _titleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [_titleBtn setImage:[UIImage imageNamed:@"bt_weixuan"] forState:UIControlStateNormal];
    [_titleBtn setImage:[UIImage imageNamed:@"bt_xuanzhong"] forState:UIControlStateSelected];
    _titleBtn.selected = YES;
    [_titleBtn setTitle:@"测试哦" forState:UIControlStateNormal];
    [_titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_titleBtn addTarget:self action:@selector(sectionHeaderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:_titleBtn];
    _titleBtn.sd_layout
    .leftSpaceToView(view, 15)
    .topSpaceToView(view, 0)
    .bottomSpaceToView(view, 0)
    .rightSpaceToView(view, 10);
    _titleBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // 设置button的图片的约束
    _titleBtn.imageView.sd_layout
    .widthIs(20)
    .centerYEqualToView(_titleBtn)
    .heightIs(20)
    .leftSpaceToView(_titleBtn, 0);
    
    // 设置button的label的约束
    _titleBtn.titleLabel.sd_layout
    .leftSpaceToView(_titleBtn.imageView, 5)
    .centerYEqualToView(_titleBtn)
    .heightRatioToView(_titleBtn, 1);
}
- (void)setModel:(ShoppingCarModel *)model{
    _model = model;
    [_titleBtn setTitle:_model.brand forState:UIControlStateNormal];
}

- (void)setDataArr:(NSArray *)dataArr{
    for (ShoppingCarModel *model in dataArr) {
        if (model.isSelected == NO) {
            _titleBtn.selected = NO;
            return;
        }else{
            _titleBtn.selected = YES;
        }
    }
}
- (void)sectionHeaderBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.tableViewHeaderBtnClick(_model,_titleBtn);
}
@end
