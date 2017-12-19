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


/**
表名
 */
typedef NS_ENUM(NSInteger , TableName) {
    Table_FoodFlavour_ENUM,//食品口味表
    Table_FoodCatagory_ENUM,// 食品类别表
};

@interface InfoDBAccess : NSObject

+(InfoDBAccess*)sharedInstance;
- (void)openDatabaseWithAppName:(NSString*)appName;

/**
 *  更新表信息
 */
- (void)databaseUpdateTable:(TableName)table model:(Model *)model;
/**
 根据 Id 获取表信息
 
 @param Id Id
 @return 信息模型
 */
- (Model *)getInfoFromTable:(TableName)table andId:(NSString *)Id;
@end
