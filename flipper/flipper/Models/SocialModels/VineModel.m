//
//  VineModel.m
//  SocialSample
//
//  Created by Ashutosh Dave on 03/04/16.
//  Copyright © 2016 Mayur. All rights reserved.
//

#import "VineModel.h"

NSString *const kVinePostId = @"postId";
NSString *const kVineUsername = @"username";
NSString *const kVineDescription = @"description";
NSString *const kVineCommentCount = @"comments";
NSString *const kVineLikes = @"likes";
NSString *const kVineUrlThumb = @"thumbnailUrl";
NSString *const kVineUrlAvatar = @"avatarUrl";
NSString *const kVineCreateAt = @"created";
NSString *const kVineLink = @"permalinkUrl";

@implementation VineModel

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
        self.username = [self objectOrNil:[dict objectForKey:kVineUsername]];
        self.vineDescription = [self objectOrNil:[dict objectForKey:kVineDescription]];
        self.likes = [NSString stringWithFormat:@"%@",[self objectOrNil:dict[kVineLikes][@"count"]]];
        self.commentCount = [NSString stringWithFormat:@"%@",[self objectOrNil:dict[kVineCommentCount][@"count"]]];
        self.vinePostId = [self objectOrNil:dict[kVinePostId]];
        self.urlAvatar = [self objectOrNil:dict[kVineUrlAvatar]];
        self.urlThumb = [self objectOrNil:dict[kVineUrlThumb]];
        self.createdAt = [self objectOrNil:dict[kVineCreateAt]];
        self.vineLink = [self objectOrNil:dict[kVineLink]];
    }
    
    return self;
    
}

#pragma mark - Helper Method
- (id)objectOrNil:(id)object
{
    return [object isEqual:[NSNull null]] ? nil : object;
}


@end
