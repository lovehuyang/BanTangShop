//
//  HomeTableViewCell.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/18.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodListModel.h"

@interface HomeTableViewCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic ,strong) FoodListModel *food;
@end
