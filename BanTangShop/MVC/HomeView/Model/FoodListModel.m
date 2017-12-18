//
//  FoodModel.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/18.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "FoodListModel.h"

@implementation FoodListModel
+ (id)createModelWithDic:(NSDictionary *)dic
{
    return [[FoodListModel alloc] initWithDic:dic];
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
        self.Id = value;
    }else if ([key isEqualToString:@"newPrice"]){
        self.price_New = value;
    }
}

@end
