//
//  HeadImageCell.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/28.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "HeadImageCell.h"

@implementation HeadImageCell
{
    UIImageView *headImageView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupAllSubviews];
    }
    return self;
}

- (void)setupAllSubviews{
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    titleLab.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .centerYEqualToView(self.contentView)
    .heightIs(30)
    .widthIs(50);
    titleLab.text = @"头像";
    titleLab.font = [UIFont systemFontOfSize:15];
    
    headImageView = [UIImageView new];
    [self.contentView addSubview:headImageView];
    headImageView.sd_layout
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.contentView, 5)
    .heightIs(60 *ScaleX )
    .widthEqualToHeight();
    headImageView.backgroundColor= [UIColor redColor];
    
    [self setupAutoHeightWithBottomView:headImageView bottomMargin:5];
}

- (void)setModel:(UserModel *)model{
    _model = model;
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_BASEIP,_model.avatar]] placeholderImage:[UIImage imageNamed:@"img_zhanweifu"]];
}
@end
