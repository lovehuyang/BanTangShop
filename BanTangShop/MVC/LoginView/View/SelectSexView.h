//
//  SelectSexView.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/21.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <UIKit/UIKit.h>
// 性别
typedef NS_ENUM(NSInteger , Sex) {
    Sex_Boy,
    Sex_Girl,
};

@interface SelectSexView : UIView
@property (nonatomic ,strong)UIButton *girlBtn;
@property (nonatomic ,strong)UIButton *boyBtn;

@property (nonatomic, strong)void(^selectSex)(Sex sex);
@end
