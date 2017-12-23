//
//  HeadViewCell1.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/23.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadViewCell1 : UIView
- (instancetype)initWithFrame:(CGRect)frame modle:(FoodModel *)food;

// 设为收藏、取消收藏
@property (nonatomic ,strong) void(^setEnjoyBtnStatus)(BOOL select);

/**
 设置收藏按钮的状态

 @param select yes选中
 */
- (void)setEnjoyBtnSelectdd:(BOOL)select;
@end
