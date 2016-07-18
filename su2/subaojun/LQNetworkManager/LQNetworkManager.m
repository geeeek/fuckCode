//
//  LQNetworkManager.m
//  kugou
//
//  Created by liang on 16/5/1.
//  Copyright © 2016年 liang. All rights reserved.
//

#import "LQNetworkManager.h"
#import "AFNetworking.h"

@interface LQNetworkManager()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation LQNetworkManager

#pragma mark - Init
+ (instancetype)sharedManager {
    static LQNetworkManager *manager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _networkConfig = [[LQNetworkConfig alloc] init];
    }
    return self;
}

#pragma mark - Request

- (NSURLSessionDataTask *)getWithPath:(NSString *)path
                            parameters:(id)parameters
                            completion:(LQRequestCompletion)completion {
    return [self requestWithPath:path HTTPMethod:LQHTTPMethodGet parameters:parameters  cached:NO progress:nil completion:completion];
}

- (NSURLSessionDataTask *)getWithPath:(NSString *)path
                           parameters:(id)parameters
                             progress:(LQRequestProgress)progress
                           completion:(LQRequestCompletion)completion {
    return [self requestWithPath:path HTTPMethod:LQHTTPMethodGet parameters:parameters cached:NO progress:progress completion:completion];
}

- (NSURLSessionDataTask *)getAndCacheWithPath:(NSString *)path
                           parameters:(id)parameters
                           completion:(LQRequestCompletion)completion {
    AFHTTPRequestSerializer *serializer = [self.sessionManager.requestSerializer copy];
    NSString *URLKey = [self lastModifiedKeyWithPath:path parameters:parameters];
    NSString *lastModified = [self.networkConfig.responseCache objectForKey:URLKey];
    if (lastModified) {
        [self.sessionManager.requestSerializer setValue:lastModified forHTTPHeaderField:@"If-Modified-Since"];
    }
    URLKey = [self etagKeyWithPath:path parameters:parameters];
    NSString *etag = [self.networkConfig.responseCache objectForKey:URLKey];
    if (etag) {
        [self.sessionManager.requestSerializer setValue:etag forHTTPHeaderField:@"If-None-Match"];
    }
    self.sessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    NSURLSessionDataTask *task = [self requestWithPath:path HTTPMethod:LQHTTPMethodGet parameters:parameters cached:YES progress:nil completion:completion];
    self.sessionManager.requestSerializer = serializer;
    
    return task;
}

- (NSURLSessionDataTask *)postWithPath:(NSString *)path
                            parameters:(id)parameters
                            completion:(LQRequestCompletion)completion {
    return [self requestWithPath:path HTTPMethod:LQHTTPMethodPost parameters:parameters  cached:NO progress:nil completion:completion];
}

- (NSURLSessionDataTask *)postWithPath:(NSString *)path
                            parameters:(id)parameters
                              progress:(LQRequestProgress)progress
                            completion:(LQRequestCompletion)completion {
    return [self requestWithPath:path HTTPMethod:LQHTTPMethodPost parameters:parameters cached:NO progress:progress completion:completion];
}

- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                           HTTPMethod:(LQHTTPMethod)HTTPMethod
                           parameters:(id)parameters
                               cached:(BOOL)cached
                             progress:(LQRequestProgress)progress
                           completion:(LQRequestCompletion)completion {

    NSURLSessionDataTask *task = nil;
    switch (HTTPMethod) {
        case LQHTTPMethodGet:
        {
            task = [self.sessionManager GET:path parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                
                if (progress) {
                    progress(downloadProgress);
                }
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (cached) {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                    NSString *URLKey = [self lastModifiedKeyWithPath:path parameters:parameters];
                    NSString *lastModified = [httpResponse.allHeaderFields objectForKey:@"Last-Modified"];
                    if (URLKey && lastModified) {
                        [self.networkConfig.responseCache setObject:lastModified forKey:URLKey];
                    }
                    URLKey = [self etagKeyWithPath:path parameters:parameters];
                    NSString *etag = [httpResponse.allHeaderFields objectForKey:@"Etag"];
                    if (URLKey && etag) {
                        [self.networkConfig.responseCache setObject:etag forKey:URLKey];
                    }
                }
                
                [self logRequestSucessWithType:@"Get" response:task.response responseObject:responseObject];
                completion(responseObject, nil);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (!cached) {
                    [self logRequestFailWithType:@"Get" error:error];
                    completion(nil, error);
                    return;
                }
                
                id responseObject = nil;
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                if (httpResponse.statusCode == 304) { // Not Modified
                    NSCachedURLResponse *cacheResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:task.currentRequest];
                    responseObject = cacheResponse.data;
                }
                
                if (responseObject) {
                    NSString *URLKey = [self lastModifiedKeyWithPath:path parameters:parameters];
                    NSString *lastModified = [httpResponse.allHeaderFields objectForKey:@"Last-Modified"];
                    if (URLKey && lastModified) {
                        [self.networkConfig.responseCache setObject:lastModified forKey:URLKey];
                    }
                    URLKey = [self etagKeyWithPath:path parameters:parameters];
                    NSString *etag = [httpResponse.allHeaderFields objectForKey:@"Etag"];
                    if (URLKey && etag) {
                        [self.networkConfig.responseCache setObject:etag forKey:URLKey];
                    }

                    [self logRequestSucessWithType:@"Get Cache->" response:task.response responseObject:responseObject];
                    completion(responseObject, nil);
                } else {
                    [self logRequestFailWithType:@"Get" error:error];
                    completion(nil, error);
                }
            }];
            
            [self log:[NSString stringWithFormat:@"========>\n%@: %@\nparameters:%@", task.currentRequest.HTTPMethod, task.currentRequest.URL, parameters]];
        }
            break;
        case LQHTTPMethodPost:
        {
            task = [self.sessionManager POST:path parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                
                if (progress) {
                    progress(downloadProgress);
                }
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self logRequestSucessWithType:@"Post" response:task.response responseObject:responseObject];
                completion(responseObject, nil);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self logRequestFailWithType:@"Post" error:error];
                completion(nil, error);
            }];
            
            [self log:[NSString stringWithFormat:@"========>\n%@: %@\nparameters:%@", task.currentRequest.HTTPMethod, task.currentRequest.URL, parameters]];
            
        }
            break;
            
        default:
            break;
    }
    
    return task;
}

