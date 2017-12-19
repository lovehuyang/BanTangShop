//
//  InfoDBAccess.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/19.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "InfoDBAccess.h"
#import <CommonCrypto/CommonDigest.h>

#define Table_FoodFlavour @"FoodFlavour"// 食品口味表
#define Table_FoodCatagory @"FoodCatagory"// 食品类别表

@interface InfoDBAccess()
@property (nonatomic, strong) FMDatabase *dataBase;
@end

@implementation InfoDBAccess
+(InfoDBAccess*)sharedInstance{
    static InfoDBAccess* imdbmanager;
    static dispatch_once_t imdbmanageronce;
    dispatch_once(&imdbmanageronce, ^{
        imdbmanager = [[InfoDBAccess alloc] init];
    });
    return imdbmanager;
}

- (void)openDatabaseWithAppName:(NSString*)appName{
    
    if (appName.length==0) {
        return;
    }
    
    //Documents:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    //username md5
    const char *cStr = [appName UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSString* MD5 =  [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
    
    //数据库文件夹
    NSString * documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:MD5];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:documentsDirectory isDirectory:&isDir];
    if(!(isDirExist && isDir)) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir) {
            //            YZLog(@"Create Database Directory Failed.");
        }
    }
    
    DLog(@"本地数据库地址documentsDirectory:=============%@", documentsDirectory);
    
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"ChiQuBa.db"];
    if (self.dataBase) {
        [self.dataBase close];
        self.dataBase = nil;
    }
    
    self.dataBase = [FMDatabase databaseWithPath:dbPath];
    [self.dataBase open];
    
    [self createFoodFlavourTable];// 创建食品口味表
    [self createFoodCatagoryTable];// 创建食品类别表
}

#pragma mark - 创建表
- (void) createTable:(NSString*)tableName sql:(NSString *)createSql {
    
    BOOL isExist = [self.dataBase tableExists:tableName];
    if (!isExist) {
        [self.dataBase executeUpdate:createSql];
    }
}
#pragma mark - 创建食品口味表
- (void)createFoodFlavourTable
{
    [self createTable:Table_FoodFlavour sql:@"CREATE table FoodFlavour (Id TEXT,name TEXT)"];
}
#pragma mark - 创建食品类别表
- (void)createFoodCatagoryTable
{
    [self createTable:Table_FoodCatagory sql:@"CREATE table FoodCatagory (Id TEXT,name TEXT)"];
}

#pragma mark - 更新表信息
/**
 *  更新表信息
 */
- (void)databaseUpdateTable:(TableName)table model:(Model *)model{
    // 判断数据库中是否有该条数据(存在则更新，不存在则插入)
    BOOL isExist = [self isExistInfoJudgeId:model.ID tableName:table];
    NSString *tableName = [self getTableName:table];
    if(isExist)
    {
        NSString *dbStr = [NSString stringWithFormat:@"update %@ set name =? where Id = ?",tableName];
        [self.dataBase executeUpdate:dbStr,model.name,model.ID];
    }
    else
    {
        NSString *dbStr = [NSString stringWithFormat:@"INSERT INTO %@(Id, name) VALUES (?,?)",tableName];
        [self.dataBase executeUpdate:dbStr,model.ID, model.name];
    }
}


#pragma mark - 判断表中是否有该条数据
/**
 判断表中是否有该条数据

 @param Id Id
 @param table 表名
 @return yes:存在；No：不存在
 */
- (BOOL)isExistInfoJudgeId:(NSString *)Id tableName:(TableName)table
{
    NSString *tableName = [self getTableName:table];
    NSString *rsStr = [NSString stringWithFormat:@"SELECT Id FROM %@",tableName];
    FMResultSet *rs = [self.dataBase executeQuery:rsStr];
    BOOL isExist = NO;
    while ([rs next])
    {
        NSString *IdDB = [rs stringForColumnIndex:0];
        if([IdDB isEqualToString:Id])
        {
            isExist = YES;
            return isExist ;
        }
    }
    [rs close];
    return isExist;
}

#pragma mark - 根据 Id 获取表信息
/**
 根据 Id 获取表信息
 
 @param Id Id
 @return 信息模型
 */
- (Model *)getInfoFromTable:(TableName)table andId:(NSString *)Id{
    NSString *tableName = [self getTableName:table];
    NSString *rsStr = [NSString stringWithFormat:@"SELECT Id, name FROM %@ where Id = ?",tableName];
    FMResultSet *rs = [self.dataBase executeQuery:rsStr,Id];
    Model *model = [[Model alloc]init];
    while ([rs next])
    {
        int columnIndex = 0;
        model.ID = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        model.name = [rs stringForColumnIndex:columnIndex]; columnIndex++;
    }
    [rs close];
    return model;
}

#pragma mark - 获取表名
- (NSString *)getTableName:(TableName)table{
    
    NSString *tableName = table == Table_FoodFlavour_ENUM?Table_FoodFlavour:Table_FoodCatagory;
    return tableName;
}
@end
