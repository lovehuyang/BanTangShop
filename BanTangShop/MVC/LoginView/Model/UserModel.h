//
//  UserModel.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/20.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nonatomic ,strong) NSString *user_Id;
@property (nonatomic ,strong) NSString *username;
@property (nonatomic ,strong) NSString *password;
@property (nonatomic ,strong) NSString *nickname;
@property (nonatomic ,strong) NSString *avatar;
@property (nonatomic ,strong) NSString *date_joined;
@property (nonatomic ,strong) NSString *qq;
@property (nonatomic ,strong) NSString *wx;
@property (nonatomic ,strong) NSString *sex;
@property (nonatomic ,strong) NSString *realname;
@property (nonatomic ,strong) NSString *phone;

+ (id)createModelWithDic:(NSDictionary *)dic;
@end
