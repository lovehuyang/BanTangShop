//
//  CustomNavSearchBar.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/19.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavSearchBar : UITextField
- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder;

@property (nonatomic ,strong) void(^searchBarText)(NSString *searchText);
@end
