//
//  TwitterAppSessionManager.h
//  TwitterFeedApp
//
//  Created by EricYang on 20/03/2016.
//  Copyright © 2016 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionManager : NSObject

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration;

/**
 *  Perform a customized request
 *
 *  @param request      request
 *  @param successBlock success block
 *  @param errorBlock   error block
 *
 *  @return task
 */
- (NSURLSessionTask *)performURLSessionTaskForRequest:(NSURLRequest *)request
                                         successBlock:(void(^)(id responseObject))successBlock
                                           errorBlock:(void(^)(NSError *error))errorBlock;

/**
 *  GET request
 *
 *  @param path         url path
 *  @param successBlock success block
 *  @param errorBlock   error block
 *
 *  @return instance of NSURLSessionTask
 */
- (NSURLSessionTask *) GET:(NSString*)path
                    header:(NSDictionary *)header
                parameters:(NSDictionary *)parameters
              successBlock:(void(^)(id responseObject))successBlock
                errorBlock:(void(^)(NSError *error))errorBlock;

/**
 *  POST request
 *
 *  @param path         url path
 *  @param hearders     header dictionary
 *  @param body         nsdata body
 *  @param successBlock success block
 *  @param errorBlock   error block
 *
 *  @return instance of NSURLSessionTask
 */
- (NSURLSessionTask *) POST:(NSString*)path
                    headers:(NSDictionary *) hearders
                       body:(NSData *)body
               successBlock:(void(^)(id responseObject))successBlock
                 errorBlock:(void(^)(NSError *error))errorBlock;
@end
