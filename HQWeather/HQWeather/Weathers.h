//
//  movieList.h
//  Mark
//
//  Created by hongqing on 16/3/12.
//  Copyright © 2016年 hongqing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CurrentWeather;
@interface Weathers : NSObject
@property (nonatomic, copy) NSArray<CurrentWeather *> *result;

@end
