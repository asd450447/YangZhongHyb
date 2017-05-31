//
//  ViewController.m
//  YangZhongHyb
//
//  Created by mao ke on 2017/5/25.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    CLLocationDegrees lati;
    CLLocationDegrees longti;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
//下划线顶头
//    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    //取消下划线
     _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _DevHybArr = [[NSMutableArray alloc]init];
    [_DevHybArr addObject:@"护渔宝1号"];
    [_DevHybArr addObject:@"护渔宝2号"];
    [_DevHybArr addObject:@"护渔宝3号"];
//    [self setupRefresh];
    [self connectHost: @"221.131.75.244" connectPort:8899];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [DKProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"DevTableView";
    DevUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.hybName.text = _DevHybArr[indexPath.row];
    return cell;

}


- ( void )tableView:( UITableView *)tableView didSelectRowAtIndexPath:( NSIndexPath *)indexPath{
    ChartViewController *chartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"chartViewController"];
    chartVC.hybName = _DevHybArr[indexPath.row];
    [self.navigationController pushViewController:chartVC animated:YES];
    
}

- ( CGFloat )tableView:( UITableView *)tableView heightForRowAtIndexPath:( NSIndexPath *)indexPath{
    return 120;
}
/**
 *  集成下拉刷新
 */
-(void)setupRefresh
{
    //1.添加刷新控件
    _control=[[UIRefreshControl alloc]init];
    [_control addTarget:self action:@selector(DTrefreshStateChange) forControlEvents:UIControlEventValueChanged];
    
    _control.attributedTitle = [[NSAttributedString alloc]initWithString:@"加载中..."];
    
    
    [self.tableView addSubview:_control];
    
    //2.马上进入刷新状态，并不会触发UIControlEventValueChanged事件
    [_control beginRefreshing];
    [_control addTarget:self action:@selector(finishLoading:) forControlEvents:UIControlEventValueChanged];
    // 3.加载数据
    [self DTrefreshStateChange];
    
}

/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 */
-(void)DTrefreshStateChange
{
    [self setMap];
}

//下拉时添加时间
- (void)finishLoading:(UIRefreshControl *)ctl
{
    [ctl endRefreshing];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * time = [formatter stringFromDate:[NSDate date]];
    ctl.attributedTitle = [[NSAttributedString alloc] initWithString:time] ;
}

#pragma mark--Map
- (void)setMap {
    
    //定位功能可用，开始定位
    _cllocationManager = [[CLLocationManager alloc]init];
    _cllocationManager.delegate = self;
    _cllocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [_cllocationManager requestWhenInUseAuthorization];
    [_cllocationManager startUpdatingLocation];
    NSLog(@"setmap");
    
}

// 判断定位是否可用
- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error {
    
    NSString *errorString;
    [manager stopUpdatingLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"用户关闭";
            // 定位不可用 —— 传虚拟经纬度
            lati = 0.000000;
            longti = 0.000000;
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"位置数据不可用";
            //Do something else...
            break;
        default:
            errorString = @"未知错误";
            break;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:Ok];
    [self presentViewController:alert animated:YES completion:nil];
}

