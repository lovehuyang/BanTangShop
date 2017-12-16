//
//  customTabbar.m
//  HappyDoctorDoctor
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 胡小羊. All rights reserved.
//

#import "customTabbar.h"
#import "tabbarButton.h"

@interface customTabbar()
@property (nonatomic, strong) NSMutableArray *tabBarButtons;
@property (nonatomic, weak) tabbarButton *selectedButton;
@property (nonatomic,weak)UIButton *plusButton;
@end
@implementation customTabbar

- (NSMutableArray *)tabBarButtons
{
    if (_tabBarButtons == nil) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BGCOLOR;

        //添加一个“+”按钮
        UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_os7"] forState:UIControlStateNormal];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted_os7"] forState:UIControlStateHighlighted];
        
        [plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_os7"] forState:UIControlStateNormal];
        [plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted_os7"] forState:UIControlStateHighlighted];
        [self addSubview:plusButton];
        plusButton.bounds = CGRectMake(0, 0, plusButton.currentBackgroundImage.size.width, plusButton.currentBackgroundImage.size.height);
        self.plusButton = plusButton;
        [self.plusButton addTarget:self action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchDown];

    }
    return self;
}

-(void)plusButtonClick{
    NSLog(@"我点击了加号按钮");
    
}

/**
 *  对按钮进行赋值
 *
 *  @param item 数据模型
 */
- (void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    // 1.创建按钮
    tabbarButton *button = [[tabbarButton alloc] init];
    [self addSubview:button];
    // 添加按钮到数组中
    [self.tabBarButtons addObject:button];
    
    // 2.设置数据
    button.item = item;
    
    // 3.监听按钮点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    // 4.默认选中第0个按钮
    if (self.tabBarButtons.count == 1)
    {
        [self buttonClick:button];
    }
}

/**
 *  监听按钮点击
 */
- (void)buttonClick:(tabbarButton *)button
{
    // 1.通知代理
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:button.tag];
    }
    // 2.设置按钮的状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    //调整“+”按钮的frame
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
    self.plusButton.center = CGPointMake(w * 0.5, h * 0.5);
    
    //tabbar按钮的位置
    CGFloat buttonW = w/self.subviews.count;
    CGFloat buttonH = h;
    CGFloat buttonY = 0;
    
    for (int index = 0; index <self.tabBarButtons.count; index ++) {
        //取出按钮
        tabbarButton *button = self.tabBarButtons[index];
        
        //设置按钮的frame
        CGFloat buttonX =  index *buttonW;
        if (index >1) {
            buttonX +=buttonW;
        }
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        //绑定tag
        button.tag = index;
    }
}

@end
