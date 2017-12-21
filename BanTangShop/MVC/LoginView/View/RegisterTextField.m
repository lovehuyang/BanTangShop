//
//  RegisterTextField.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/21.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "RegisterTextField.h"

@implementation RegisterTextField

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title placeholder:(NSString *)placeholder{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        self.placeholder = placeholder;
        self.font = [UIFont systemFontOfSize:14];
        self.textAlignment = NSTextAlignmentLeft;
        self.tintColor= [UIColor blackColor];
        self.leftView = [self addLefttViewWithTitel:title];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return self;
}

-(UILabel *)addLefttViewWithTitel:(NSString *)title{

    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0 , 55 , self.frame.size.height - 0.5)];
    titleLab.text = title;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = [UIFont boldSystemFontOfSize:14];
//    titleLab.backgroundColor = Color_Back_Gray;
    return  titleLab;
}
- (void)drawRect:(CGRect)rect{
    DLog(@"%f",CGRectGetMaxY(self.frame));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设定起点
    CGContextMoveToPoint(ctx, 0, CGRectGetHeight(self.frame) - 0.5);
    //添加一条线段到坐标为（100，100）的点
    CGContextAddLineToPoint(ctx, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 0.5);
    //设置线条的颜色
    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextStrokePath(ctx);
    
    //3、渲染显示到view上面 (Stroke:空心的)
    CGContextStrokePath(ctx);
}
@end
