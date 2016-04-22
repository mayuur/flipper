//
//  TwitterModel.m
//  SocialSample
//
//  Created by Ashutosh Dave on 03/04/16.
//  Copyright © 2016 Mayur. All rights reserved.
//

#import "TwitterModel.h"

NSString *const kTwitterId = @"id";
NSString *const kTwitterDescription = @"description";
NSString *const kTwitterText = @"text";
NSString *const kTwitterCreatedAt = @"created_at";
NSString *const kTwitterProfileImage = @"profile_image_url";
NSString *const kTwitterRetweetCont = @"retweet_count";
NSString *const kTwitterFavoriteCount = @"favorite_count";
NSString *const kTwitterScreenUserName = @"screen_name";
NSString *const kTwitterName = @"name";

@interface TwitterModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation TwitterModel

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.tweetId = [self objectOrNilForKey:kTwitterId fromDictionary:dict];
        
        NSString* nameString = [self objectOrNilForKey:kTwitterName fromDictionary:dict];
        NSLog(@"name String >%@ ", nameString);
        
        self.name = [self objectOrNilForKey:kTwitterName fromDictionary:[dict objectForKey:@"user"]];
        self.userName = [self objectOrNilForKey:kTwitterScreenUserName fromDictionary:[dict objectForKey:@"user"]];
        self.profileImageUrl = [self objectOrNilForKey:kTwitterProfileImage fromDictionary:dict];
        self.createdAt = [self objectOrNilForKey:kTwitterCreatedAt fromDictionary:dict];
        self.twitterText = [self objectOrNilForKey:kTwitterText fromDictionary:dict];
        self.favoriteCount = [self objectOrNilForKey:kTwitterFavoriteCount fromDictionary:dict];
        self.retweetCount = [self objectOrNilForKey:kTwitterRetweetCont fromDictionary:dict];
    }
    
    return self;
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}



@end
