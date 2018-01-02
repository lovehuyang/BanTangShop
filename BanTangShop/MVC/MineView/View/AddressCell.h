//
//  AddressCell.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/29.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface AddressCell : UITableViewCell
@property (nonatomic ,strong) AddressModel *address;

@property (nonatomic ,strong) void(^setDefaultAddress)(AddressModel *address);
@end
