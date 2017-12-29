//
//  InfoTableViewCell.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/28.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "InfoTableViewCell.h"
#import "NSDate+HLY.h"

@implementation InfoTableViewCell
{
    UILabel *titleLab;
    UILabel *contentLab;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupAllSubviews];
    }
    return self;
}

- (void)setupAllSubviews{
    titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    titleLab.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .centerYEqualToView(self.contentView)
    .heightIs(30);
    [titleLab setSingleLineAutoResizeWithMaxWidth:100];
    titleLab.backgroundColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:15];
    
    contentLab = [UILabel new];
    [self.contentView addSubview:contentLab];
    contentLab.sd_layout
    .leftSpaceToView(titleLab, 5)
    .centerYEqualToView(self.contentView)
    .heightIs(30)
    .rightSpaceToView(self.contentView, 0);
    contentLab.textAlignment = NSTextAlignmentRight;
    contentLab.font = [UIFont systemFontOfSize:15];
    contentLab.textColor = Color_Text_Gray;
    contentLab.backgroundColor = [UIColor whiteColor];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    titleLab.text = _title;
}
- (void)setModel:(UserModel *)model{
    _model = model;

    if ([_title isEqualToString:@"昵称"]) {
        contentLab.text = _model.nickname;
    }else if ([_title isEqualToString:@"姓名"]) {
        contentLab.text = [self setContent:_model.realname];
    }else if ([_title isEqualToString:@"性别"]) {
        contentLab.text = _model.sex ;
    }else if ([_title isEqualToString:@"注册时间"]) {
        contentLab.text = [NSDate getTimeStr2:_model.date_joined];
        contentLab.sd_layout
        .rightSpaceToView(self.contentView, 25);
    }else if ([_title isEqualToString:@"手机号"]) {
        contentLab.text = [self setContent:_model.phone] ;
    }else if ([_title isEqualToString:@"微信号"]) {
        contentLab.text = [self setContent:_model.wx];
    }else if ([_title isEqualToString:@"QQ"]) {
        contentLab.text = [self setContent:_model.qq];
    }
}

- (NSString *)setContent:(NSString *)content{
    if (content == nil || content.length == 0) {
        return [NSString stringWithFormat:@"请设置%@",_title];
    }else{
        return content;
    }
}
@end
