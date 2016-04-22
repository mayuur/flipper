//
//  FacebookModel.m
//  SocialSample
//
//  Created by Ashutosh Dave on 03/04/16.
//  Copyright © 2016 Mayur. All rights reserved.
//

#import "FacebookModel.h"

NSString *const kFacebookId = @"id";
NSString *const kFacebookDescription = @"description";
NSString *const kFacebookCaption = @"caption";
NSString *const kFacebookMessage = @"message";
NSString *const kFacebookCreatedTime = @"created_time";
NSString *const kFacebookLink = @"link";
NSString *const kFacebookPicture = @"full_picture";
NSString *const kFacebookType = @"type";
NSString *const kFacebookUpdatedTime = @"updated_time";
NSString *const kFacebookIcon = @"icon";
NSString *const kFacebookStatusType = @"status_type";
NSString *const kFacebookShares = @"shares";
NSString *const kFacebookName = @"name";


@interface FacebookModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FacebookModel

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
        self.postID = [self objectOrNilForKey:kFacebookId fromDictionary:dict];
        self.postDescription = [self objectOrNilForKey:kFacebookDescription fromDictionary:dict];
        self.caption = [self objectOrNilForKey:kFacebookCaption fromDictionary:dict];
        self.message = [self objectOrNilForKey:kFacebookMessage fromDictionary:dict];
        self.createdTime = [self objectOrNilForKey:kFacebookCreatedTime fromDictionary:dict];
        self.link = [self objectOrNilForKey:kFacebookLink fromDictionary:dict];
        self.picture = [self objectOrNilForKey:kFacebookPicture fromDictionary:dict];
        self.type = [self objectOrNilForKey:kFacebookType fromDictionary:dict];
        self.updatedTime = [self objectOrNilForKey:kFacebookUpdatedTime fromDictionary:dict];
        self.icon = [self objectOrNilForKey:kFacebookIcon fromDictionary:dict];
        self.statusType = [self objectOrNilForKey:kFacebookStatusType fromDictionary:dict];
//        self.shares = [Shares modelObjectWithDictionary:[dict objectForKey:kFacebookShares]];
        self.name = [self objectOrNilForKey:kFacebookName fromDictionary:dict];
        self.pageName = [[dict objectForKey:@"from"] valueForKey:@"name"];
        
        self.totalComments = [NSString stringWithFormat:@"%@",[[[dict objectForKey:@"comments"] objectForKey:@"summary"] valueForKey:@"total_count"]];
        self.totalLikes = [NSString stringWithFormat:@"%@",dict[@"likes"][@"summary"][@"total_count"]];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.postID forKey:kFacebookId];
    [mutableDict setValue:self.postDescription forKey:kFacebookDescription];
    [mutableDict setValue:self.caption forKey:kFacebookCaption];
    [mutableDict setValue:self.message forKey:kFacebookMessage];
    [mutableDict setValue:self.createdTime forKey:kFacebookCreatedTime];
    [mutableDict setValue:self.link forKey:kFacebookLink];
    [mutableDict setValue:self.picture forKey:kFacebookPicture];
    [mutableDict setValue:self.type forKey:kFacebookType];
    [mutableDict setValue:self.updatedTime forKey:kFacebookUpdatedTime];
    [mutableDict setValue:self.icon forKey:kFacebookIcon];
    [mutableDict setValue:self.statusType forKey:kFacebookStatusType];
//    [mutableDict setValue:[self.shares dictionaryRepresentation] forKey:kFacebookShares];
    [mutableDict setValue:self.name forKey:kFacebookName];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.postID = [aDecoder decodeObjectForKey:kFacebookId];
    self.postDescription = [aDecoder decodeObjectForKey:kFacebookDescription];
    self.caption = [aDecoder decodeObjectForKey:kFacebookCaption];
    self.message = [aDecoder decodeObjectForKey:kFacebookMessage];
    self.createdTime = [aDecoder decodeObjectForKey:kFacebookCreatedTime];
    self.link = [aDecoder decodeObjectForKey:kFacebookLink];
    self.picture = [aDecoder decodeObjectForKey:kFacebookPicture];
    self.type = [aDecoder decodeObjectForKey:kFacebookType];
    self.updatedTime = [aDecoder decodeObjectForKey:kFacebookUpdatedTime];
    self.icon = [aDecoder decodeObjectForKey:kFacebookIcon];
    self.statusType = [aDecoder decodeObjectForKey:kFacebookStatusType];
//    self.shares = [aDecoder decodeObjectForKey:kFacebookShares];
    self.name = [aDecoder decodeObjectForKey:kFacebookName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_postID forKey:kFacebookId];
    [aCoder encodeObject:_postDescription forKey:kFacebookDescription];
    [aCoder encodeObject:_caption forKey:kFacebookCaption];
    [aCoder encodeObject:_message forKey:kFacebookMessage];
    [aCoder encodeObject:_createdTime forKey:kFacebookCreatedTime];
    [aCoder encodeObject:_link forKey:kFacebookLink];
    [aCoder encodeObject:_picture forKey:kFacebookPicture];
    [aCoder encodeObject:_type forKey:kFacebookType];
    [aCoder encodeObject:_updatedTime forKey:kFacebookUpdatedTime];
    [aCoder encodeObject:_icon forKey:kFacebookIcon];
    [aCoder encodeObject:_statusType forKey:kFacebookStatusType];
//    [aCoder encodeObject:_shares forKey:kFacebookShares];
    [aCoder encodeObject:_name forKey:kFacebookName];
}

- (id)copyWithZone:(NSZone *)zone
{
    FacebookModel *copy = [[FacebookModel alloc] init];
    
    if (copy) {
        
        copy.postID = [self.postID copyWithZone:zone];
        copy.postDescription = [self.postDescription copyWithZone:zone];
        copy.caption = [self.caption copyWithZone:zone];
        copy.message = [self.message copyWithZone:zone];
        copy.createdTime = [self.createdTime copyWithZone:zone];
        copy.link = [self.link copyWithZone:zone];
        copy.picture = [self.picture copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
        copy.updatedTime = [self.updatedTime copyWithZone:zone];
        copy.icon = [self.icon copyWithZone:zone];
        copy.statusType = [self.statusType copyWithZone:zone];
//        copy.shares = [self.shares copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
