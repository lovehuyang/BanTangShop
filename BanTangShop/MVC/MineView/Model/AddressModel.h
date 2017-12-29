//
//  AddressModel.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/29.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
@property (nonatomic ,strong) NSString *ID;
@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *phone;
@property (nonatomic ,strong) NSString *user;
@property (nonatomic ,strong) NSString *district;
@property (nonatomic ,strong) NSString *address;
@property (nonatomic ,assign) BOOL isdefault;

+ (id)createModelWithDic:(NSDictionary *)dic;
@end
