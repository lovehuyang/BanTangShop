//
//  ShoppingCarModel.m
//  BanTangShop
//
//  Created by tzsoft on 2018/1/19.
//  Copyright © 2018年 HLY. All rights reserved.
//

#import "ShoppingCarModel.h"

@implementation ShoppingCarModel
+ (id)createModelWithDic:(NSDictionary *)dic
{
    return [[ShoppingCarModel alloc] initWithDic:dic];
}

- (id)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if([key isEqualToString:@"id"])
    {
        self.ID = value;
    }else if ([key isEqualToString:@"newPrice"]){
        self.price_New = value;
    }else if ([key isEqualToString:@"food"]){
        self.food = [FoodModel createModelWithDic:(NSDictionary *)value];
    }
}
@end
