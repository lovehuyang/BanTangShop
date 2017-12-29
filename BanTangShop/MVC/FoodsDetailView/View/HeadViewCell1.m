//
//  HeadViewCell1.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/23.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "HeadViewCell1.h"

@implementation HeadViewCell1
{
    UIButton *_enjoyBtn;// 收藏按钮
    FoodModel *_food;
}
- (instancetype)initWithFrame:(CGRect)frame modle:(FoodModel *)food{
    if (self = [super initWithFrame:frame]) {
        _food = food;
        [self setupAllSubviews];
        [self getIsLikeFood:_food.ID];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)setupAllSubviews{
    // 现价
    UILabel *price_New_Lab = [UILabel new];
    [self addSubview:price_New_Lab];
    price_New_Lab.sd_layout
    .leftSpaceToView(self, 10)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .autoWidthRatio(0);
    price_New_Lab.text = [NSString stringWithFormat:@"¥:%@",_food.price_New];
    price_New_Lab.textColor = Color_Theme;
    [price_New_Lab setSingleLineAutoResizeWithMaxWidth:300];
    
    // 原价
    UILabel *price_Old_Lab = [UILabel new];
    [self addSubview:price_Old_Lab];
    price_Old_Lab.sd_layout
    .leftSpaceToView(price_New_Lab, 5)
    .bottomEqualToView(self)
    .heightRatioToView(price_New_Lab, 1)
    .autoWidthRatio(0);
    price_Old_Lab.font = [UIFont systemFontOfSize:14];
    price_Old_Lab.text = [NSString stringWithFormat:@"¥:%@",_food.oldPrice];
    price_Old_Lab.textColor = Color_Text_Gray;
    [price_Old_Lab setSingleLineAutoResizeWithMaxWidth:300];
    
    //添加删除线
    NSUInteger length = [price_Old_Lab.text length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:price_Old_Lab.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:Color_Text_Gray range:NSMakeRange(0, length)];
    [price_Old_Lab setAttributedText:attri];
    
    // 收藏
    _enjoyBtn = [UIButton new];
    [self addSubview:_enjoyBtn];
    _enjoyBtn.sd_layout
    .topSpaceToView(self, 5)
    .bottomSpaceToView(self, 5)
    .rightSpaceToView(self, 10)
    .widthIs(55);
    [_enjoyBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [_enjoyBtn setTitle:@"已收藏" forState:UIControlStateSelected];
    _enjoyBtn.sd_cornerRadius = @(3);
    _enjoyBtn.backgroundColor = Color_Theme;
    _enjoyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _enjoyBtn.selected = YES;
    [_enjoyBtn addTarget:self action:@selector(enjoyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)enjoyBtnClick:(UIButton *)enjoyBtn{
    BOOL login = [GlobalTools userIsLogin];
    if (login) {
        [MBProgressHUDTools showLoadingHudWithtitle:@""];
        if(enjoyBtn.selected){
            [self unLikeFood];// 取消收藏
        }else{
            [self likeFood];// 收藏
        }
    }else{
        [GlobalTools presentLoginViewController];
    }
}
#pragma mark - 收藏食品
- (void)likeFood{
    NSDictionary *paramDict = @{@"username":[GlobalTools getData:USER_PHONE],@"foodId":_food.ID};
    [HLYNetWorkObject requestWithMethod:GET ParamDict:paramDict url:URL_LIKEFOOD successBlock:^(id requestData, NSDictionary *dataDict) {
        BOOL result = [(NSString *)dataDict boolValue];
        if (result) {
            [MBProgressHUDTools showTipMessageHudWithtitle:@"收藏食品成功！"];
            _enjoyBtn.selected = YES;
        }else{
            [MBProgressHUDTools showTipMessageHudWithtitle:@"收藏食品失败，请重试！"];
            _enjoyBtn.selected = NO;
        }
       
        self.setEnjoyBtnStatus(_enjoyBtn.selected);

    } failureBlock:^(NSInteger errCode, NSString *msg) {
        [MBProgressHUDTools showTipMessageHudWithtitle:msg];
    }];
}
#pragma mark - 取消收藏
- (void)unLikeFood{
    NSDictionary *paramDict = @{@"username":[GlobalTools getData:USER_PHONE],@"foodId":_food.ID};
    [HLYNetWorkObject requestWithMethod:GET ParamDict:paramDict url:URL_UNLIKEFOOD successBlock:^(id requestData, NSDictionary *dataDict) {
        BOOL result = [(NSString *)dataDict boolValue];
        if (result) {
            [MBProgressHUDTools showTipMessageHudWithtitle:@"取消收藏食品成功！"];
            _enjoyBtn.selected = NO;
        }else{
            [MBProgressHUDTools showTipMessageHudWithtitle:@"取消收藏食品失败，请重试！"];
            _enjoyBtn.selected = YES;
        }
        
        self.setEnjoyBtnStatus(_enjoyBtn.selected);
    } failureBlock:^(NSInteger errCode, NSString *msg) {
        [MBProgressHUDTools showTipMessageHudWithtitle:msg];
    }];
}

- (void)setEnjoyBtnSelectdd:(BOOL)select{
    _enjoyBtn.selected = select;
}
#pragma mark -  食品是否已收藏
- (void)getIsLikeFood:(NSString *)foodId{
    BOOL login = [GlobalTools userIsLogin];
    if(login){
        
        NSDictionary *paramDict = @{@"username":[GlobalTools getData:USER_PHONE],@"foodId":foodId};
        [HLYNetWorkObject requestWithMethod:GET ParamDict:paramDict url:URL_ISLIKEFOOD successBlock:^(id requestData, NSDictionary *dataDict) {
            BOOL isLike = [(NSString *)dataDict boolValue];
            if (isLike) {
                _enjoyBtn.selected = YES;
            }else{
                _enjoyBtn.selected = NO;
            }
        } failureBlock:^(NSInteger errCode, NSString *msg) {
        }];
    }else{
        _enjoyBtn.selected = NO;
    }
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
