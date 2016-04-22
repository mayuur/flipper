//
//  TwitterFeedSharedManager.h
//  TwitterFeedApp
//
//  Created by EricYang on 20/03/2016.
//  Copyright © 2016 Eric. All rights reserved.
//

#import "SessionManager.h"

@interface TwitterFeedSharedManager : SessionManager
/**
 *  Singleton of session manager
 *
 *  @return An instance of TwitterAppSessionManager
 */
+ (instancetype) manager;

/**
 *  Application only authorization
 *
 *  @param success success block
 *  @param error   error block
 */
- (void) setAuthorizationWithSuccess:(void(^)(id responseObject))success
                               error:(void(^)(NSError *error))error;

/**
 *  Get timeline by screen name
 *
 *  @param name    screen name
 *  @param size    page size
 *  @param success success block
 *  @param error   error block
 */
- (void) getTimeLineByScreenName:(NSString *)name
                        pageSize:(int)size
                         Success:(void(^)(id responseObject))success
                           error:(void(^)(NSError *error))error;

/**
 *  get avatar by url
 *
 *  @param urlString url string
 *  @param success   success block
 *  @param error     error block
 */
- (void) getAvatarByURL:(NSString *)urlString
                success:(void(^)(id responseObject))success
                  error:(void(^)(NSError *error))error;
@end
