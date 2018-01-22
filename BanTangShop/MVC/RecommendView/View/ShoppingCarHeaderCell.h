//
//  ShoppingCarHeaderCell.h
//  BanTangShop
//
//  Created by tzsoft on 2018/1/22.
//  Copyright © 2018年 HLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCarModel.h"
@interface ShoppingCarHeaderCell : UITableViewCell
@property (nonatomic ,copy) ShoppingCarModel *model;
@property (nonatomic ,copy) NSArray *dataArr;
@property (nonatomic ,copy)void(^tableViewHeaderBtnClick)(ShoppingCarModel *shoppingCarModel,UIButton *btn);
@end
