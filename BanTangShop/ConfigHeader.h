//
//  ConfigHeader.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/16.
//  Copyright © 2017年 HLY. All rights reserved.
//

#ifndef ConfigHeader_h
#define ConfigHeader_h

#define URL_BASEIP @"http://101.132.191.36/shop/"


// 主题色
#define Color_Theme HXYGetColor(@"#BD0220")//

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

#endif /* ConfigHeader_h */
