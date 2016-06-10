//
//  HttpTool.m
//  Mark
//
//  Created by hongqing on 16/4/11.
//  Copyright © 2016年 hongqing. All rights reserved.
//

#import "HttpTool.h"
#import "AFHTTPSessionManager.h"
@implementation HttpTool
+(void)get:(NSString *)urlStr parameters:(NSDictionary *)parameters withCompletionBlock:(CompletionBlock)successBlock withFailureBlock:(FailureBlock)failureBlock;
{
    
    AFHTTPSessionManager *session= [AFHTTPSessionManager manager];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [session GET:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull operation, id  _Nonnull responseObject) {
        if(successBlock){
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    
}
@end
