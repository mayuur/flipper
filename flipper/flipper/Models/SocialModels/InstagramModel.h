//
//  InstagramModel.h
//  SocialSample
//
//  Created by Ashutosh Dave on 09/04/16.
//  Copyright © 2016 Mayur. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface InstagramModel : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *profile_picture;
@property (nonatomic, strong) NSString *captionText;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *mainImage;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *likesCount;
@property (nonatomic, strong) NSString *commentCount;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
