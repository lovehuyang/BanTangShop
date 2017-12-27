//
//  FoodDetailCountDownCell.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/25.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "FoodDetailCountDownCell.h"
#import "NSDate+HLY.h"

@implementation FoodDetailCountDownCell
{
    NSTimer *_timer;
    UIView *backView;
    UILabel *dayLabel;
    UILabel *hourLabel;
    UILabel *minuteLabel;
    UILabel *secondLabel;
    NSString *_title;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        _title = title;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopCountDown) name:NOTIFICATION_STOP_COUNT_DOWN object:nil];
    }
    return self;
}

- (void)setupAllSubViews:(NSString *)title{
    
    BOOL actBool = _food.actForever;
    BOOL showCountDown = YES;// 是不是显示倒计时
    if (!actBool) {
        
        _food.actEndDate =[NSDate getTimeStr:_food.actEndDate];
        DLog(@"活动截止日期：%@",_food.actEndDate);
        NSDate *endDate = [NSDate getDateFormatter:_food.actEndDate];
        DLog(@"endTime:%@",endDate);
        
        NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate])];
        NSDate *startDate = [NSDate date];
        NSString* dateString = [NSDate getDateString:startDate];
        DLog(@"现在的时间 === %@",dateString);
        
        // 比较两个时间
        NSInteger aa = [NSDate compareDate:_food.actEndDate withDate:dateString];
        if (aa == 1 || aa == 0) {// 如果活动结束时间和当前时间一样活小于当前时间，则不显示倒计时
            showCountDown = NO;
            
        }else{
            showCountDown = YES;
            [self countDownEndDate:endDate_tomorrow startDate:startDate];
        }
        
    }
    
    UILabel *titleLab = [UILabel new];
    titleLab.textColor =Color_Theme;
    titleLab.backgroundColor = Color_Back_Gray;
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.text = [NSString stringWithFormat:@"  %@",title];
    [self.contentView addSubview:titleLab];
    titleLab.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(_food.actForever?0:(showCountDown ? 30:0));
    
    backView = [UIView new];
    [self.contentView addSubview:backView];
    backView.sd_layout
    .topSpaceToView(titleLab, 0)
    .widthIs(200)
    .heightIs(_food.actForever?0 *ScaleX :(showCountDown ? 40 *ScaleX : 0))
    .centerXEqualToView(self.contentView);
    backView.backgroundColor = [UIColor whiteColor];
    
    // 天
    dayLabel = [UILabel new];
    [backView addSubview:dayLabel];
    dayLabel.sd_layout
    .leftSpaceToView(backView, 10)
    .centerYEqualToView(backView)
    .heightIs(25)
    .autoWidthRatio(0);
    dayLabel.sd_cornerRadius = @(3);
    [dayLabel setSingleLineAutoResizeWithMaxWidth:40];
    dayLabel.backgroundColor = Color_Theme;
    dayLabel.textColor = [UIColor whiteColor];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *dayLab = [UILabel new];
    [backView addSubview:dayLab];
    dayLab.text = @"天";
    dayLab.sd_layout
    .leftSpaceToView(dayLabel, 0)
    .centerYEqualToView(backView)
    .autoWidthRatio(0)
    .heightRatioToView(backView, 1);
    [dayLab setSingleLineAutoResizeWithMaxWidth:30];
    dayLab.textColor = [UIColor blackColor];
    
    //时
    hourLabel = [UILabel new];
    [backView addSubview:hourLabel];
    hourLabel.sd_layout
    .leftSpaceToView(dayLab, 5)
    .centerYEqualToView(backView)
    .heightIs(25)
    .autoWidthRatio(0);
    hourLabel.sd_cornerRadius = @(3);
    [hourLabel setSingleLineAutoResizeWithMaxWidth:40];
    hourLabel.backgroundColor = Color_Theme;
    hourLabel.textColor = [UIColor whiteColor];
    hourLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *hourLab = [UILabel new];
    [backView addSubview:hourLab];
    hourLab.text = @"时";
    hourLab.sd_layout
    .leftSpaceToView(hourLabel, 5)
    .centerYEqualToView(backView)
    .autoWidthRatio(0)
    .heightRatioToView(backView, 1);
    [hourLab setSingleLineAutoResizeWithMaxWidth:30];
    hourLab.textColor = [UIColor blackColor];
    
    //分
    minuteLabel = [UILabel new];
    [backView addSubview:minuteLabel];
    minuteLabel.sd_layout
    .leftSpaceToView(hourLab, 5)
    .centerYEqualToView(backView)
    .heightIs(25)
    .autoWidthRatio(0);
    minuteLabel.sd_cornerRadius = @(3);
    [minuteLabel setSingleLineAutoResizeWithMaxWidth:40];
    minuteLabel.backgroundColor = Color_Theme;
    minuteLabel.textColor = [UIColor whiteColor];
    minuteLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *minuteLab = [UILabel new];
    [backView addSubview:minuteLab];
    minuteLab.text = @"分";
    minuteLab.sd_layout
    .leftSpaceToView(minuteLabel, 5)
    .centerYEqualToView(backView)
    .autoWidthRatio(0)
    .heightRatioToView(backView, 1);
    [minuteLab setSingleLineAutoResizeWithMaxWidth:30];
    minuteLab.textColor = [UIColor blackColor];
    
    //秒
    secondLabel = [UILabel new];
    [backView addSubview:secondLabel];
    secondLabel.sd_layout
    .leftSpaceToView(minuteLab, 5)
    .centerYEqualToView(backView)
    .heightIs(25)
    .autoWidthRatio(0);
    secondLabel.sd_cornerRadius = @(3);
    [secondLabel setSingleLineAutoResizeWithMaxWidth:40];
    secondLabel.backgroundColor = Color_Theme;
    secondLabel.textColor = [UIColor whiteColor];
    secondLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *secondLab = [UILabel new];
    [backView addSubview:secondLab];
    secondLab.text = @"秒";
    secondLab.sd_layout
    .leftSpaceToView(secondLabel, 5)
    .centerYEqualToView(backView)
    .autoWidthRatio(0)
    .heightRatioToView(backView, 1);
    [secondLab setSingleLineAutoResizeWithMaxWidth:30];
    secondLab.textAlignment = NSTextAlignmentCenter;
    secondLab.textColor = [UIColor blackColor];
}
- (void)countDownEndDate:(NSDate *)endDate startDate:(NSDate *)startDate{
    NSTimeInterval timeInterval =[endDate timeIntervalSinceDate:startDate];
    
    if (_timer==nil) {
        __block int timeout = timeInterval; //倒计时时间
        DLog(@"开启计时器");
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        dayLabel.text = @"00";
                        hourLabel.text = @"00";
                        minuteLabel.text = @"00";
                        secondLabel.text = @"00";
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    if (days==0) {
                        dayLabel.text = @"";
                        
                    }
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days==0) {
                            dayLabel.text = @"0天";
                        }else{
                            dayLabel.text = [NSString stringWithFormat:@"%d ",days];
                        }
                        if (hours<10) {
                            hourLabel.text = [NSString stringWithFormat:@"0%d ",hours];
                        }else{
                            hourLabel.text = [NSString stringWithFormat:@"%d ",hours];
                        }
                        if (minute<10) {
                            minuteLabel.text = [NSString stringWithFormat:@"0%d ",minute];
                        }else{
                            minuteLabel.text = [NSString stringWithFormat:@"%d ",minute];
                        }
                        if (second<10) {
                            secondLabel.text = [NSString stringWithFormat:@"0%d ",second];
                        }else{
                            secondLabel.text = [NSString stringWithFormat:@"%d ",second];
                        }
                        
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}

    
- (void)setFood:(FoodModel *)food{
    _food = food;
    [self setupAllSubViews:_title];
    [self setupAutoHeightWithBottomView:backView bottomMargin:0];
}
- (void)stopCountDown{
    _timer=nil;// 销毁计时器
    DLog(@"销毁计时器");
}

@end
