//
//  RecommendViewController.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/15.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSInteger,PageType ){
    PageType_Main,// 主界面的购物车页面
    PageType_Other,// 其他页面的购物车页面
};

@interface RecommendViewController : RootViewController

@property (nonatomic ,assign)PageType pageType;
@end
