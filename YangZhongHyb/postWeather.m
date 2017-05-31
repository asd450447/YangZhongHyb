//
//  postWeather.m
//  YangZhongHyb
//
//  Created by mao ke on 2017/5/25.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import "postWeather.h"

@implementation postWeather

+(instancetype)sharedNewtWorkTool

{
    
    static id _instance;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
        
    });
    
    return _instance;
    
}

-(void)PostRequestWithUrl:(NSString *)urlString paramaters:(NSMutableDictionary *)paramaters successBlock:(SuccessBlock)success FailBlock:(failBlock)fail
{

    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    NSDictionary *params = paramaters;
    
    [sessionManager POST:urlString parameters:params constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseObject);
            });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                fail(error);
            });
    }];

}



@end
