//
//  CommentModel.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/27.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
+ (id)createModelWithDic:(NSDictionary *)dic
{
    return [[CommentModel alloc] initWithDic:dic];
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
    
    if([key isEqualToString:@"user"]){
        self.userModel = [UserModel createModelWithDic:value];
    }
}
@end
