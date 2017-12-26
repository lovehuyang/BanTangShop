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
#define Table_FoodBRAND @"FoodBrand"// 食品品牌表
#define Table_FoodPACKAGE @"FoodPackage"// 食品包装单位表
#define Table_FoodUNIT @"FoodUnit"// 食品单位表
#define Table_USERINFO @"UserInfo"// 用户信息表
#define Table_ShopContacts @"ShopContacts"// 铺联系人信息表

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
    [self createFoodBrandTable];// 创建食品品牌表
    [self createFoodPackageTable];// 创建食品包装单位表
    [self createFoodUnitTable];// 创建食品包装单位表
    [self createUserInfoTable];// 创建用户信息表
    [self createShopContactsTable];// 创建店铺联系人信息表
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
#pragma mark - 创建食品品牌表
- (void)createFoodBrandTable{
    [self createTable:Table_FoodBRAND sql:@"CREATE table FoodBrand (Id TEXT,name TEXT)"];
}
#pragma mark - 获取食品包装单位
- (void)createFoodPackageTable{
    [self createTable:Table_FoodPACKAGE sql:@"CREATE table FoodPackage (Id TEXT,name TEXT)"];
}
#pragma mark - 获取食品单位
- (void)createFoodUnitTable{
    [self createTable:Table_FoodUNIT sql:@"CREATE table FoodUnit (Id TEXT,name TEXT)"];
}
#pragma mark - 创建用户信息表
- (void)createUserInfoTable{
    [self createTable:Table_USERINFO sql:@"CREATE table UserInfo (Id TEXT,username TEXT,password TEXT,nickname TEXT,avatar TEXT,date_joined TEXT,qq TEXT,wx TEXT,sex TEXT,realname TEXT,phone TEXT)"];
}
#pragma mark - 创建店铺联系人信息
- (void)createShopContactsTable{
    [self createTable:Table_ShopContacts sql:@"CREATE table ShopContacts (Id TEXT,name TEXT,phone TEXT,avatar TEXT,qq TEXT,sex TEXT,wx TEXT)"];
}
#pragma mark - 更新商品信息表
/**
 *  更新商品信息表
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

#pragma mark - 更新用户信息表
/**
 更新用户信息表

 @param model 用户信息模型
 */
- (void)databaseUserInfoTable:(UserModel *)model{
    // 判断数据库中是否有该条数据(存在则更新，不存在则插入)
    BOOL isExist = [self isExistInfoJudgeId:model.user_Id];
    if(isExist)
    {
        NSString *dbStr = [NSString stringWithFormat:@"update %@ set username =? ,password = ?,nickname = ?,avatar = ?,date_joined = ?,qq = ?,wx = ?,sex = ?,realname = ?,phone = ? where Id = ?",Table_USERINFO];
        [self.dataBase executeUpdate:dbStr,model.username,model.password,model.nickname,model.avatar,model.date_joined,model.qq,model.wx,model.sex,model.realname,model.phone,model.user_Id];
    }
    else
    {
        NSString *dbStr = [NSString stringWithFormat:@"INSERT INTO %@(Id, username,password,nickname,avatar,date_joined,qq,wx,sex,realname,phone) VALUES (?,?,?,?,?,?,?,?,?,?,?)",Table_USERINFO];
        [self.dataBase executeUpdate:dbStr,model.user_Id, model.username,model.password,model.nickname,model.avatar,model.date_joined,model.qq,model.wx,model.sex,model.realname,model.phone];
    }
}

#pragma mark - 更新店铺联系人信息表
/**
 更新用户信息表
 
 @param model 用户信息模型
 */
- (void)databaseShopContactsTable:(ShopContactsModel *)model{
    // 判断数据库中是否有该条数据(存在则更新，不存在则插入)
    BOOL isExist = [self isExistShopContacts:model.ID];
    if(isExist)
    {
        NSString *dbStr = [NSString stringWithFormat:@"update %@ set name =? ,phone = ?,avatar = ?,qq = ?,sex = ?,wx = ? where Id = ?",Table_ShopContacts];
        [self.dataBase executeUpdate:dbStr,model.ID , model.name , model.phone , model.avatar , model.qq , model.sex , model.wx];
    }
    else
    {
        NSString *dbStr = [NSString stringWithFormat:@"INSERT INTO %@(Id, name,phone,avatar,qq,sex,wx) VALUES (?,?,?,?,?,?,?)",Table_ShopContacts];
        [self.dataBase executeUpdate:dbStr,model.ID,model.name,model.phone,model.avatar,model.qq,model.sex,model.wx];
    }
}

