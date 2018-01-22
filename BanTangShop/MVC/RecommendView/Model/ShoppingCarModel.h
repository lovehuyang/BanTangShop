//
//  ShoppingCarModel.h
//  BanTangShop
//
//  Created by tzsoft on 2018/1/19.
//  Copyright © 2018年 HLY. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ShoppingCarModel : NSObject
@property (nonatomic ,copy)NSNumber *ID;
@property (nonatomic ,copy)NSString *foodName;
@property (nonatomic ,copy)NSString *weight;
@property (nonatomic ,copy)NSString *flavor;
@property (nonatomic ,copy)NSString *unit;
@property (nonatomic ,copy)NSString *brand;
@property (nonatomic ,copy)NSString *packages;
@property (nonatomic ,copy)NSString *price_New;
@property (nonatomic ,copy)NSString *delivery_info;
@property (nonatomic ,copy)NSString *act_info;
@property (nonatomic ,copy)NSString *buy_num;
@property (nonatomic ,copy)NSString *total_price;
@property (nonatomic ,copy)NSString *date_publish;
@property (nonatomic ,copy)FoodModel *food;
@property (nonatomic ,copy)NSNumber *user;
@property (nonatomic ,assign)BOOL isSelected;// 是不是选中

+ (id)createModelWithDic:(NSDictionary *)dic;

@end
