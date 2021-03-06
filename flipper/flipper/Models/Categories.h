//
//  Categories.h
//  flipper
//
//  Created by Ashutosh Dave on 19/02/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse.h"

@interface Categories : PFObject<PFSubclassing>

@property (nonatomic, retain) NSString *category_name;
@property (nonatomic, retain) PFFile *category_image;

@property (nonatomic, readwrite) BOOL isSelected;
@end
