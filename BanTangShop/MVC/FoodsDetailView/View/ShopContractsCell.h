//
//  ShopContractsCell.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/26.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopContactsModel.h"

@interface ShopContractsCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title;
@property (nonatomic ,strong)ShopContactsModel *model;

// 打电话
@property (nonatomic, strong) void(^makePhoneCalls)(NSString *phoneNum);
@end
