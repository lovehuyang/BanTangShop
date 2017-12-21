//
//  LoginTextField.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/21.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "LoginTextField.h"

@implementation LoginTextField

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder img:(NSString *)img{
    if (self =[super initWithFrame:frame ]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        self.placeholder = placeholder;
        self.font = [UIFont systemFontOfSize:14];
        self.textAlignment = NSTextAlignmentLeft;
        self.tintColor= [UIColor grayColor];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.leftView = [self addLefttViewWithImgName:img withSuperViewHight:self.frame.size.height];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        
    }
    return self;
}

-(UIView *)addLefttViewWithImgName:(NSString *)iconName withSuperViewHight:(CGFloat )hight{
    
    CGFloat icon_WH =  15 ;// 图标的尺寸
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, icon_WH +10, hight)];
    UIImageView *icon_Img = [[UIImageView alloc]initWithFrame:CGRectMake(5 , hight/2 - icon_WH/2 , icon_WH , icon_WH )];
    icon_Img.image = [UIImage imageNamed:iconName];
    icon_Img.contentMode = UIViewContentModeScaleAspectFit;
    view.backgroundColor = Color_Back_Gray;
    [view addSubview:icon_Img];
    return  view;
}
@end
