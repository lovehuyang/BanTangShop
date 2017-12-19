//
//  TopMenuView.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/19.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuButton.h"

@interface TopMenuView : UIView
- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic ,strong)MenuButton *menuBtn;

@end