- (NSURLSessionDownloadTask *)downloadWithPath:(NSString *)path
                                    saveToPath:(NSString *)saveToPath
                                      progress:(void (^)(NSProgress *))progress
                                    completion:(LQRequestCompletion)completion {
    if (!path || path.length<1 || !saveToPath || saveToPath.length<1) {
        return nil;
    }
    
    NSString *absolutePath = path;
    if (self.sessionManager.baseURL) {
        absolutePath = [[NSURL URLWithString:path relativeToURL:self.sessionManager.baseURL] absoluteString];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:absolutePath]];
    
    NSURLSessionDownloadTask *downloadTask = [self.sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //Don't use [NSURL URLWithString:]!
        return [NSURL fileURLWithPath:saveToPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (!error) {
            [self log:[NSString stringWithFormat:@"========>\nDownload success: %@\nsaveToPath: %@", response.URL, filePath.absoluteString]];
            completion(filePath.absoluteString, nil);
        } else {
            [self logRequestFailWithType:@"Download" error:error];
            completion(nil, error);
        }
        
    }];
    
    [self log:[NSString stringWithFormat:@"========>\nDownload: %@", downloadTask.currentRequest.URL]];
    [downloadTask resume];
    
    return downloadTask;
}

- (NSURLSessionUploadTask *)uploadFileWithPath:(NSString *)path
                                      fromFile:(NSString *)filePath
                                      progress:(void (^)(NSProgress * _Nonnull))progress
                                    completion:(LQRequestCompletion)completion {
    if (!path || path.length<1 || !filePath || filePath.length<1) {
        return nil;
    }
    
    NSString *absolutePath = path;
    if (self.sessionManager.baseURL) {
        absolutePath = [[NSURL URLWithString:path relativeToURL:self.sessionManager.baseURL] absoluteString];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:absolutePath]];

    NSURLSessionUploadTask *uploadTask = [self.sessionManager uploadTaskWithRequest:request fromFile:[NSURL fileURLWithPath:filePath] progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress) {
            progress(uploadProgress);
        }

    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            [self logRequestSucessWithType:@"Upload" response:response responseObject:responseObject];
            completion(response, nil);
        } else {
            [self logRequestFailWithType:@"Upload" error:error];
            completion(nil, error);
        }
        
    }];
    
    [self log:[NSString stringWithFormat:@"========>\nUpload file: %@", uploadTask.currentRequest.URL]];
    [uploadTask resume];
    
    return uploadTask;
}


- (NSURLSessionDataTask *)uploadWithImage:(UIImage *)image
                                     path:(NSString *)path
                                     name:(NSString *)name
                               parameters:(NSDictionary *)parameters
                                 progress:(void (^)(NSProgress *))progress
                               completion:(LQRequestCompletion)completion {
    
    return [self uploadWithImage:image path:path name:name fileName:nil mimeType:@"image/jped" compressed:YES parameters:parameters progress:progress completion:completion];
}

