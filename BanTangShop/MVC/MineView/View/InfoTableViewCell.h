//
//  InfoTableViewCell.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/28.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewCell : UITableViewCell
@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,strong) UserModel *model;
@end