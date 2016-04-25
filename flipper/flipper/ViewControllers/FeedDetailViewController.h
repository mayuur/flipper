//
//  FeedDetailViewController.h
//  flipper
//
//  Created by Ashutosh Dave on 26/04/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SocialMediaType) {
    SocialMediaTypeFacebook = 0,
    SocialMediaTypeTwitter,
    SocialMediaTypeVine,
    SocialMediaTypeInstagram,
    SocialMediaTypeYoutube,
    SocialMediaTypeUnknown
};

@interface FeedDetailViewController : UIViewController

@property (nonatomic, strong) NSMutableDictionary *socialDict;

@end
