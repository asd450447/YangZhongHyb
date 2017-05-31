//
//  ViewController.h
//  YangZhongHyb
//
//  Created by mao ke on 2017/5/25.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "postWeather.h"
#import "DevUITableViewCell.h"
#import "ChartViewController.h"
#import "DKProgressHUD.h"
#import "LDProgressView.h"
#import "GCDAsyncSocket.h"

@interface ViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>{
    GCDAsyncSocket *_socket;
    NSInputStream *_inputStream;
    NSOutputStream *_outputStream;
    NSMutableArray *_msgArray;
}

@property (nonatomic, strong)CLLocationManager *cllocationManager;
@property (weak, nonatomic) IBOutlet UILabel *lableCity;
@property (weak, nonatomic) IBOutlet UILabel *lableWeather;
@property (weak, nonatomic) IBOutlet UILabel *lableTemp;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property UIRefreshControl *control;
@property NSMutableArray *DevHybArr;
@end

