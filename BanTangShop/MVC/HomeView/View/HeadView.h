//
//  HeadView.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/18.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadView : UIView
- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

@property (nonatomic ,strong) void(^moreBtnClick)(NSString *title);

@end
