//
//  JYAlterView.h
//  ECSDKDemo_OC
//
//  Created by Macintosh HD on 17/3/14.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnsureAlterView : UIView
/**
 *  背景view
 */
@property (nonatomic,strong) UIView *backgroundView;
/**
 *  AlertView
 */
@property (nonatomic,strong) UIView *alertview;
/**
 *  标题栏
 */
@property (nonatomic,strong) UILabel *titleLable;
/**
 *  内容
 */
@property (nonatomic,strong) UILabel * contentLabel;
/**
 *  标题
 */
@property (nonatomic,strong) NSString *titleStr;
/**
 *  提示内容
 */
@property (nonatomic,strong) NSString *contentStr;

/**
 *  点击背景view是不是可以消失,默认为yes,点击背景可以消失
 */
@property (nonatomic,assign) BOOL canDissmiss;


@property (nonatomic,copy) void(^clickButtonBlock)(UIButton * button);
/**
 *  存放按钮标题的数组
 */
@property (nonatomic ,strong)NSArray *btnTitleArr;


- (void)initWithTitle:(NSString *)title andContent:(NSString *)contentStr andBtnTitleArr :(NSArray *)btnTitleArr andCanDismiss:(BOOL )canDismiss;
- (void)show;
- (void)dissmiss;
@end
