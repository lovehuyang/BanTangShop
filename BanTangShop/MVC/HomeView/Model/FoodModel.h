//
//  FoodModel.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/18.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodModel : NSObject
@property (nonatomic ,strong) NSString *ID;
@property (nonatomic ,strong) NSString *foodName;
@property (nonatomic ,strong) NSString *content;
@property (nonatomic ,strong) NSNumber *click_count;
@property (nonatomic ,strong) NSNumber *sell_count;
@property (nonatomic ,strong) NSString *price_New;
@property (nonatomic ,strong) NSNumber *brand;
@property (nonatomic ,strong) NSNumber *catagory;
@property (nonatomic ,strong) NSNumber *flavor;
@property (nonatomic ,assign) BOOL is_recommend;
@property (nonatomic ,strong) NSNumber *stars;
@property (nonatomic ,strong) NSString *avatar;
@property (nonatomic ,strong) NSString *date_publish;
@property (nonatomic ,strong) NSString *weight;
@property (nonatomic ,strong) NSNumber *buyMaxNum;
@property (nonatomic ,strong) NSNumber *buyMinNum;
@property (nonatomic ,strong) NSNumber *unit;
@property (nonatomic ,strong) NSString *oldPrice;
@property (nonatomic ,strong) NSNumber *actBuyMinNum;
@property (nonatomic ,strong) NSString *actPercent;
@property (nonatomic ,strong) NSString *actEndDate;
@property (nonatomic ,assign) BOOL actForever;
@property (nonatomic ,strong) NSNumber *leftNum;
@property (nonatomic ,strong) NSNumber *leftNumSell;
@property (nonatomic ,strong) NSString *actReduce;
@property (nonatomic ,assign) BOOL deliver;
@property (nonatomic ,strong) NSNumber *deliverMinNum;
@property (nonatomic ,strong) NSNumber *packages;
@property (nonatomic ,strong) NSNumber *zan_count;
@property (nonatomic ,strong) NSString *deliverPrice;
@property (nonatomic ,strong) NSNumber *deliverCompany;
@property (nonatomic ,assign) BOOL is_close;

// 拓展字段
@property (nonatomic ,strong) NSString *expandStr;
+ (id)createModelWithDic:(NSDictionary *)dic;
@end
