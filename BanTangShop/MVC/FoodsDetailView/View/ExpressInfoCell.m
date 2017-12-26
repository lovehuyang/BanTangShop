//
//  ExpressInfoCell.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/26.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "ExpressInfoCell.h"

@implementation ExpressInfoCell
{
    UILabel *_contentLab;
    NSString *_title;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _title = title;
    }
    return self;
}

- (void)setupAllSubViews:(NSString *)title {
    UILabel *titleLab = [UILabel new];
    titleLab.textColor =Color_Theme;
    titleLab.backgroundColor = Color_Back_Gray;
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.text = [NSString stringWithFormat:@"  %@",title];
    [self.contentView addSubview:titleLab];
    titleLab.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(30);
    
    NSString *actContentStr = @"";
    
    actContentStr = [NSString stringWithFormat:@"购买%@包（含%@包）即可享受包邮活动",_food.deliverMinNum==nil?@"0":_food.deliverMinNum,_food.deliverMinNum==nil?@"0":_food.deliverMinNum];
    
    
    _contentLab = [UILabel new];
    _contentLab.text = actContentStr;
    [self.contentView addSubview:_contentLab];
    _contentLab.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(titleLab, 5)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    _contentLab.font = [UIFont systemFontOfSize:14];
    [self setupAutoHeightWithBottomView:_contentLab bottomMargin:10];
}

- (void)setFood:(FoodModel *)food{
    _food = food;
    [self setupAllSubViews:_title];
    
}
@end
