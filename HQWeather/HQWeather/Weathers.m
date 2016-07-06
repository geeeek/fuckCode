//
//  movieList.m
//  Mark
//
//  Created by hongqing on 16/3/12.
//  Copyright © 2016年 hongqing. All rights reserved.
//

#import "Weathers.h"
#import "CurrentWeather.h"
@implementation Weathers
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"result" : CurrentWeather.class
             };
}
@end
