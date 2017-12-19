//
//  MenuButton.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/19.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "MenuButton.h"
#define IMAGEW 12
#define IMAGEH 10

@implementation MenuButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor:Color_Text_Gray forState:UIControlStateNormal];
        [self setTitleColor:Color_Theme forState:UIControlStateSelected];
        [self setImage:[UIImage imageNamed:@"up_gray"] forState:UIControlStateNormal];
         [self setImage:[UIImage imageNamed:@"up_orange"] forState:UIControlStateSelected];
    }
    return self;
}

//重写方法
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat imageY = self.frame.size.height/2 - IMAGEW/2;
    CGFloat imageW = IMAGEW;
    CGFloat imageH = IMAGEH;
    CGFloat imageX = contentRect.size.width - imageW;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGFloat titleY = 0;
    CGFloat titleW = contentRect.size.width - IMAGEW;
    CGFloat titleH = contentRect.size.height;
    CGFloat titleX = 0;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end
