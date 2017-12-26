//
//  EventExplainCell.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/25.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "EventExplainCell.h"

@implementation EventExplainCell
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
   
        if (!_food.actForever) {
            NSMutableString *tempEndtime = (NSMutableString *)_food.actEndDate;
            _food.actEndDate =[tempEndtime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            _food.actEndDate = [[_food.actEndDate componentsSeparatedByString:@"+"] firstObject];
            actContentStr = [NSString stringWithFormat:@"您只需要购买%@包（包含%@包）即可享受%@折的优惠活动！活动持续至%@",_food.actBuyMinNum,_food.actBuyMinNum,_food.actPercent,_food.actEndDate];
        }else{
            actContentStr = [NSString stringWithFormat:@"您只需要购买%@包（包含%@包）即可享受%@折的优惠活动！活动永久有效",_food.actBuyMinNum,_food.actBuyMinNum,_food.actPercent];
        }
    
    
    
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
