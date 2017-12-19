//
//  Model.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/19.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property (nonatomic ,strong)NSString *ID;
@property (nonatomic ,strong)NSString *name;

+ (id)createModelWithDic:(NSDictionary *)dic;
@end
