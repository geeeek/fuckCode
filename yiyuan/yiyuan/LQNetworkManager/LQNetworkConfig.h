//
//  LQNetworkConfig.h
//  kugou
//
//  Created by liang on 16/5/2.
//  Copyright © 2016年 liang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LQRequestSerializeType) {
    LQRequestSerializeJSON,
    LQRequestSerializeHTTP
};

typedef NS_ENUM(NSUInteger, LQResponseSerializeType) {
    LQResponseSerializeJSON,
    LQResponseSerializeData
};

@interface LQNetworkConfig : NSObject

@property (readonly, nonatomic, copy) NSString *baseURLString;
@property (nonatomic, strong) NSDictionary *httpHeaders;
@property (nonatomic, assign) LQRequestSerializeType requestType;
@property (nonatomic, assign) LQResponseSerializeType responseType;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, assign) BOOL debugLogEnable;
@property (nonatomic, assign) BOOL removesKeysWithNullValues;
@property (nonatomic, strong) NSMutableDictionary *responseCache;

- (instancetype)initWithBaseURLString:(NSString *)URLString;

@end
