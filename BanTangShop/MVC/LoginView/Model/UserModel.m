//
//  UserModel.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/20.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
+ (id)createModelWithDic:(NSDictionary *)dic
{
    return [[UserModel alloc] initWithDic:dic];
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
        self.user_Id = [value stringValue];
    }
}
@end
