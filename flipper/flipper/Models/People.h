//
//  People.h
//  flipper
//
//  Created by Ashutosh Dave on 16/03/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse.h"
#import "Categories.h"

@interface People : PFObject<PFSubclassing>

@property (nonatomic, retain) NSString *person_name;
@property (nonatomic, retain) PFFile *person_image;
@property (nonatomic, retain) Categories *fk_category_id;
@property (nonatomic, retain) NSString *facebook_page_id;
@property (nonatomic, retain) NSString *instagram_user_id;
@property (nonatomic, retain) NSString *twitter_handle_name;
@property (nonatomic, retain) NSString *vine_page_id;
@property (nonatomic, retain) NSString *youtube_playlist_id;

@property (nonatomic, readwrite) BOOL isSelected;
@end
