//
//  RecommendViewController.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/15.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "RecommendViewController.h"
#import "CenterViewController.h"

@interface RecommendViewController ()

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
