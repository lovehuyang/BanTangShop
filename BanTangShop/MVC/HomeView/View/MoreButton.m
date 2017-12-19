//
//  MoreButton.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/18.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "MoreButton.h"
#define IMAGEW 10

@implementation MoreButton
+(instancetype)moreButton{
    return [[self alloc]init];
}
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor:HXYGetColor(@"#7F7F7F") forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"right_icon"] forState:UIControlStateNormal];
        [self setTitle:@"更多" forState:UIControlStateNormal];
    }
    return self;
}

//重写方法
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat imageY = self.frame.size.height/2 - IMAGEW/2;
    CGFloat imageW = IMAGEW;
    CGFloat imageH = IMAGEW;
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
