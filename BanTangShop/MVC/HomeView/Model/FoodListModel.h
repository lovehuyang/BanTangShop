//
//  FoodModel.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/18.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodListModel : NSObject
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
@property (nonatomic ,strong) NSString *zan_count;

+ (id)createModelWithDic:(NSDictionary *)dic;
@end
