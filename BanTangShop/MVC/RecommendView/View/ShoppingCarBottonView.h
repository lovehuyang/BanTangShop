//
//  ShoppingCarBottonView.h
//  BanTangShop
//
//  Created by tzsoft on 2018/1/22.
//  Copyright © 2018年 HLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCarBottonView : UIView
@property (nonatomic ,copy)UILabel *totalLab;
@property (nonatomic ,copy)UIButton *selectAllBtn;

@property (nonatomic ,copy) void (^selectAllBtnClick)(UIButton *selectAllBtn);
@property (nonatomic ,copy) void (^buyRightNow)();// 立即购买

@end
