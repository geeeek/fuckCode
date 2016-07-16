//
//  movieList.m
//  Mark
//
//  Created by hongqing on 16/3/12.
//  Copyright © 2016年 hongqing. All rights reserved.
//

#import "NewsList.h"
#import "News.h"
@implementation NewsList
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : News.class
             };
}
@end
