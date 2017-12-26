//
//  FoodInfoCell.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/26.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "FoodInfoCell.h"
#import "NSString+HLY.h"

@implementation FoodInfoCell
{
    UILabel *_contentLab;
    NSString *_title;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
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
    
    NSArray *titleArr = @[@"食品分类:",@"食品品牌:",@"食品口味:",@"食品规格:",@"包装单位:",@"每单最多购买数量:",@"每单最少购买数量:",@"物流公司:",@"配送费:"];

    NSArray *contentArr = @[[self getFoodCatagory],[self getFoodBrand],[self getFoodFlavour],[NSString stringWithFormat:@"%@%@",[NSString emptyOrNilStr:_food.weight],[self getFoodUnit]],[self getFoodPackage],[NSString emptyOrNilStr:_food.buyMaxNum],[NSString emptyOrNilStr:_food.buyMinNum],[NSString emptyOrNilStr:_food.deliverCompany],[NSString emptyOrNilStr:_food.deliverPrice]];
    for (int i =0 ; i < 9; i ++) {
        UILabel *contentLab = [UILabel new];
        [self.contentView addSubview:contentLab];
        contentLab.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 10)
        .topSpaceToView(titleLab, 30 *ScaleX * i)
        .heightIs(30 *ScaleX);
        contentLab.font = [UIFont systemFontOfSize:14];
        contentLab.text = [NSString stringWithFormat:@"%@%@",titleArr[i],contentArr[i]];
        if(i == 8){
            _contentLab = contentLab;
        }
        
    }
    
    [self setupAutoHeightWithBottomView:_contentLab bottomMargin:10];
}

- (void)setFood:(FoodModel *)food{
    _food = food;
    [self setupAllSubViews:_title];
    
}

// 获取食品分类
- (NSString *)getFoodCatagory{
    Model *model = [[InfoDBAccess sharedInstance]getInfoFromTable:Table_FoodCatagory_ENUM andId:[_food.catagory stringValue]];
    
    return [NSString emptyOrNilStr:model.name];
}
// 获取食品品牌
- (NSString *)getFoodBrand{
    Model *model = [[InfoDBAccess sharedInstance]getInfoFromTable:Table_FoodBrand_ENUM andId:[_food.brand stringValue]];
    return [NSString emptyOrNilStr:model.name];;
}
// 获取食品口味
- (NSString *)getFoodFlavour{
    Model *model = [[InfoDBAccess sharedInstance]getInfoFromTable:Table_FoodFlavour_ENUM andId:[_food.flavor stringValue]];
    return  [NSString emptyOrNilStr:model.name];
}
// 获取食品包装单位
- (NSString *)getFoodPackage{
    Model *model = [[InfoDBAccess sharedInstance]getInfoFromTable:Table_FoodPackage_ENUM andId:[_food.packages stringValue]];
    return [NSString emptyOrNilStr:model.name];
}
// 获取食品单位
- (NSString *)getFoodUnit{
    Model *model = [[InfoDBAccess sharedInstance]getInfoFromTable:Table_FoodUnit_ENUM andId:[_food.unit stringValue]];
    return  [NSString emptyOrNilStr:model.name];
}

@end
