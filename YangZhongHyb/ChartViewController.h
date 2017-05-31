//
//  ChartViewController.h
//  huyubao
//
//  Created by mao ke on 2017/4/22.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFChart.h"
#import "ActionSheetPicker.h"
#import "ActionSheetDatePicker.h"
#import "AFNetworking.h"

@interface ChartViewController : UIViewController<ZFGenericChartDataSource, ZFLineChartDelegate>

@property (nonatomic, strong) ZFLineChart * lineChart;
@property (nonatomic, strong) ZFLineChart * lineChart2;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;
@property (nonatomic, strong) NSDate *selectedDate;
@property (weak, nonatomic) IBOutlet UIButton *dataSelect;
@property NSArray *ryArr;
@property NSArray *tempArr;
@property NSMutableArray *valueArr;
@property NSArray *timeArr;
@property NSString *hybName;
@end
