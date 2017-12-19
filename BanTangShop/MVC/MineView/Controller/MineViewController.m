//
//  MineViewController.m
//  GitHudStudy
//
//  Created by tzsoft on 2017/12/7.
//  Copyright © 2017年 TZSoft. All rights reserved.
//

#import "MineViewController.h"
#import "CenterViewController.h"

@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
}

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushCenterView) name:NOTIFICATION_PUSHCENTERVIEW object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_PUSHCENTERVIEW object:nil];
}
- (void)pushCenterView{
    CenterViewController *cvc = [[CenterViewController alloc]init];
    [self.navigationController pushViewController:cvc animated:YES];
}

@end
