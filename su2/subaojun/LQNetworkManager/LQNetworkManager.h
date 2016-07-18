//
//  LQNetworkManager.h
//  kugou
//
//  Created by liang on 16/5/1.
//  Copyright © 2016年 liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LQNetworkConfig.h"

typedef void (^LQRequestCompletion)(id responseObject, NSError *error);
typedef void (^LQRequestProgress)(NSProgress *progress);

typedef NS_ENUM(NSUInteger, LQHTTPMethod) {
    LQHTTPMethodGet,
    LQHTTPMethodPost
};


@interface LQNetworkManager : NSObject

@property (nonatomic, strong) LQNetworkConfig *networkConfig;

/**
 *  Singleton
 */
+ (instancetype)sharedManager;

/**
 *  Get request
 *
 *  @param path       The URL string used to create the request URL.
 *  @param parameters
 *  @param completion  A block object to be executed when the task finished.
 *
 */
- (NSURLSessionDataTask *)getWithPath:(NSString *)path
                           parameters:(id)parameters
                           completion:(LQRequestCompletion)completion;

- (NSURLSessionDataTask *)getWithPath:(NSString *)path
                           parameters:(id)parameters
                             progress:(LQRequestProgress)progress
                           completion:(LQRequestCompletion)completion;

- (NSURLSessionDataTask *)getAndCacheWithPath:(NSString *)path
                           parameters:(id)parameters
                           completion:(LQRequestCompletion)completion;

/**
 *  Post request
 *
 *  @param path       The URL string used to create the request URL.
 *  @param parameters
 *  @param completion A block object to be executed when the task finished.
 *
 */
- (NSURLSessionDataTask *)postWithPath:(NSString *)path
                           parameters:(id)parameters
                           completion:(LQRequestCompletion)completion;

- (NSURLSessionDataTask *)postWithPath:(NSString *)path
                            parameters:(id)parameters
                              progress:(LQRequestProgress)progress
                            completion:(LQRequestCompletion)completion;

/**
 *  Download request
 *
 *  @param path       The URL string used to create the request URL.
 *  @param saveToPath The path of the downloaded file.
 *  @param progress   A block object to be executed when the download progress is updated.
 *  @param completion A block object to be executed when the task finished.
 *
 */
- (NSURLSessionDownloadTask *)downloadWithPath:(NSString *)path
                                    saveToPath:(NSString *)saveToPath
                                      progress:(LQRequestProgress)progress
                                    completion:(LQRequestCompletion)completion;

/**
 *  Upload request
 *
 *  @param path       The URL string used to create the request URL.
 *  @param filePath   The path of the upload file.
 *  @param progress   A block object to be executed when the upload progress is updated.
 *  @param completion A block object to be executed when the task finished.
 *
 */
- (NSURLSessionUploadTask *)uploadFileWithPath:(NSString *)path
                                      fromFile:(NSString *)filePath
                                      progress:(LQRequestProgress)progress
                                    completion:(LQRequestCompletion)completion;

/**
 *  Post image
 *
 *  @param image      The image to upload
 *  @param path       The URL string used to create the request URL.
 *  @param name       The parameter name
 *  @param parameters
 *  @param progress   A block object to be executed when the upload progress is updated.
 *  @param completion A block object to be executed when the task finished.
 *
 */
- (NSURLSessionDataTask *)uploadWithImage:(UIImage *)image
                                     path:(NSString *)path
                                     name:(NSString *)name
                               parameters:(NSDictionary *)parameters
                                 progress:(LQRequestProgress)progress
                               completion:(LQRequestCompletion)completion;

/**
 *  Post image
 *
 *  @param image      The image to upload
 *  @param path       The URL string used to create the request URL.
 *  @param name       The parameter name
 *  @param fileName   The name of image
 *  @param mimeType
 *  @param compressed Should be compressed or not
 *  @param parameters
 *  @param progress   A block object to be executed when the upload progress is updated.
 *  @param completion A block object to be executed when the task finished.
 *
 */
- (NSURLSessionDataTask *)uploadWithImage:(UIImage *)image
                                     path:(NSString *)path
                                     name:(NSString *)name
                                 fileName:(NSString *)fileName
                                 mimeType:(NSString *)mimeType
                               compressed:(BOOL)compressed
                               parameters:(NSDictionary*)parameters
                                 progress:(LQRequestProgress)progress
                               completion:(LQRequestCompletion)completion;

/**
 *  Cancel all request
 */
- (void)cancelAllRequests;

/**
 *  Cancel request by the specified path
 *
 *  @param path The URL string
 */
- (void)cancelRequestWithPath:(NSString *)path;

@end
