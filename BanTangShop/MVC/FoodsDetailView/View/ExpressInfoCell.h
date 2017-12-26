//
//  ExpressInfoCell.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/26.
//  Copyright © 2017年 HLY. All rights reserved.
//  快递信息

#import <UIKit/UIKit.h>

@interface ExpressInfoCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title;
@property (nonatomic ,strong) FoodModel *food;
@end
