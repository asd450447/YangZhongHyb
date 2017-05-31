//
//  postWeather.h
//  YangZhongHyb
//
//  Created by mao ke on 2017/5/25.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//成功回调类型:参数: 1. id: object(如果是 JSON ,那么直接解析成OC中的数组或者字典.如果不是JSON ,直接返回 NSData)

typedef void(^SuccessBlock)(NSDictionary *response);

// 失败回调类型:参数: NSError error;

typedef void(^failBlock)(NSError *error);

@interface postWeather : NSObject

// 单例的实例化方法
+ (instancetype)sharedNewtWorkTool;

- (void)PostRequestWithUrl:(NSString *)urlString paramaters:(NSMutableDictionary *)paramaters successBlock:(SuccessBlock)success FailBlock:(failBlock)fail;

@end
