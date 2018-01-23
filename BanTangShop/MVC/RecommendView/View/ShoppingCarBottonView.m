//
//  ShoppingCarBottonView.m
//  BanTangShop
//
//  Created by tzsoft on 2018/1/22.
//  Copyright © 2018年 HLY. All rights reserved.
//

#import "ShoppingCarBottonView.h"

@implementation ShoppingCarBottonView

{
    UIButton *_buyBtn;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupAllSubviews];
    }
    return self;
}

- (void)setupAllSubviews{
    
    [self addSelectAllBtn];
    [self addTotalLab];
    [self addBuyBtn];
}

- (void)addBuyBtn{
    _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_buyBtn];
    _buyBtn.sd_layout
    .rightSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .bottomSpaceToView(self, 0)
    .widthIs(100);
    _buyBtn.backgroundColor = Color_Theme;
    [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _buyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [_buyBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addTotalLab{
    _totalLab = [UILabel new];
    [self addSubview:_totalLab];
    _totalLab.sd_layout
    .leftSpaceToView(_selectAllBtn, 0)
    .topSpaceToView(self, 0)
    .bottomSpaceToView(self, 0)
    .widthIs(250);
    _totalLab.textColor = Color_Theme;
}
- (void)addSelectAllBtn{
    _selectAllBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [_selectAllBtn setImage:[UIImage imageNamed:@"bt_weixuan"] forState:UIControlStateNormal];
    [_selectAllBtn setImage:[UIImage imageNamed:@"bt_xuanzhong"] forState:UIControlStateSelected];
    _selectAllBtn.selected = NO;
    [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [_selectAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_selectAllBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    _selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_selectAllBtn];
    _selectAllBtn.sd_layout
    .leftSpaceToView(self, 15)
    .topSpaceToView(self, 0)
    .bottomSpaceToView(self, 0)
    .widthIs(70);
    _selectAllBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // 设置button的图片的约束
    _selectAllBtn.imageView.sd_layout
    .widthIs(20)
    .centerYEqualToView(_selectAllBtn)
    .heightIs(20)
    .leftSpaceToView(_selectAllBtn, 0);
    
    // 设置button的label的约束
    _selectAllBtn.titleLabel.sd_layout
    .leftSpaceToView(_selectAllBtn.imageView, 5)
    .centerYEqualToView(_selectAllBtn)
    .heightRatioToView(_selectAllBtn, 1);
}

- (void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设定起点
    CGContextMoveToPoint(ctx, 0, 0 );
    //添加一条线段到坐标为（100，100）的点
    CGContextAddLineToPoint(ctx, CGRectGetWidth(self.frame), 0);
    //设置线条的颜色
    CGContextSetStrokeColorWithColor(ctx, Color_Theme.CGColor);
    CGContextSetLineWidth(ctx, 1);
    CGContextStrokePath(ctx);
    
    //3、渲染显示到view上面 (Stroke:空心的)
    CGContextStrokePath(ctx);
}

- (void)btnClick{
    self.selectAllBtn.selected = !self.selectAllBtn.selected;
    self.selectAllBtnClick(_selectAllBtn);
}
- (void)buyBtnClick{
    self.buyRightNow();
}
@end
