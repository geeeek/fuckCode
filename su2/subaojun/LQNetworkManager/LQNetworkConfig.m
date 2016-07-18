//
//  LQNetworkConfig.m
//  kugou
//
//  Created by liang on 16/5/2.
//  Copyright © 2016年 liang. All rights reserved.
//

#import "LQNetworkConfig.h"

@interface LQNetworkConfig()

@end

@implementation LQNetworkConfig

- (instancetype)init {
    return [self initWithBaseURLString:nil];
}

- (instancetype)initWithBaseURLString:(NSString *)URLString {
    self = [super init];
    if (self) {
        _baseURLString = URLString;
        _timeoutInterval = 60.0;
        _removesKeysWithNullValues = YES;
        _requestType = LQRequestSerializeHTTP;
        _responseType = LQResponseSerializeJSON;
#ifdef DEBUG
        _debugLogEnable = YES;
#else
        _debugLogEnable = NO;
#endif
    }
    return self;
}


- (NSMutableDictionary *)responseCache {
    if (!_responseCache) {
        _responseCache = [NSMutableDictionary dictionary];
    }
    return _responseCache;
}

@end
