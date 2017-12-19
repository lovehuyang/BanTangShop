//
//  ConfigHeader.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/16.
//  Copyright © 2017年 HLY. All rights reserved.
//

#ifndef ConfigHeader_h
#define ConfigHeader_h

#define URL_BASEIP @"http://101.132.191.36"
#define URL_GETBANNERS @"/shop/getbanners"//获取banner轮播图
#define URL_GETFOODCATAGORY @"/shop/getFoodCatagory"// 获取食品类别
#define URL_GETFOODFLAVOUR @"/shop/getFoodFlavour"// 获取食品口味
#define URL_GETRECOMMENDS @"/shop/getrecommends"//获取推荐食品
#define URL_GETSELLTOPFOODSUMMARY @"/shop/getSellTopFoodSummary"//获取销售排行食品列表
#define URL_GETFOODDETAILBYID @"/shop/getFoodDetailById"//获取食品详情(通过ID)
// 主题色
#define Color_Theme HXYGetColor(@"#BD0220")//
// 背景灰色
#define Color_Back_Gray HXYGetColor(@"#EAEAEA")

/*
 <color name="button_red">#bd0020</color>
 <color name="button_red_h">#950e25</color>
 */

// 状态栏高度
#define High_Status [GlobalTools getStatusHight]
// 状态栏 + 导航栏 高度
#define High_NavAndStatus [GlobalTools getStatusAndNavHight]
// 1.水平方向上的比例
#define ScaleX [AppDelegate shareInstance].autoSizeScaleX
// 2.垂直方向上的比例
#define ScaleY [AppDelegate shareInstance].autoSizeScaleY
// 控件间距
#define Margin_X 20

#endif /* ConfigHeader_h */
