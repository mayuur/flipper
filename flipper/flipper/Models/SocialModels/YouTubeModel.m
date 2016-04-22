//
//  YouTubeModel.m
//  SocialSample
//
//  Created by Ashutosh Dave on 03/04/16.
//  Copyright © 2016 Mayur. All rights reserved.
//

#import "YouTubeModel.h"

NSString *const kYouTubeId = @"id";
NSString *const kYouTubeTitle = @"title";
NSString *const kYouTubeThumbnail = @"thumbnails";
NSString *const kYouTubeChannelTitle = @"channelTitle";
NSString *const kYouTubePublishedAt = @"publishedAt";

@implementation YouTubeModel

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
        self.postId = [self objectOrNil:[dict objectForKey:kYouTubeId]];
        self.postTitle = [self objectOrNil:dict[@"snippet"][kYouTubeTitle]];
        self.urlThumb = [NSString stringWithFormat:@"%@",[self objectOrNil:dict[@"snippet"][kYouTubeThumbnail][@"standard"][@"url"]]];
        self.channelTitle = [NSString stringWithFormat:@"%@",[self objectOrNil:dict[@"snippet"][kYouTubeChannelTitle]]];
        self.publishedAt = [self objectOrNil:dict[@"snippet"][kYouTubePublishedAt]];
        }
    
    return self;
    
}

#pragma mark - Helper Method
- (id)objectOrNil:(id)object
{
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
