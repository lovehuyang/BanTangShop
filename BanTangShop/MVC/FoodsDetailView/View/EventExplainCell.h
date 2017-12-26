//
//  EventExplainCell.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/25.
//  Copyright © 2017年 HLY. All rights reserved.
//  活动说明

#import <UIKit/UIKit.h>

@interface EventExplainCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title;
@property (nonatomic ,strong) FoodModel *food;
@end
