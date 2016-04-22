//
//  TwitterModel.h
//  SocialSample
//
//  Created by Ashutosh Dave on 03/04/16.
//  Copyright © 2016 Mayur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *profileImageUrl;
@property (nonatomic,strong) NSString *createdAt;
@property (nonatomic,strong) NSString *twitterText;
@property (nonatomic,strong) NSString *tweetId;
@property (nonatomic,strong) NSString *retweetCount;
@property (nonatomic,strong) NSString *favoriteCount;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