- (NSURLSessionDataTask *)uploadWithImage:(UIImage *)image
                                     path:(NSString *)path
                                     name:(NSString *)name
                                 fileName:(NSString *)fileName
                                 mimeType:(NSString *)mimeType
                               compressed:(BOOL)compressed
                               parameters:(NSDictionary *)parameters
                                 progress:(void (^)(NSProgress *))progress
                               completion:(LQRequestCompletion)completion {
    if (!image || !path || path.length<1) {
        return nil;
    }
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if (compressed && ((float)imageData.length/1024 > 1000)) {
        imageData = UIImageJPEGRepresentation(image, 1024*1000.0/(float)imageData.length);
    }

    if (!fileName) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        fileName = [NSString stringWithFormat:@"image_%@.jpg", str];
    }
    if (!mimeType) {
        mimeType = @"image/jpeg";
    }

    NSURLSessionDataTask *task = [self.sessionManager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress) {
            progress(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self logRequestSucessWithType:@"Upload" response:task.response responseObject:responseObject];
        completion(responseObject, nil);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self logRequestFailWithType:@"Upload" error:error];
        completion(nil, error);

    }];
    
    [self log:[NSString stringWithFormat:@"========>\nUpload post image: %@\nparameters:%@", task.currentRequest.URL, parameters]];
    
    return task;
}

- (void)cancelAllRequests {
    [self.sessionManager.tasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
}

- (void)cancelRequestWithPath:(NSString *)path {
    if (!path || path.length<1) {
        return;
    }
    
    NSString *absolutePath = path;
    if (self.sessionManager.baseURL) {
        absolutePath = [[NSURL URLWithString:path relativeToURL:self.sessionManager.baseURL] absoluteString];
    }
    
    [self.sessionManager.tasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.currentRequest.URL.absoluteString isEqualToString:absolutePath]) {
            [obj cancel];
        }
    }];
}

# pragma mark - Getter Setter
- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [self sessionManagerWithConfig:self.networkConfig];
    }
    return _sessionManager;
}

- (void)setNetworkConfig:(LQNetworkConfig *)networkConfig {
    NSParameterAssert(networkConfig);
    
    if (_networkConfig != networkConfig) {
        [_sessionManager.session finishTasksAndInvalidate];
        _networkConfig = networkConfig;
        _sessionManager = [self sessionManagerWithConfig:networkConfig];
    }
}

# pragma mark - Private

- (AFHTTPSessionManager *)sessionManagerWithConfig:(LQNetworkConfig *)config {
    AFHTTPSessionManager *sessionManager;
    if (config.baseURLString) {
        sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:config.baseURLString]];
    } else {
        sessionManager = [[AFHTTPSessionManager alloc] init];
    }
    
    switch (config.requestType) {
        case LQRequestSerializeJSON: {
            sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        }
        case LQRequestSerializeHTTP: {
            sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        }
    }
    
    switch (config.responseType) {
        case LQResponseSerializeJSON: {
            AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
            responseSerializer.removesKeysWithNullValues = config.removesKeysWithNullValues;
            sessionManager.responseSerializer = responseSerializer;
            break;
        }
        case LQResponseSerializeData: {
            sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        }
    }
    sessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [config.httpHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isKindOfClass:[NSString class]] && [obj isKindOfClass:[NSString class]]) {
            [sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }
    }];
    sessionManager.requestSerializer.timeoutInterval = config.timeoutInterval;
    
    return sessionManager;
}

- (NSString *)lastModifiedKeyWithPath:(NSString *)path parameters:(NSDictionary *)parameters{
    if (!path) {
        return nil;
    }
    
    NSMutableString *URLKey = [NSMutableString stringWithString:@"LastModified"];
    if (self.networkConfig.baseURLString) {
        [URLKey appendString:self.networkConfig.baseURLString];
    }
    [URLKey appendString:path];
    if (parameters) {
        [URLKey appendString:AFQueryStringFromParameters(parameters)];
    }
    return URLKey;
}

- (NSString *)etagKeyWithPath:(NSString *)path parameters:(NSDictionary *)parameters{
    if (path) {
        return nil;
    }
    NSMutableString *URLKey = [NSMutableString stringWithString:@"Etag"];
    if (self.networkConfig.baseURLString) {
        [URLKey appendString:self.networkConfig.baseURLString];
    }
    [URLKey appendString:path];
    if (parameters) {
        [URLKey appendString:AFQueryStringFromParameters(parameters)];
    }
    return URLKey;
}

# pragma mark - Log

- (void)log:(NSString *)message {
    if (self.networkConfig.debugLogEnable) {
        NSLog(@"%@", message);
    }
}

- (void)logRequestSucessWithType:(NSString *)type response:(NSURLResponse *)response responseObject:(id)responseObject {
    if (!self.networkConfig.debugLogEnable) {
        return;
    }
    
    NSString *responseString = responseObject;
    if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
        responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    }
    
    [self log:[NSString stringWithFormat:@"========>\n%@ success: %@\nresponse: %@", type, response.URL, responseString]];
}

- (void)logRequestFailWithType:(NSString *)type error:(NSError *)error {
    if (!self.networkConfig.debugLogEnable || !error) {
        return;
    }
    
    NSString *url = [error.userInfo objectForKey:@"NSErrorFailingURLKey"];
    NSString *responseString = nil;
    NSData *data = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (data) {
        responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    [self log:[NSString stringWithFormat:@"========>\n%@ fail: %@\nLocalizedDescription: %@\nResponseErrorData: %@", type, url, error.localizedDescription, responseString]];
}

@end
