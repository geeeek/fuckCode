//
//  HttpTool.h
//  Mark
//
//  Created by hongqing on 16/4/11.
//  Copyright © 2016年 hongqing. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CompletionBlock)(id returnValue);
typedef void(^FailureBlock)(NSError *error);

@interface HttpTool : NSObject
+(void)get:(NSString *)url parameters:(NSDictionary *)parameters withCompletionBlock:(CompletionBlock)successBlock withFailureBlock:(FailureBlock)failureBlock;
@end
