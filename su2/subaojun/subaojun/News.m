
//
//  movie.m
//  Mark
//
//  Created by hongqing on 16/3/13.
//  Copyright © 2016年 hongqing. All rights reserved.
//

#import "News.h"

@implementation News
+(NSDictionary *)modelCustomPropertyMapper
{
    return @{@"newsId":@"fID",
             @"title":@"fTitle",
             @"newsDate":@"fCreateDate",
             @"contentInfo":@"fContent"
             
             };
}
@end
