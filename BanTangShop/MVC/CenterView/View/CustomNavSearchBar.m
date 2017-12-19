//
//  CustomNavSearchBar.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/19.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "CustomNavSearchBar.h"

@implementation CustomNavSearchBar

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder{
    if (self =[super initWithFrame:frame ]) {
    
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        self.placeholder = placeholder;
        self.font = [UIFont systemFontOfSize:13];
        self.textAlignment = NSTextAlignmentLeft;
        self.tintColor= [UIColor grayColor];
        self.leftView = [self addLefttViewWithImgName:@"search_icon" withSuperViewHight:self.frame.size.height];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void) textFieldDidChange{
    self.searchBarText(self.text);
}

-(UIView *)addLefttViewWithImgName:(NSString *)iconName withSuperViewHight:(CGFloat )hight{
    
    CGFloat icon_WH =  15 ;// 图标的尺寸
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, icon_WH +10, hight)];
    UIImageView *icon_Img = [[UIImageView alloc]initWithFrame:CGRectMake(5 , hight/2 - icon_WH/2 , icon_WH , icon_WH )];
    icon_Img.image = [UIImage imageNamed:iconName];
    icon_Img.backgroundColor = [UIColor whiteColor];
    [view addSubview:icon_Img];
    return  view;
}
@end
