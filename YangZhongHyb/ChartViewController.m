//
//  ChartViewController.m
//  huyubao
//
//  Created by mao ke on 2017/4/22.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import "ChartViewController.h"
#import "AppDelegate.h"
#import "DKProgressHUD.h"


@interface ChartViewController ()


@end

@implementation ChartViewController
@synthesize selectedDate = _selectedDate;
@synthesize actionSheetPicker = _actionSheetPicker;

- (void)viewDidLoad {
    [super viewDidLoad];
//    [DKProgressHUD showLoading];
    self.navigationItem.title = _hybName;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSInteger startTime = [[self getNowDate] integerValue];
    NSInteger endTime = startTime+86400;
    NSString *timeEnd = [NSString stringWithFormat:@"%ld", (long)endTime];
    NSString *post = [NSString stringWithFormat:@"%@%@%@%@",@"Body=select,select * from huyubao where time between ",[self getNowDate],@" and ",timeEnd];
    NSLog(@"post:%@", post);
//    [self postToData:post postToDate:@"today"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(arrDoing:) name:@"today" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:@"today"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)controllerSecond:(id)sender {
    
}

- (IBAction)selectDate:(id)sender {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:2000];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    NSDate *maxDate = [NSDate date];
    
    
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate
                                                          minimumDate:minDate
                                                          maximumDate:maxDate
                                                               target:self action:@selector(dateWasSelected:element:) origin:sender];
    
    [self.actionSheetPicker addCustomButtonWithTitle:@"Today" value:[NSDate date]];
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
}

- (IBAction)controllerFirst:(id)sender {
    
}

- (IBAction)yesterday:(id)sender {
    NSInteger startTime = [[self getNowDate] integerValue];
    startTime = startTime-86400;
    NSString *timeStart = [NSString stringWithFormat:@"%ld", (long)startTime];
//    NSInteger endTime = [[self getNowDate] integerValue];
//    endTime = endTime-86400;
//    NSString *timeEnd = [NSString stringWithFormat:@"%ld", (long)endTime];
    NSString *post = [NSString stringWithFormat:@"%@%@%@%@",@"Body=select,select * from huyubao where time between ",timeStart,@" and ",[self getNowDate]];
    NSLog(@"昨天post:%@", post);
    [self postToData:post postToDate:@"yesterday"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(arrDoing:) name:@"yesterday" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:@"yesterday"];
}


-(void)arrDoing:(NSNotification *)noti{
    NSLog(@"一天数据");
//    NSLog(@"%@", [noti.userInfo valueForKeyPath:@"dataTemp"]);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![noti.userInfo isEqual:@""]) {
            NSString *time = [NSString stringWithFormat:@"%@",[noti.userInfo valueForKeyPath:@"time"]];
            [self timeToArr:time];
            NSString *str = [NSString stringWithFormat:@"%@",[noti.userInfo valueForKeyPath:@"dataRy"]];
            [self arrToStr:str whichType:@"ry"];
            str = [NSString stringWithFormat:@"%@",[noti.userInfo valueForKeyPath:@"dataTemp"]];
            [self arrToStr:str whichType:@"temp"];
            _valueArr = [[NSMutableArray alloc]init];
            [_valueArr addObjectsFromArray:_tempArr];
//            NSLog(@"%@", _valueArr);
            [self setUp];
            _valueArr = [[NSMutableArray alloc]init];
            [_valueArr addObjectsFromArray:_ryArr];
            [self setup2];
        }
        [DKProgressHUD dismiss];
    });
}


/**
 溶氧，温度数据转入数组

 @param str 数据
 @param type 类型
 */
-(void)arrToStr:(NSString *)str whichType:(NSString *)type{
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str substringFromIndex:1];
    str = [str substringWithRange:NSMakeRange(0, [str length] - 1)];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    if ([type isEqualToString:@"temp"]) {
        _tempArr = [str componentsSeparatedByString:@","];
        NSLog(@"temp:%@",_tempArr);
        NSLog(@"temp:%lu",(unsigned long)_tempArr.count);
    }else{
        _ryArr = [str componentsSeparatedByString:@","];
        NSLog(@"ry:%@",_ryArr);
        NSLog(@"ry:%lu",(unsigned long)_ryArr.count);
    }
}

/**
 时间转入数组

 @param str 时间数据
 */
