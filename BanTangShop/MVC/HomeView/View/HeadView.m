//
//  HeadView.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/18.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "HeadView.h"
#import "MoreButton.h"

@implementation HeadView
{
    NSString *_title;
}
- (id)initWithFrame:(CGRect)frame title:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        
        _title = title;
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews{
    UILabel *titleLab = [UILabel new];
    titleLab.frame = CGRectMake(Margin_X, 0, 200, self.frame.size.height);
    [self addSubview:titleLab];
    titleLab.text = _title;
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [UIFont boldSystemFontOfSize:14];
    titleLab.textColor = Color_Theme;
    
    MoreButton *moreBtn = [MoreButton moreButton];
    moreBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - Margin_X - 40, 0, 45, CGRectGetHeight(self.frame));
    [moreBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreBtn];
}
- (void)btnClick{
    self.moreBtnClick(_title);
}
@end
