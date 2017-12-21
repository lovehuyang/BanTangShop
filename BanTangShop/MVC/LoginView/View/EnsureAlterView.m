//
//  JYAlterView.m
//  ECSDKDemo_OC
//
//  Created by Macintosh HD on 17/3/14.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "EnsureAlterView.h"
#import "UILabel+ContentSize.h"
@implementation EnsureAlterView


- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScrW, ScrH)];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.5;
        _backgroundView.userInteractionEnabled = YES;
        [self addSubview:self.backgroundView];
        
        //创建alertView
        CGFloat alertviewW = ScrW - 30 * ScaleX * 2;
        CGFloat alertviewH = 210;
        _alertview = [[UIView alloc]initWithFrame:CGRectMake(ScrW *0.5 - alertviewW *0.5, (ScrH - 44 - High_Status) *0.5 - alertviewH *0.5, alertviewW, alertviewH)];
        self.alertview.center = CGPointMake(self.center.x, self.center.y*ScaleY);
        self.alertview.layer.masksToBounds = YES;
        self.alertview.layer.cornerRadius = 5;
        self.alertview.clipsToBounds = YES;
        self.alertview.backgroundColor = BGCOLOR;
        [self addSubview:self.alertview];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    //添加标题
    _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.alertview.frame.size.width, 30)];
    _titleLable.textAlignment = NSTextAlignmentCenter;
    [_titleLable setBackgroundColor:BGCOLOR];
    _titleLable.text = self.titleStr;
    [_titleLable setFont:[UIFont systemFontOfSize:18]];
    [_titleLable setTextColor:[UIColor blackColor]];
    [self.alertview addSubview:self.titleLable];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.titleLable.frame) +10 * ScaleY, self.alertview.frame.size.width - 10 * ScaleX , 0)];
    self.contentLabel.numberOfLines = 0;
    [self.contentLabel setText:self.contentStr];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentLabel setFrame: CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, self.contentLabel.frame.size.width, [self.contentLabel contentSize].height)];
    self.contentLabel.textColor = HXYGetColor(@"#333333");
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.alertview addSubview:self.contentLabel];
    
    [self.alertview setFrame:CGRectMake(self.alertview.frame.origin.x, self.alertview.frame.origin.y, self.alertview.frame.size.width, CGRectGetMaxY(self.contentLabel.frame) + 60 * ScaleY)];
    self.alertview.center = CGPointMake(self.center.x, self.center.y);
    
    CGFloat width = CGRectGetWidth(self.alertview.frame)/self.btnTitleArr.count ;
    for (int i = 0; i <self.btnTitleArr.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (self.btnTitleArr.count == 1) {
            
            UILabel *line_H_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.alertview.frame.size.height- 40 *ScaleY-0.5, self.alertview.frame.size.width, 0.5)];
            line_H_lab.backgroundColor = HXYGetColor(@"#B8B8B8");
            [self.alertview addSubview:line_H_lab];
            
            btn.frame = CGRectMake(self.alertview.frame.size.width/2 - width/2, self.alertview.frame.size.height- 40 *ScaleY , width, 40 * ScaleY);
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.borderColor = [RGB(206,206,206) CGColor];
            [btn setTitleColor:Color_Theme forState:UIControlStateNormal];
            
        }else{
            
            UILabel *line_H_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.alertview.frame.size.height- 40 *ScaleY-0.5, self.alertview.frame.size.width, 0.5)];
            line_H_lab.backgroundColor = HXYGetColor(@"#B8B8B8");
            [self.alertview addSubview:line_H_lab];
            
            UILabel *line_V_lab = [[UILabel alloc]initWithFrame:CGRectMake(width, CGRectGetMaxY(line_H_lab.frame), 0.5, 40 *ScaleY)];
            line_V_lab.backgroundColor = HXYGetColor(@"#B8B8B8");
            [self.alertview addSubview:line_V_lab];
            
            btn.frame = CGRectMake(width *i, self.alertview.frame.size.height- 40 *ScaleY, width, 40 * ScaleY);
            if (i == 0) {
//                btn.backgroundColor = [UIColor redColor];
                [btn setTitleColor:HXYGetColor(@"#B8B8B8") forState:UIControlStateNormal];
                
            }else if (i == 1){
//                btn.backgroundColor = [UIColor greenColor];
                [btn setTitleColor:Color_Theme forState:UIControlStateNormal];
            }
        }
        
        [btn setTitle:self.btnTitleArr[i] forState:UIControlStateNormal];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.alertview addSubview:btn];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmiss)];
        [self addGestureRecognizer:tap];
    }
}

-(void)clickButton:(UIButton *)btn
{
    if (self.clickButtonBlock) {
        self.clickButtonBlock(btn);
        self.canDissmiss = YES;
        [self dissmiss];
    }
}

- (void)initWithTitle:(NSString *)title andContent:(NSString *)contentStr andBtnTitleArr :(NSArray *)btnTitleArr andCanDismiss:(BOOL )canDismiss{
    self.canDissmiss = canDismiss;
    self.titleStr = title;
    self.btnTitleArr = [NSArray arrayWithArray:btnTitleArr];
    self.contentStr = [NSString stringWithString:contentStr];
}
- (void)show {
    [[AppDelegate shareInstance].window addSubview:self];
    self.alertview.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
    
    [UIView animateWithDuration:.5f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alertview.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
    } completion:nil];
}

- (void)dissmiss {
    
    if (self.canDissmiss) {
        
        [UIView animateWithDuration:.3 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            _backgroundView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}
@end
