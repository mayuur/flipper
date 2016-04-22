//
//  TwitterFeedSharedManager.h
//  TwitterFeedApp
//
//  Created by EricYang on 20/03/2016.
//  Copyright © 2016 Eric. All rights reserved.
//

#import "SessionManager.h"

@interface YoutubeSharedManager : SessionManager
/**
 *  Singleton of session manager
 *
 *  @return An instance of YoutubeSharedManager
 */
+ (instancetype) manager;

- (void) getTimeLineByScreenName:(NSString *)name
                        pageSize:(int)size
                         Success:(void(^)(id responseObject))success
                           error:(void(^)(NSError *error))error;

@end;