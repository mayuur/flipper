//
//  FeedViewController.h
//  flipper
//
//  Created by Mayur Joshi on 4/5/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class People;

typedef NS_ENUM(NSInteger, SocialMediaType) {
    SocialMediaTypeFacebook = 0,
    SocialMediaTypeTwitter,
    SocialMediaTypeVine,
    SocialMediaTypeInstagram,
    SocialMediaTypeYoutube,
    SocialMediaTypeUnknown
};

@interface FeedViewController : UIViewController

@property (nonatomic, readwrite) BOOL isForFeedDetail;
@property (nonatomic, strong) People* celebrity;

@property (nonatomic, readwrite) BOOL needsUpdate;
@end
