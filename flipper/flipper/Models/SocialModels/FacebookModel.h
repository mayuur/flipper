//
//  FacebookModel.h
//  SocialSample
//
//  Created by Ashutosh Dave on 03/04/16.
//  Copyright © 2016 Mayur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *postDescription;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *createdTime;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *updatedTime;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *statusType;
@property (nonatomic, strong) NSString *pageName;
@property (nonatomic, strong) NSString *totalLikes;
@property (nonatomic, strong) NSString *totalComments;

//@property (nonatomic, strong) Shares *shares;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
