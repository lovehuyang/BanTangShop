//
//  CommentOtherCell.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/27.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "CommentOtherCell.h"
#import "NSDate+HLY.h"

@implementation CommentOtherCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
    }
    return  self;
}

- (void)setupAllSubViews{
    
    UIImageView *headImgView = [UIImageView new];
    [self.contentView addSubview:headImgView];
    headImgView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .widthIs(45 *ScaleX)
    .heightEqualToWidth();
    [headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_BASEIP,_model.userModel.avatar]] placeholderImage:[UIImage imageNamed:@"common_image_empty"]];
    
    UILabel *nameLab = [UILabel new];
    [self.contentView addSubview:nameLab];
    nameLab.sd_layout
    .topSpaceToView(headImgView, 0)
    .heightIs(25)
    .widthRatioToView(headImgView, 1.2)
    .centerXEqualToView(headImgView);
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.text = self.model.username;
    nameLab.font = [UIFont systemFontOfSize:13];
    
    UILabel *contentLab = [UILabel new];
    [self.contentView addSubview:contentLab];
    contentLab.sd_layout
    .leftSpaceToView(nameLab, 5)
    .topEqualToView(headImgView)
    .bottomEqualToView(nameLab)
    .rightSpaceToView(self.contentView, 10);
    contentLab.numberOfLines = 0;
    contentLab.font = [UIFont systemFontOfSize:14];
    contentLab.text = self.model.content;;
    
    UIView *footView = [UIView new];
    [self.contentView addSubview:footView];
    footView.sd_layout
    .rightEqualToView(self.contentView)
    .topSpaceToView(nameLab, 0)
    .leftEqualToView(self.contentView)
    .heightIs(20);
    footView.backgroundColor = Color_Back_Gray;
    
    UILabel *timeLab = [UILabel new];
    timeLab.textColor =Color_Theme;
    timeLab.font = [UIFont systemFontOfSize:13];
    timeLab.text = [NSString stringWithFormat:@"%@",[NSDate getTimeStr2:self.model.date_publish]];
    [footView addSubview:timeLab];
    timeLab.sd_layout
    .rightSpaceToView(footView, 10)
    .topEqualToView(footView)
    .leftEqualToView(footView)
    .heightIs(20);
    timeLab.textAlignment = NSTextAlignmentRight;
    [self setupAutoHeightWithBottomView:footView bottomMargin:0];
}

- (void)setModel:(CommentModel *)model{
    _model = model;
    [self setupAllSubViews];
}

@end
