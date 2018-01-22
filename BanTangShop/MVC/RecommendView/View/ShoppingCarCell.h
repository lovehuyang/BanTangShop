//
//  ShoppingCarCell.h
//  BanTangShop
//
//  Created by tzsoft on 2018/1/19.
//  Copyright © 2018年 HLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCarModel.h"

@interface ShoppingCarCell : UITableViewCell
@property (nonatomic ,copy) ShoppingCarModel *model;

@property (nonatomic ,copy) void(^cellSelectBtncClick)(UIButton *selectBtn);
@end
