//
//  Frame.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/21.
//  Copyright © 2017年 HLY. All rights reserved.
//

#ifndef Frame_h
#define Frame_h

// 状态栏高度
#define High_Status [GlobalTools getStatusHight]
// Tabbar的高度
#define High_TabBar ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49) //底部tabbar高度
// 状态栏 + 导航栏 高度
#define High_NavAndStatus [GlobalTools getStatusAndNavHight]
// 1.水平方向上的比例
#define ScaleX [AppDelegate shareInstance].autoSizeScaleX
// 2.垂直方向上的比例
#define ScaleY [AppDelegate shareInstance].autoSizeScaleY
// 控件间距
#define Margin_X 20

// 长按键
#define LONGBTN_HEIGHT 40
#define LONGBTN_MARGIN 35
#define LONGBTN_FONT 15
#define LONGBTN_CORNER 3

#endif /* Frame_h */
