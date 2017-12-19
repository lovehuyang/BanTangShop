//
//  TopMenuView.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/19.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "TopMenuView.h"

@implementation TopMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
//    MenuButton *button = [[MenuButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 2)];
//    [button setTitle:_buttonTitle forState:UIControlStateNormal];
//    CGSize btnSize = [GlobalTools sizeWithText:_buttonTitle font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScrW, button.frame.size.height)];
//    button.frame = CGRectMake(0, 0, btnSize.width +15, button.frame.size.height);
//    button.center = CGPointMake(self.center.x, self.center.y);
//    button.selected = YES;
//    [button addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:button];
    
    UILabel *lineLab = [UILabel new];
    [self addSubview:lineLab];
    lineLab.sd_layout
    .rightSpaceToView(self, 0.5)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthIs(0.5);
    lineLab.backgroundColor = [UIColor lightGrayColor];
    
}
- (void)menuBtnClick:(UIButton *)btn{
    btn.selected = YES;
}
- (void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设定起点
    CGContextMoveToPoint(ctx, 0, CGRectGetMaxY(self.frame) - 0.5);
    //添加一条线段到坐标为（100，100）的点
    CGContextAddLineToPoint(ctx, CGRectGetWidth(self.frame), CGRectGetMaxY(self.frame) - 0.5);
    //设置线条的颜色
    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextStrokePath(ctx);
    
    //3、渲染显示到view上面 (Stroke:空心的)
    CGContextStrokePath(ctx);
}
@end