// 代理方法 地理位置反编码
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newlocation = locations[0];
    CLLocationCoordinate2D oCoordinate = newlocation.coordinate;
    NSLog(@"经度：%f，维度：%f",oCoordinate.longitude,oCoordinate.latitude);
    // 给经纬度全局属性赋值
    lati = oCoordinate.latitude;
    longti = oCoordinate.longitude;
    
    //    [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(action:) userInfo:nil repeats:nil];
    [_cllocationManager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:newlocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark *place in placemarks) {
            //            NSDictionary *location =[place addressDictionary];
            //            NSLog(@"国家：%@",[location objectForKey:@"Country"]);
            //            NSLog(@"城市：%@",[location objectForKey:@"State"]);
            //            NSLog(@"区：%@",[location objectForKey:@"SubLocality"]);
            //            NSLog(@"位置：%@", place.name);
            //            NSLog(@"国家：%@", place.country);
            _lableCity.text = [place.locality substringToIndex:2 ];
            NSMutableDictionary *dict = @{
                                          @"cityname" : [place.locality substringToIndex:2],
                                          @"key" : @"8a9fcef45a44b211652af449a28f494c",
                                          }.mutableCopy;
            
//            [[postWeather sharedNewtWorkTool] PostRequestWithUrl:@"https://op.juhe.cn/onebox/weather/query" paramaters:dict successBlock:^(NSDictionary *response) {
//                NSLog(@"网络请求成功");
//                @try {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                            _lableWeather.text = response[@"result"][@"data"][@"realtime"][@"weather"][@"info"];
//                            _lableTemp.text = response[@"result"][@"data"][@"realtime"][@"weather"][@"temperature"];
//                    });
//                } @catch (NSException *exception) {
//                     NSLog(@"exception:%@", exception);
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"异常" message:@"当天请求天气次数已满" preferredStyle:UIAlertControllerStyleAlert];
//                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
//                    [self presentViewController:alert animated:YES completion:nil];
//                } @finally {
//                    
//                }
//            } FailBlock:^(NSError *error) {
//                
//                NSLog(@"网络请求失败");
//                
//            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_control endRefreshing];
            });
            NSLog(@"城市：%@", place.locality);
            //            NSLog(@"区：%@", place.subLocality);
            //            NSLog(@"街道：%@", place.thoroughfare);
            //            NSLog(@"子街道：%@", place.subThoroughfare);
        }
    }];
    
//    NSLog(@"@@@@@@@@@@=====%f,%f",lati,longti);
    
}

#pragma mark socket delegate
-(void)connectHost:(NSString *)host connectPort:(UInt32)port{
    //创建GCDAsyncSocket
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    [_socket connectToHost:host onPort:port error:&error];
    if (error != nil) {
        NSLog(@"%@",error);
    }
    
    
}

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"didConneetToHost:%s",__func__);
    [self sendMassageBtuClick:@"jshuyubao"];
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"连接失败或已断开:%@",err);
}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    //    NSLog(@"didWriteDataWithTag%s",__func__);
    [_socket readDataWithTimeout:-1 tag:tag];
    
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    //    NSLog(@"didReadData:%s",__func__);
    [sock readDataWithTimeout:-1 tag:200];
    NSString *receiverStr = [[NSString alloc] initWithData:[self replaceNoUtf8:data] encoding:NSUTF8StringEncoding];
    NSLog(@"receiverStr:%@",receiverStr);
    //除去字符串中看不见的空格
//    NSString *additionalMessage = [receiverStr   stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    
}

#pragma mark 读取数据
-(void)readData{
    uint8_t buff[1024];
    
    NSInteger len = [_inputStream read:buff maxLength:sizeof(buff)];
    NSMutableData *input = [[NSMutableData alloc] init];
    [input appendBytes:buff length:len];
    NSString *resultstring = [[NSString alloc]initWithData:input encoding:NSUTF8StringEncoding];
    NSLog(@"%@",resultstring);
    [_msgArray addObject:resultstring];
    //    [_tableView1 reloadData];
    
}

#pragma mark send 按钮
- (void)sendMassageBtuClick:(NSString *)msg{
    
    //    NSString *msg = @"getdatabyjl";
    [_socket writeData:[msg dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:102];
    
    [self.view endEditing:YES];
    
}


#pragma mark 发送的封装方法
-(void)sendMassage:(NSString *)msg{
    NSData *buff = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    [_outputStream write:buff.bytes maxLength:buff.length];
}

//丢弃无用的ascii码
- (NSData *)replaceNoUtf8:(NSData *)data
{
    char aa[] = {'A','A','A','A','A','A'};                      //utf8最多6个字符，当前方法未使用
    NSMutableData *md = [NSMutableData dataWithData:data];
    int loc = 0;
    while(loc < [md length])
    {
        char buffer;
        [md getBytes:&buffer range:NSMakeRange(loc, 1)];
        if((buffer & 0x80) == 0)
        {
            loc++;
            continue;
        }
        else if((buffer & 0xE0) == 0xC0)
        {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80)
            {
                loc++;
                continue;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else if((buffer & 0xF0) == 0xE0)
        {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80)
            {
                loc++;
                [md getBytes:&buffer range:NSMakeRange(loc, 1)];
                if((buffer & 0xC0) == 0x80)
                {
                    loc++;
                    continue;
                }
                loc--;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else
        {
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
    }
    
    return md;
}

@end
