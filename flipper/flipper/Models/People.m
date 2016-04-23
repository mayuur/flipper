//
//  People.,
//  flipper
//
//  Created by Ashutosh Dave on 16/03/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "People.h"
#import <Parse/PFObject+Subclass.h>

@implementation People

@dynamic person_name;
@dynamic person_image;
@dynamic fk_category_id;
@dynamic facebook_page_id;
@dynamic instagram_user_id;
@dynamic twitter_handle_name;
@dynamic vine_page_id;
@dynamic youtube_playlist_id;

@dynamic isSelected;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"People";
}

@end