#pragma mark - 判断表中是否有该条数据
/**
 判断商品信息表中是否有该条数据

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

#pragma mark - 判断用户信息表中是否有该条数据
/**
 判断用户信息表中是否有该条数据

 @param Id 用户ID
 @return yes:存在；No：不存在
 */
- (BOOL)isExistInfoJudgeId:(NSString *)Id
{
    NSString *rsStr = [NSString stringWithFormat:@"SELECT Id FROM %@",Table_USERINFO];
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

#pragma mark - 判断店铺联系人信息表中是否有该条数据
/**
 判断店铺联系人信息表中是否有该条数据
 
 @param Id 用户ID
 @return yes:存在；No：不存在
 */
- (BOOL)isExistShopContacts:(NSString *)Id
{
    NSString *rsStr = [NSString stringWithFormat:@"SELECT Id FROM %@",Table_ShopContacts];
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
 根据 Id 获取商品表信息
 
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

/**
 根据 Id 获取用户表信息

 @param userId 用户Id
 @return 信息模型
 */
- (UserModel *)getInfoFromUserInfoTable:(NSString *)userId{
    NSString *rsStr = [NSString stringWithFormat:@"SELECT Id, username,password, nickname,avatar,date_joined,qq,wx,sex,realname,phone FROM %@ where Id = ?",Table_USERINFO];
    FMResultSet *rs = [self.dataBase executeQuery:rsStr,userId];
    UserModel *model = [[UserModel alloc]init];
    while ([rs next])
    {
        int columnIndex = 0;
        model.user_Id = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        model.username = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        model.password = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        model.nickname = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        model.avatar = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        model.date_joined = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        model.qq = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        model.wx = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        model.sex = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        model.realname = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        model.phone = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        
    }
    [rs close];
    return model;
}

#pragma mark - 获取表中所有数据
/**
 获取表中所有数据

 @param table table的类型
 @return 模型数组
 */
- (NSMutableArray *)loadAllInfoTable:(TableName)table{
    NSString *tableName = [self getTableName:table];
    NSString *rsStr = [NSString stringWithFormat:@"SELECT Id, name FROM %@ ",tableName];
    FMResultSet * rs = [self.dataBase executeQuery:rsStr];
    NSMutableArray * tempArr = [[NSMutableArray alloc]init];
    while ([rs next])
    {
        Model *model = [[Model alloc]init];
        model.ID = [rs stringForColumn:@"Id"];
        model.name = [rs stringForColumn:@"name"];
        [tempArr addObject:model];
    }
    [rs close];
    return tempArr;
}

#pragma mark - 获取店铺联系人信息表中所有数据
/**
 获取店铺联系人信息表中所有数据

 @return 模型数组
 */
- (NSMutableArray *)loadAllShopContacts{

    NSString *rsStr = [NSString stringWithFormat:@"SELECT Id, name ,phone , avatar , qq , sex , wx FROM %@ ",Table_ShopContacts];
    FMResultSet * rs = [self.dataBase executeQuery:rsStr];
    NSMutableArray * tempArr = [[NSMutableArray alloc]init];
    while ([rs next])
    {
        ShopContactsModel *model = [[ShopContactsModel alloc]init];
        model.ID = [rs stringForColumn:@"Id"];
        model.name = [rs stringForColumn:@"name"];
        model.phone = [rs stringForColumn:@"phone"];
        model.avatar = [rs stringForColumn:@"avatar"];
        model.qq = [rs stringForColumn:@"qq"];
        model.sex = [rs stringForColumn:@"sex"];
        model.wx = [rs stringForColumn:@"wx"];
        [tempArr addObject:model];
    }
    [rs close];
    return tempArr;
}
#pragma mark - 获取表名
- (NSString *)getTableName:(TableName)table{
    
    NSString *tableName = @"";
    switch (table) {
        case Table_FoodBrand_ENUM:
            tableName = Table_FoodBRAND;
            break;
        case Table_FoodCatagory_ENUM:
            tableName = Table_FoodCatagory;
            break;
        case Table_FoodFlavour_ENUM:
            tableName = Table_FoodFlavour;
            break;
        case Table_FoodPackage_ENUM:
            tableName = Table_FoodPACKAGE;
            break;
        case Table_FoodUnit_ENUM:
            tableName = Table_FoodUNIT;
            break;
        
        default:
            break;
    }
    return tableName;
}
@end
