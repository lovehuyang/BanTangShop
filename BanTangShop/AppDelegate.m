//
//  AppDelegate.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/15.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "AppDelegate.h"
#import "Model.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setScale];
    [self setupConfigInfo];// 初始化配置信息
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[SetupTools sharedInstance]chooseRootViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setScale{
    AppDelegate *myDelegate = [AppDelegate shareInstance]; ;
    
    if(ScrH > 480){ // 这里以(iPhone4S)为准
        myDelegate.autoSizeScaleX = ScrW/320;
        myDelegate.autoSizeScaleY = ScrH/568;
    }else{
        myDelegate.autoSizeScaleX = 1.0;
        myDelegate.autoSizeScaleY = 1.0;
    }
}

- (void)setupConfigInfo{
    // 创建数据库
    [[InfoDBAccess sharedInstance] openDatabaseWithAppName:@"ChiQuBa"];
    // 获取食品口味信息
    [HLYNetWorkObject requestWithMethod:GET ParamDict:nil url:URL_GETFOODFLAVOUR successBlock:^(id requestData, NSDictionary *dataDict) {
        for (NSDictionary *tempDict in (NSArray *)dataDict) {
            Model *model = [Model createModelWithDic:tempDict];
            [[InfoDBAccess sharedInstance]databaseUpdateTable:Table_FoodFlavour_ENUM model:model];
        }
    } failureBlock:^(NSInteger errCode, NSString *msg) {
    }];
    // 获取食品分类信息
    [HLYNetWorkObject requestWithMethod:GET ParamDict:nil url:URL_GETFOODCATAGORY successBlock:^(id requestData, NSDictionary *dataDict) {
        for (NSDictionary *tempDict in (NSArray *)dataDict) {
            Model *model = [Model createModelWithDic:tempDict];
            [[InfoDBAccess sharedInstance]databaseUpdateTable:Table_FoodCatagory_ENUM model:model];
        }
    } failureBlock:^(NSInteger errCode, NSString *msg) {
    }];
    // 获取食品品牌信息
    [HLYNetWorkObject requestWithMethod:GET ParamDict:nil url:URL_GETFOODBRAND successBlock:^(id requestData, NSDictionary *dataDict) {
        for (NSDictionary *tempDict in (NSArray *)dataDict) {
            Model *model = [Model createModelWithDic:tempDict];
            [[InfoDBAccess sharedInstance]databaseUpdateTable:Table_FoodBrand_ENUM model:model];
        }
    } failureBlock:^(NSInteger errCode, NSString *msg) {
    }];
}
+ (AppDelegate *)shareInstance
{
    return [[UIApplication sharedApplication] delegate];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
