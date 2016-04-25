//
//  YouTubeModel.h
//  SocialSample
//
//  Created by Ashutosh Dave on 03/04/16.
//  Copyright © 2016 Mayur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YouTubeModel : NSObject

@property (nonatomic, strong) NSString *postId;
@property (nonatomic, strong) NSString *postTitle;
@property (nonatomic, strong) NSString *urlThumb;
@property (nonatomic, strong) NSString *channelTitle;
@property (nonatomic, strong) NSString *publishedAt;
@property (nonatomic, strong) NSString *videoId;
@property (nonatomic, strong) NSString *playlistId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
