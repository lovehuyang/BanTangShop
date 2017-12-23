//
//  CycleBottomView.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/22.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "CycleBottomView.h"

@implementation CycleBottomView
{
    UIView *starBackView;
}
- (instancetype)initWithFrame:(CGRect)frame model:(FoodModel *)food{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews:food];// 创建字控件
        self.backgroundColor= RGBA(1, 1, 1, 0.5);
    }
    return self;
}

- (void)setupSubViews:(FoodModel *)food{
    UILabel *titleLab = [UILabel new];
    [self addSubview:titleLab];
    titleLab.sd_layout
    .leftSpaceToView(self, 10)
    .topEqualToView(self)
    .heightIs(25)
    .autoWidthRatio(0);
    titleLab.text = food.foodName;
    titleLab.textColor = [UIColor whiteColor];
    [titleLab setSingleLineAutoResizeWithMaxWidth:300];
    // 星星
    starBackView = [UIView new];
    [self addSubview:starBackView];
    starBackView.sd_layout
    .leftSpaceToView(titleLab, 10)
    .topEqualToView(self)
    .widthIs(75)
    .heightRatioToView(titleLab, 1);
    starBackView.backgroundColor = [UIColor clearColor];
    CGFloat star_w = 15;
    for (int i = 0; i < 5; i ++) {
        UIButton *tempBtn = [UIButton new];
        [starBackView addSubview:tempBtn];
        tempBtn.sd_layout
        .centerYEqualToView(starBackView)
        .widthIs(star_w)
        .heightIs(star_w)
        .leftSpaceToView(starBackView, star_w * i);
        [tempBtn setBackgroundImage:[UIImage imageNamed:@"img_star_middle_n"] forState:UIControlStateNormal];
        [tempBtn setBackgroundImage:[UIImage imageNamed:@"img_star_middle_s"] forState:UIControlStateSelected];
        tempBtn.tag = 10 + i;
    }
    [self setStartStatus:[food.stars integerValue]];
    
    // 已售
    UILabel *sell_countLab = [UILabel new];
    [self addSubview:sell_countLab];
    sell_countLab.sd_layout
    .leftEqualToView(titleLab)
    .topSpaceToView(titleLab, 0)
    .heightIs(25)
    .autoWidthRatio(0);
    sell_countLab.font = [UIFont systemFontOfSize:13];
    sell_countLab.textColor = [UIColor whiteColor];
    sell_countLab.text= [NSString stringWithFormat:@"已售:%@",food.sell_count];
    [sell_countLab setSingleLineAutoResizeWithMaxWidth:200];
    
    // 赞
    UILabel *zan_countLab = [UILabel new];
    [self addSubview:zan_countLab];
    zan_countLab.sd_layout
    .rightSpaceToView(self, 10)
    .topEqualToView(sell_countLab)
    .heightRatioToView(sell_countLab, 1);
    zan_countLab.textColor = [UIColor whiteColor];
    zan_countLab.font = [UIFont systemFontOfSize:13];
    zan_countLab.text = [NSString stringWithFormat:@"赞(%@)",food.zan_count];
    [zan_countLab setSingleLineAutoResizeWithMaxWidth:100];
    
    // 赞👍
    UIImageView *imgView = [UIImageView new];
    [self addSubview:imgView];
    imgView.sd_layout
    .rightSpaceToView(zan_countLab, 5)
    .widthIs(15)
    .heightEqualToWidth()
    .centerYEqualToView(zan_countLab);
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [imgView setImage:[UIImage imageNamed:@"dt_dianzan"]];
}

#pragma mark - 设置星星的数量
- (void)setStartStatus:(NSInteger)stars{
   
    for (UIButton *starBtn in starBackView.subviews) {
        if (starBtn.tag - 10 <stars) {
            starBtn.selected = YES;
        }
    }
}
@end
