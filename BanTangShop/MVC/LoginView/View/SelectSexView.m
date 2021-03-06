//
//  SelectSexView.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/21.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "SelectSexView.h"

@implementation SelectSexView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupAllSubViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)setupAllSubViews{
    CGFloat average_X = ScrW / 3;
    CGFloat img_W = ScrW / 4;
    UIImageView *boyImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img_W, img_W)];
    boyImgView.center = CGPointMake(average_X, boyImgView.center.y);
    boyImgView.image= [UIImage imageNamed:@"man_icon"];
    boyImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:boyImgView];
    UIButton *boyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    boyBtn.frame = CGRectMake(0, CGRectGetMaxY(boyImgView.frame)+ 5, CGRectGetWidth(boyImgView.frame), 25);
    boyBtn.center = CGPointMake(boyImgView.center.x, boyBtn.center.y);
    [boyBtn setTitle:@" 小伙" forState:UIControlStateNormal];
    [boyBtn setImage:[UIImage imageNamed:@"dl_select"] forState:UIControlStateNormal];
    [boyBtn setImage:[UIImage imageNamed:@"dl_selected"] forState:UIControlStateSelected];
    boyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    boyBtn.selected = YES;
    [boyBtn addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [boyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.boyBtn = boyBtn;
    [self addSubview:self.boyBtn];
    
    UIImageView *girlImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img_W, img_W)];
    girlImgView.center = CGPointMake(2 *average_X, boyImgView.center.y);
    girlImgView.image = [UIImage imageNamed:@"woman_icon"];
    girlImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:girlImgView];
    UIButton *girlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    girlBtn.frame = CGRectMake(0, CGRectGetMaxY(boyImgView.frame)+5, CGRectGetWidth(boyImgView.frame), 25);
    girlBtn.center = CGPointMake(girlImgView.center.x, girlBtn.center.y);
    [girlBtn setTitle:@" 菇凉" forState:UIControlStateNormal];
    [girlBtn setImage:[UIImage imageNamed:@"dl_select"] forState:UIControlStateNormal];
    [girlBtn setImage:[UIImage imageNamed:@"dl_selected"] forState:UIControlStateSelected];
    girlBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [girlBtn addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [girlBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.girlBtn = girlBtn;
    [self addSubview:self.girlBtn];
    
    CGRect frame = [self frame];
    CGFloat hight = CGRectGetMaxY(girlBtn.frame);
    frame.size.height = hight;
    self.frame = frame;
}

- (void)sexBtnClick:(UIButton *)btn{
    
    if (btn==self.boyBtn) {
        self.boyBtn.selected = YES;
        self.girlBtn.selected = NO;
        self.selectSex(Sex_Boy);
    }else{
        self.boyBtn.selected = NO;
        self.girlBtn.selected = YES;
        self.selectSex(Sex_Girl);
    }
}
@end
