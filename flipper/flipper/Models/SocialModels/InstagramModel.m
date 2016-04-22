//
//  InstagramModel.m
//  SocialSample
//
//  Created by Ashutosh Dave on 09/04/16.
//  Copyright © 2016 Mayur. All rights reserved.
//

#import "InstagramModel.h"

NSString *const kInstagramId = @"id";
NSString *const kInstagramDescription = @"description";
NSString *const kInstagramText = @"text";
NSString *const kInstagramCreatedAt = @"created_time";
NSString *const kInstagramProfilePicture = @"profile_picture";
NSString *const kInstagramCommentCont = @"comments";
NSString *const kInstagramLikesCount = @"likes";
NSString *const kInstagramMainImage = @"standard_resolution";
NSString *const kInstagramUserName = @"username";

@interface InstagramModel ()

@end

@implementation InstagramModel

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
        self.userId = [self objectOrNil:dict[@"user"][kInstagramId]];
        self.username = [self objectOrNil:dict[@"user"][kInstagramUserName]];
        self.profile_picture = [self objectOrNil:dict[@"user"][kInstagramProfilePicture]];
        self.createdAt = [self objectOrNil:dict[kInstagramCreatedAt]];
//        if(dict[@"caption"])
        if([dict objectForKey:@"caption"] != [NSNull null]) {
            self.captionText = [self objectOrNil:dict[@"caption"][kInstagramText]];
        }
        self.likesCount = [NSString stringWithFormat:@"%@",[self objectOrNil:dict[kInstagramLikesCount][@"count"]]];
        self.commentCount = [NSString stringWithFormat:@"%@",[self objectOrNil:dict[kInstagramCommentCont][@"count"]]];
        self.mainImage = [self objectOrNil:dict[@"images"][kInstagramMainImage][@"url"]];
        }
    
    return self;
    
}

#pragma mark - Helper Method
- (id)objectOrNil:(id)object
{
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
