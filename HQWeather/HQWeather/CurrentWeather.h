//
//  movie.h
//  Mark
//
//  Created by hongqing on 16/3/13.
//  Copyright © 2016年 hongqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentWeather : NSObject
@property(nonatomic,assign) NSNumber *cityid;
@property(nonatomic,copy) NSString *citynm;
@property(nonatomic,copy)NSString *week;
@property(nonatomic,copy) NSString *weather;
@property(nonatomic,copy)NSString *temp_low;
@property(nonatomic,copy) NSString *temp_high;


@end
