//
//  TwitterAppSessionManager.m
//  TwitterFeedApp
//
//  Created by EricYang on 20/03/2016.
//  Copyright © 2016 Eric. All rights reserved.
//

#import "SessionManager.h"

#define kSequestTimeOutInterval 30.0

@interface SessionManager()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong, nonnull) NSURL *baseURL;

@end

@implementation SessionManager

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super init];
    self.session = [NSURLSession sessionWithConfiguration:configuration];
    if (!self) {
        return nil;
    }
    
    // Ensure terminal slash for baseURL path, so that NSURL +URLWithString:relativeToURL: works as expected
    if ([[url path] length] > 0 && ![[url absoluteString] hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }
    
    self.baseURL = url;
    
    return self;
}

- (NSURLSessionTask *) GET:(NSString*)path
                    header:(NSDictionary *)header
                parameters:(NSDictionary *)parameters
              successBlock:(void(^)(id responseObject))successBlock
                errorBlock:(void(^)(NSError *error))errorBlock
{
    
    NSURL *_url = [self.baseURL URLByAppendingPathComponent:path];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[_url absoluteString]];
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSString *key in [parameters allKeys]) {
        NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:[NSString stringWithFormat:@"%@",[parameters objectForKey:key]]];
        [array addObject:item];
    }
    components.queryItems = array;
    NSURL *url = components.URL;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:kSequestTimeOutInterval];
    [request setHTTPMethod:@"GET"];
    [request setValue:header[@"Authorization"] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];

    return [self performURLSessionTaskForRequest:request successBlock:successBlock errorBlock:errorBlock];
}

- (NSURLSessionTask *) POST:(NSString*)path
                    headers:(NSDictionary *) hearders
                       body:(NSData *)body
               successBlock:(void(^)(id responseObject))successBlock
                 errorBlock:(void(^)(NSError *error))errorBlock
{
    NSURL *url = [self.baseURL URLByAppendingPathComponent:path];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:kSequestTimeOutInterval];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    for (NSString *key in [hearders allKeys]) {
        [request setValue:[hearders objectForKey:key] forHTTPHeaderField:key];
    }
    
    return [self performURLSessionTaskForRequest:request successBlock:successBlock errorBlock:errorBlock];
}

/*
 * Method to perform session task
 */

- (NSURLSessionTask *)performURLSessionTaskForRequest:(NSURLRequest *)request
                                         successBlock:(void(^)(id responseObject))successBlock
                                           errorBlock:(void(^)(NSError *error))errorBlock
{
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error || !data) {
            NSLog(@"Error: %@", error);
            if(errorBlock){
                errorBlock(error);
            }
            return;
        }
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"Error Code: %ld", (long)statusCode);
                if(errorBlock){
                    errorBlock(nil);
                }
                return;
            }
        }
        
        if(data){
            NSError *parseError;
            id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            if (!responseObject) {
                NSLog(@"Error in Parsing Data");
                if(errorBlock){
                    errorBlock(parseError);
                }
            } else {
                NSLog(@"ResponseObject for request: %@", request.URL);
                if(successBlock){
                    successBlock(responseObject);
                }
            }
        }
    }];
    [task resume];
    
    return task;
}



@end
