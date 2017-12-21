//
//  CustomNavView.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/21.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "CustomNavView.h"

@implementation CustomNavView
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews:title];
    }
    return self;
}

- (void)setupSubViews:(NSString *)title{
    //导航栏
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    navView.backgroundColor = Color_Theme;
    [self addSubview:navView];
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, High_Status  , 44, 44);
    [navView addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //标题
    CGFloat btn_W = self.frame.size.width -2 * CGRectGetMaxX(backBtn.frame);
    UILabel *titleLab = [UILabel new];
    titleLab.frame = CGRectMake(CGRectGetMaxX(backBtn.frame), High_Status, btn_W, 44);
//    titleLab.backgroundColor = [UIColor yellowColor];
    [navView addSubview:titleLab];
    titleLab.text = title;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:18];
    titleLab.textColor = [UIColor whiteColor];
}

- (void)backBtnClick{
    self.returnEvent();
}
@end
