//
//  ShopContactsModel.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/26.
//  Copyright © 2017年 HLY. All rights reserved.
//  

#import "ShopContactsModel.h"

@implementation ShopContactsModel
+ (id)createModelWithDic:(NSDictionary *)dic
{
    return [[ShopContactsModel alloc] initWithDic:dic];
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
        self.ID = [value stringValue];
    }
}
@end
