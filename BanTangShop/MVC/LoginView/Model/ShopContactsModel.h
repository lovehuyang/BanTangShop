//
//  ShopContactsModel.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/26.
//  Copyright © 2017年 HLY. All rights reserved.
// 店铺联系人信息

#import <Foundation/Foundation.h>

@interface ShopContactsModel : NSObject
@property (nonatomic ,strong) NSString *ID;
@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *phone;
@property (nonatomic ,strong) NSString *avatar;
@property (nonatomic ,strong) NSString *qq;
@property (nonatomic ,strong) NSString *sex;
@property (nonatomic ,strong) NSString *wx;

+ (id)createModelWithDic:(NSDictionary *)di;
@end
