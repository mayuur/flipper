//
//  VineModel.h
//  SocialSample
//
//  Created by Ashutosh Dave on 03/04/16.
//  Copyright © 2016 Mayur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VineModel : NSObject

@property (nonatomic, strong) NSString *vinePostId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *vineDescription;
@property (nonatomic, strong) NSString *commentCount;
@property (nonatomic, strong) NSString *likes;
@property (nonatomic, strong) NSString *urlThumb;
@property (nonatomic, strong) NSString *urlAvatar;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *vineLink;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
