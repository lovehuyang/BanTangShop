//
//  CommentModel.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/27.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
@property (nonatomic ,strong) NSString *ID;
@property (nonatomic ,strong) NSString *content;
@property (nonatomic ,strong) NSString *username;
@property (nonatomic ,strong) NSNumber *food;
@property (nonatomic ,strong) NSString *pid;
@property (nonatomic ,strong) NSString *date_publish;
@property (nonatomic ,strong) UserModel *userModel;

+ (id)createModelWithDic:(NSDictionary *)dic;
@end
