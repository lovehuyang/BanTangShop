//
//  FoodFootView.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/27.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "FoodFootView.h"
#import "NSDate+HLY.h"

@implementation FoodFootView
{
    UITextField *countField;// 数量
    NSInteger buyMinCount;
    NSInteger buyMaxCount;
    NSInteger actBuyMinNum;// 享受活动最少购买数量
    UILabel *messageLab;
    UILabel *totalPriceLab;// 总价显示
    CGFloat actReduce;// 活动减免价
    CGFloat actPercent;// 活动折扣
    BOOL actBool ;// 活动是否永久有效
    BOOL actEnd ;// 活动是不是已经结束
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}
- (void)setupAllSubViews{
    
    NSString *message = @"";
    actBool = self.food.actForever;// 活动是否永久有效
    actEnd = NO;// 活动是不是已经结束
    if (!actBool) {
        // 活动永久生效、活动结束
        self.food.actEndDate =[NSDate getTimeStr:self.food.actEndDate];
        DLog(@"活动截止日期：%@",_food.actEndDate);
        
        NSDate *startDate = [NSDate date];
        NSString* dateString = [NSDate getDateString:startDate];
        DLog(@"现在的时间 === %@",dateString);
        
        // 比较两个时间
        NSInteger aa = [NSDate compareDate:self.food.actEndDate withDate:dateString];
        if (aa == 1 || aa == 0) {// 如果活动结束时间和当前时间一样活小于当前时间，则活动结束
            actEnd = YES;
            message = @"暂无优惠活动";
        }else{
            actEnd = NO;
            message = @"您可享受优惠活动！";
        }
   
    }else{// 活动永久有效
        message = @"您可享受优惠活动！";
    }
    
    messageLab = [UILabel new];
    [self addSubview:messageLab];
    messageLab.sd_layout
    .topEqualToView(self)
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .heightIs(30 );
    messageLab.text = message;
    messageLab.font = [UIFont systemFontOfSize:14];
    UILabel *line = [UILabel new];
    [self addSubview:line];
    line.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(messageLab, 0.5)
    .heightIs(0.5);
    line.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *minusBtn = [UIButton new];
//    minusBtn.backgroundColor = [UIColor redColor];
    [self addSubview:minusBtn];
    minusBtn.sd_layout
    .leftSpaceToView(self, 10)
    .topSpaceToView(line, 2)
    .bottomSpaceToView(self, 2)
    .widthEqualToHeight();
    [minusBtn setImage:[UIImage imageNamed:@"ypx_jianhao"] forState:UIControlStateNormal];
    minusBtn.tag = 10;
    [minusBtn addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    countField = [UITextField new];
    [self addSubview:countField];
    countField.sd_layout
    .leftSpaceToView(minusBtn, 2)
    .widthIs(40 *ScaleX)
    .topSpaceToView(line, 5)
    .bottomSpaceToView(self, 5);
    countField.layer.borderColor= Color_Theme.CGColor;
    countField.layer.borderWidth = 0.5;
    countField.sd_cornerRadius = @(2);
    countField.keyboardType = UIKeyboardTypeNumberPad;
    countField.font = [UIFont systemFontOfSize:13];
    countField.textAlignment = NSTextAlignmentCenter;
    countField.text = [self.food.buyMinNum stringValue];
    [countField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton *plusBtn = [UIButton new];
//    plusBtn.backgroundColor = [UIColor redColor];
    [self addSubview:plusBtn];
    plusBtn.sd_layout
    .leftSpaceToView(countField, 2)
    .topEqualToView(minusBtn)
    .bottomEqualToView(minusBtn)
    .widthRatioToView(minusBtn, 1);
    [plusBtn setImage:[UIImage imageNamed:@"ypx_jiahao"] forState:UIControlStateNormal];
    plusBtn.tag = 11;
    [plusBtn addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    totalPriceLab = [UILabel new];
    [self addSubview:totalPriceLab];
    totalPriceLab.sd_layout
    .leftSpaceToView(plusBtn, 2)
    .topEqualToView(minusBtn)
    .heightRatioToView(minusBtn, 1)
    .widthIs(85 *ScaleX);
    totalPriceLab.backgroundColor = [UIColor whiteColor];
    totalPriceLab.textColor = Color_Theme;
    totalPriceLab.font = [UIFont systemFontOfSize:15];
    [self totalPriceLabContext];// 设置总价显示
    
    // 立即购买
    UIButton *buyBtn = [UIButton new];
    [self addSubview:buyBtn];
    buyBtn.sd_layout
    .rightSpaceToView(self, 0)
    .topSpaceToView(line, 0)
    .bottomSpaceToView(self, 0)
    .widthIs(60 *ScaleX);
    buyBtn.backgroundColor = Color_Theme;
    [buyBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    buyBtn.tag = 12;
    [buyBtn addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shoppingcartBtn = [UIButton new];
    [self addSubview:shoppingcartBtn];
    shoppingcartBtn.sd_layout
    .rightSpaceToView(buyBtn, 0)
    .topSpaceToView(line, 0)
    .bottomSpaceToView(self, 0)
    .widthEqualToHeight();
    shoppingcartBtn.tag = 13;
    [shoppingcartBtn setImage:[UIImage imageNamed:@"nav_team"] forState:UIControlStateNormal];
    [shoppingcartBtn addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lineLab = [UILabel new];
    [self addSubview:lineLab];
    lineLab.backgroundColor = Color_Theme;
    lineLab.sd_layout
    .rightSpaceToView(shoppingcartBtn, 0)
    .topSpaceToView(line, 0)
    .widthIs(0.5)
    .bottomSpaceToView(self, 0);
}

- (void)totalPriceLabContext{
    
    // 购买数量
    NSInteger buyCount = [countField.text integerValue];
    // 没有优惠的总价格
    CGFloat tempTotalPrice = buyCount * [self.food.price_New floatValue];
    
    if (actBool) {// 活动永久有效
        if(buyCount >=actBuyMinNum){// 购买数量大于等于享受活动的最少数量
            if(actReduce != 0){ // 有减免价
                tempTotalPrice = tempTotalPrice - actReduce;
            }else{
                tempTotalPrice = tempTotalPrice * actPercent;
            }
        }
        
    }else{//
        if(!actEnd){// 活动有效期内
            if(buyCount >=actBuyMinNum){// 购买数量大于等于享受活动的最少数量
                if(actReduce != 0){ // 有减免价
                    tempTotalPrice = tempTotalPrice - actReduce;
                }else{
                    tempTotalPrice = tempTotalPrice * actPercent;
                }
            }
        }
    }
    totalPriceLab.text = [self roundPrice:tempTotalPrice];
}

- (void)btnClick:(UIButton *)btn{
    [countField resignFirstResponder];
    NSInteger count = [countField.text integerValue];
    
    switch (btn.tag) {
        case 10:// 减
        {
            if(count >buyMinCount ){
                count --;
            }else{
                [MBProgressHUDTools showTipMessageHudWithtitle:[NSString stringWithFormat:@"该食品最少购买数为%ld%@",(long)buyMinCount,[self getFoodPackage]]];
            }
        }
            break;
        case 11:// 加
        {
            if(count < buyMaxCount ){
                count ++;
            }else{
                [MBProgressHUDTools showTipMessageHudWithtitle:[NSString stringWithFormat:@"该食品最多购买数为%ld%@",(long)buyMaxCount,[self getFoodPackage]]];
            }
        }
            break;
        case 12:// 点击了加入购物车
        {
            self.addtoShoppingCarClick(btn, countField.text,totalPriceLab.text,messageLab.text);
        }
            break;
            
        case 13:// 点击了购物车
        {
            self.addtoShoppingCarClick(btn, countField.text,totalPriceLab.text,messageLab.text);
        }
            break;
            
        default:
            break;
    }
    
    countField.text = [NSString stringWithFormat:@"%ld",(long)count];
    [self totalPriceLabContext];
}
- (void)setFood:(FoodModel *)food{
    _food = food;
    buyMinCount = [_food.buyMinNum integerValue];
    buyMaxCount = [_food.buyMaxNum integerValue];
    actBuyMinNum = [_food.actBuyMinNum integerValue];
    actReduce = [self.food.actReduce floatValue];// 活动减免价
    actPercent = [self.food.actPercent floatValue];// 活动折扣
    [self setupAllSubViews];
}
- (void)drawRect:(CGRect)rect{
    DLog(@"%f",CGRectGetMaxY(self.frame));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设定起点
    CGContextMoveToPoint(ctx, 0,  0);
    //添加一条线段到坐标为（100，100）的点
    CGContextAddLineToPoint(ctx, CGRectGetWidth(self.frame), 0);
    //设置线条的颜色
    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextStrokePath(ctx);
    
    //3、渲染显示到view上面 (Stroke:空心的)
    CGContextStrokePath(ctx);
}

// 获取食品包装单位
- (NSString *)getFoodPackage{
    Model *model = [[InfoDBAccess sharedInstance]getInfoFromTable:Table_FoodPackage_ENUM andId:[_food.packages stringValue]];
    return model.name;
}

- (void)textFieldChanged:(UITextField *)textField{
     NSInteger count = [countField.text integerValue];
    if(count > buyMaxCount){
        countField.text = [NSString stringWithFormat:@"%ld",buyMaxCount];
        [MBProgressHUDTools showTipMessageHudWithtitle:[NSString stringWithFormat:@"该食品最多购买数为%ld%@",(long)buyMaxCount,[self getFoodPackage]]];
    
    }else if (count < buyMinCount){
        countField.text = [NSString stringWithFormat:@"%ld",buyMinCount];
         [MBProgressHUDTools showTipMessageHudWithtitle:[NSString stringWithFormat:@"该食品最少购买数为%ld%@",(long)buyMinCount,[self getFoodPackage]]];
    }
    
    [self totalPriceLabContext];
}

/**
 四舍五入

 @param price 价格
 @return 结果
 */
-(NSString *)roundPrice:(float)price{
    NSNumber *num = [NSNumber numberWithFloat:price];
    NSString *result =[NSString stringWithFormat:@"%.2f",round([num floatValue]*100)/100];
    return result;
}

@end