-(void)timeToArr:(NSString *)str{
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str substringFromIndex:1];
    str = [str substringWithRange:NSMakeRange(0, [str length] - 1)];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    _timeArr = [str componentsSeparatedByString:@","];
}
/**
 获取系统时间

 @return 返回当天时间戳
 */
-(id)getNowDate{
    self.selectedDate =[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString * locationString=[dateformatter stringFromDate:self.selectedDate];
//    self.selectedDate = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
//    NSTimeInterval time = [zone secondsFromGMTForDate:self.selectedDate];// 以秒为单位返回当前时间与系统格林尼治时间的差
//    NSDate *dateNow = [self.selectedDate dateByAddingTimeInterval:time];// 然后把差的时间加上,就是当前系统准确的时间
//    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"YYYYMMdd"];
    
    NSString *date = [dateformatter stringFromDate:self.selectedDate];
    NSDate *tstart = [dateformatter dateFromString:date];
    NSLog(@"当天时间：%@", locationString);
    //起始时间戳
    NSTimeInterval interval = [tstart timeIntervalSince1970] * 1000;
    NSString *timeStart =[NSString stringWithFormat:@"%lf\n",interval];
    timeStart = [timeStart substringToIndex:10];
    NSLog(@"时间戳：%@",timeStart);
    return timeStart;
}
/**
 初始化温度折线图
 */
- (void)setUp{
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        //首次进入控制器为横屏时
        _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT * 0.5;
        
    }else{
        //首次进入控制器为竖屏时
        _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT;
    }
    self.lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, _height/2-20)];
    self.lineChart.dataSource = self;
    self.lineChart.delegate = self;
    self.lineChart.topicLabel.text = @"温度折线图";
    self.lineChart.unit = @"°C";
    self.lineChart.topicLabel.textColor = ZFBlack;
        self.lineChart.isShowXLineSeparate = YES;
    self.lineChart.isShowYLineSeparate = YES;
    //    self.lineChart.isAnimated = NO;
    self.lineChart.isResetAxisLineMinValue = YES;
    //    self.lineChart.isShowAxisLineValue = NO;
    //    self.lineChart.isShadowForValueLabel = NO;
//    self.lineChart.isShadow = NO;
    //    self.lineChart.valueLabelPattern = kPopoverLabelPatternBlank;
    //    self.lineChart.valueCenterToCircleCenterPadding = 0;
    //    self.lineChart.separateColor = ZFYellow;
    //    self.lineChart.linePatternType = kLinePatternTypeForCurve;
    self.lineChart.unitColor = ZFBlack;
//    self.lineChart.backgroundColor = ZFPurple;
    self.lineChart.xAxisColor = ZFBlack;
    self.lineChart.yAxisColor = ZFBlack;
    self.lineChart.axisLineNameColor = ZFBlack;
    self.lineChart.axisLineValueColor = ZFBlack;
    self.lineChart.xLineNameLabelToXAxisLinePadding = 0;
    [self.view addSubview:self.lineChart];
    [self.lineChart strokePath];
    
}

/**
 初始化溶解氧曲线图
 */
-(void)setup2{
    self.lineChart2 = [[ZFLineChart alloc] initWithFrame:CGRectMake(0, _height/2+40, SCREEN_WIDTH, _height/2-20)];
    self.lineChart2.dataSource = self;
    self.lineChart2.delegate = self;
    self.lineChart2.topicLabel.text = @"溶解氧曲线图";
    //    self.lineChart2.unit = @"人";
    self.lineChart2.topicLabel.textColor = ZFBlack;
    self.lineChart2.isResetAxisLineMinValue = YES;
    //    self.lineChart2.isAnimated = NO;
    //    self.lineChart2.valueLabelPattern = kPopoverLabelPatternBlank;
    self.lineChart2.isShowYLineSeparate = YES;
    self.lineChart2.isShowXLineSeparate = YES;
    //    self.lineChart2.linePatternType = kLinePatternTypeForCurve;
    //    self.lineChart.isShowAxisLineValue = NO;
    //    lineChart.valueCenterToCircleCenterPadding = 0;
    self.lineChart2.isShadow = NO;
    self.lineChart2.unitColor = ZFBlack;
    //    self.lineChart2.backgroundColor = ZFWhite;
    self.lineChart2.xAxisColor = ZFBlack;
    self.lineChart2.yAxisColor = ZFBlack;
    self.lineChart2.axisLineNameColor = ZFBlack;
    self.lineChart2.axisLineValueColor = ZFBlack;
    self.lineChart2.xLineNameLabelToXAxisLinePadding = 0;
    [self.view addSubview:self.lineChart2];
    [self.lineChart2 strokePath];
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return @[_valueArr];
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return @[_timeArr];
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[ZFSkyBlue,ZFOrange,ZFMagenta,ZFBlack,ZFLightGray,ZFRed,ZFGreen];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 50;
}

//- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart{
//    return -200;
//}

- (NSUInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 10;
}

- (void)lineChart:(ZFLineChart *)lineChart didSelectCircleAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex circle:(ZFCircle *)circle popoverLabel:(ZFPopoverLabel *)popoverLabel{
    NSLog(@"第%ld个", (long)circleIndex);
    
    //可在此处进行circle被点击后的自身部分属性设置,可修改的属性查看ZFCircle.h
    //    circle.circleColor = ZFRed;
    //    circle.isAnimated = YES;
    //    circle.opacity = 0.5;
    //    [circle strokePath];
    
    //可将isShowAxisLineValue设置为NO，然后执行下句代码进行点击才显示数值
    //    popoverLabel.hidden = NO;
}

- (void)lineChart:(ZFLineChart *)lineChart didSelectPopoverLabelAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex popoverLabel:(ZFPopoverLabel *)popoverLabel{
    NSLog(@"第%ld个" ,(long)circleIndex);
    
    //可在此处进行popoverLabel被点击后的自身部分属性设置
    //    popoverLabel.textColor = ZFGold;
    //    [popoverLabel strokePath];
}

#pragma mark - 横竖屏适配(若需要同时横屏,竖屏适配，则添加以下代码，反之不需添加)

/**
 *  PS：size为控制器self.view的size，若图表不是直接添加self.view上，则修改以下的frame值
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator NS_AVAILABLE_IOS(8_0){
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        self.lineChart.frame = CGRectMake(0, 0, size.width, size.height - NAVIGATIONBAR_HEIGHT * 0.5);
    }else{
        self.lineChart.frame = CGRectMake(0, 0, size.width, size.height + NAVIGATIONBAR_HEIGHT * 0.5);
    }
    
    [self.lineChart strokePath];
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.selectedDate = selectedDate;
    NSDateFormatter *dateformate = [[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd"];
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    [self.dataSelect setTitle:[dateformate stringFromDate:_selectedDate] forState:UIControlStateNormal];
    
    NSString *date = [dateformate stringFromDate:_selectedDate];
    NSDate *tstart = [dateformate dateFromString:date];
    NSTimeInterval interval = [tstart timeIntervalSince1970] * 1000;
    NSString *timeStart =[NSString stringWithFormat:@"%lf\n",interval];
    timeStart = [timeStart substringToIndex:10];
    NSInteger endTime = [timeStart integerValue];
    endTime = endTime+86400;
    NSString *timeEnd = [NSString stringWithFormat:@"%ld", (long)endTime];
    NSLog(@"%@,%@",timeStart,timeEnd);
    NSString *post = [NSString stringWithFormat:@"%@%@%@%@",@"Body=select,select * from huyubao where time between ",timeStart,@" and ",timeEnd];
    NSLog(@"post:%@", post);
    [self postToData:post postToDate:@"select"];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(arrDoing:) name:@"select" object:nil];
}

#pragma mark--post请求数据库
-(void)postToData:(NSString *)post postToDate:(NSString *)date{
    NSString *strURL =@"http://115.28.179.114:8885/HuYuBaoServlet/servlet/LoginServlet";
    NSURL *url = [NSURL URLWithString:strURL];
    
    //设置参数
    //    NSString *post = [NSString stringWithFormat:@"%@"@"%@",@"paraName={\"name\":method,\"value\":PhoneGetDevInfo},{\"name\":user,\"value\":",user];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:defaultConfig];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSLog(@"请求完成...");
        if (!error) {
            //            NSLog(@"%@", [responseObject valueForKeyPath:@"mac"]);
            if ([date isEqualToString:@"today"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"today" object:self userInfo:responseObject ];
            }
            if ([date isEqualToString:@"yesterday"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"yesterday" object:self userInfo:responseObject ];
            }
            if ([date isEqualToString:@"week"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"week" object:self userInfo:responseObject ];
            }
            if ([date isEqualToString:@"select"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"select" object:self userInfo:responseObject ];
            }
        } else {
            NSLog(@"error : %@", error.localizedDescription);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"postToDataError" object:self ];
        }
    }];
    
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
