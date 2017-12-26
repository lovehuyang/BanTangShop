//
//  InfoDBAccess.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/19.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import "FMDB.h"
#import "UserModel.h"
#import "ShopContactsModel.h"

/**
表名
 */
typedef NS_ENUM(NSInteger , TableName) {
    Table_FoodFlavour_ENUM,//食品口味表
    Table_FoodCatagory_ENUM,// 食品类别表
    Table_FoodBrand_ENUM,// 食品品牌表
    Table_FoodPackage_ENUM,// 食品包装单位表
    Table_FoodUnit_ENUM,// 食品单位表
};

@interface InfoDBAccess : NSObject

+(InfoDBAccess*)sharedInstance;
- (void)openDatabaseWithAppName:(NSString*)appName;

/**
 *  更新商品信息表信息
 */
- (void)databaseUpdateTable:(TableName)table model:(Model *)model;
/**
 更新用户信息表
 
 @param model 用户信息模型
 */
- (void)databaseUserInfoTable:(UserModel *)model;
/**
 根据 Id 获取表信息
 
 @param Id Id
 @return 信息模型
 */
- (Model *)getInfoFromTable:(TableName)table andId:(NSString *)Id;
/**
 获取表中所有数据
 
 @param table table的类型
 @return 模型数组
 */
- (NSMutableArray *)loadAllInfoTable:(TableName)table;

/**
 根据 Id 获取用户表信息
 
 @param userId 用户Id
 @return 信息模型
 */
- (UserModel *)getInfoFromUserInfoTable:(NSString *)userId;

/**
 获取店铺联系人信息表中所有数据
 
 @return 模型数组
 */
- (NSMutableArray *)loadAllShopContacts;
/**
 更新用户信息表
 
 @param model 用户信息模型
 */
- (void)databaseShopContactsTable:(ShopContactsModel *)model;
@end
