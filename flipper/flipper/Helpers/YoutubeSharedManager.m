//
//  TwitterFeedSharedManager.m
//  TwitterFeedApp
//
//  Created by EricYang on 20/03/2016.
//  Copyright © 2016 Eric. All rights reserved.
//

#import "YoutubeSharedManager.h"

#define kYoutubeAPISecretKey @"AIzaSyBEpKsV6JBvFxn9HKjVvd7biN1yqJcViWM"

#define kBaseURL @"https://www.googleapis.com/youtube/v3/"

@implementation YoutubeSharedManager

+ (instancetype) manager
{
    static YoutubeSharedManager* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [configuration setHTTPMaximumConnectionsPerHost:1];
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL] sessionConfiguration:configuration];
    });
    return manager;

}

- (void) getTimeLineByScreenName:(NSString *)name
                        pageSize:(int)size
                         Success:(void(^)(id responseObject))success
                           error:(void(^)(NSError *error))error {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setObject:@"snippet" forKey:@"part"];
    [parameters setObject:name forKey:@"playlistId"];
    [parameters setObject:kYoutubeAPISecretKey forKey:@"key"];
    
    [self GET:[NSString stringWithFormat:@"playlistItems"]
           header:nil
       parameters:parameters
     successBlock:^(id responseObject) {
         
         for (NSDictionary *dict in responseObject) {
             
             /*NSMutableDictionary *_dict = [NSMutableDictionary new];
             [_dict setObject:dict[@"user"][@"name"] forKey:@"name"];
             [_dict setObject:dict[@"user"][@"screen_name"] forKey:@"userName"];
             [_dict setObject:dict[@"user"][@"profile_image_url"] forKey:@"profileImageUrl"];
             [_dict setObject:dict[@"created_at"] forKey:@"createdAt"];
             [_dict setObject:dict[@"text"] forKey:@"twitterText"];
             [_dict setObject:dict[@"id"] forKey:@"id"];
             NSLog(@"dict >> %@", _dict);*/
         }
         success(responseObject);
     }
   errorBlock:error];
}

@end
