//
//  FoodFootView.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/27.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FoodFootView : UIView
@property (nonatomic ,strong)FoodModel *food;

@property (nonatomic ,copy)void (^addtoShoppingCarClick)(UIButton *btn,NSString *buyCount,NSString *total_price,NSString *act_info);
@end
