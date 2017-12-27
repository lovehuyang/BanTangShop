//
//  HeadViewCell2.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/23.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "HeadViewCell2.h"
#import "NSDate+HLY.h"

@implementation HeadViewCell2
- (instancetype)initWithFrame:(CGRect)frame modle:(FoodModel *)food{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews:food];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)setupSubViews:(FoodModel *)food{
    UIView *backView = [UIView new];
    [self addSubview:backView];
    backView.sd_layout
    .leftSpaceToView(self, 10)
    .centerYEqualToView(self)
    .heightIs(20)
    .widthIs(ScrW/2 - 20);
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.layer.borderColor = Color_Theme.CGColor;
    backView.layer.borderWidth = 1;
    
    
    CGFloat persent_W = [(NSString *)food.leftNumSell floatValue]/[(NSString *)food.leftNum floatValue];
    UILabel *leftNumLab = [UILabel new];
    [backView addSubview:leftNumLab];
    leftNumLab.sd_layout
    .leftEqualToView(backView)
    .topSpaceToView(backView, 0)
    .bottomSpaceToView(backView, 0)
    .widthRatioToView(backView, persent_W);
    leftNumLab.layer.cornerRadius = 5;
    leftNumLab.layer.masksToBounds = YES;
    leftNumLab.backgroundColor = Color_Theme;
    
    UILabel *textLab = [UILabel new];
    [backView addSubview:textLab];
    textLab.sd_layout
    .leftSpaceToView(backView, 0)
    .rightSpaceToView(backView, 0)
    .topSpaceToView(backView, 0)
    .bottomSpaceToView(backView, 0);
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.textColor =[UIColor blackColor];
    textLab.text = [NSString stringWithFormat:@"剩余数量%@/%@",food.leftNumSell,food.leftNum];
    textLab.font = [UIFont boldSystemFontOfSize:13];
    
    BOOL actBool = food.actForever;// 活动是否永久有效
    BOOL actEnd = NO;// 活动是不是已经结束
    // 活动永久生效、活动结束
    food.actEndDate =[NSDate getTimeStr:food.actEndDate];
    DLog(@"活动截止日期：%@",food.actEndDate);
    
    NSDate *startDate = [NSDate date];
    NSString* dateString = [NSDate getDateString:startDate];
    DLog(@"现在的时间 === %@",dateString);
    
    // 比较两个时间
    NSInteger aa = [NSDate compareDate:food.actEndDate withDate:dateString];
    if (aa == 1 || aa == 0) {// 如果活动结束时间和当前时间一样活小于当前时间，则活动结束
        actEnd = YES;
        
    }else{
        actEnd = NO;
    }
    UILabel *actForeverLab = [UILabel new];
    [self addSubview:actForeverLab];
    actForeverLab.sd_layout
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomSpaceToView(self, 1)
    .widthRatioToView(self, 0.5);
    actForeverLab.textAlignment = NSTextAlignmentCenter;
    actForeverLab.font = [UIFont systemFontOfSize:14];
    actForeverLab.text = food.actForever ? @"活动永久生效":(actEnd?@"活动已结束":@"活动进行中");
}

#pragma mark - 分割线
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
