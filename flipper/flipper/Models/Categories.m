//
//  Categories.m
//  flipper
//
//  Created by Ashutosh Dave on 19/02/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "Categories.h"
#import <Parse/PFObject+Subclass.h>

@implementation Categories

@dynamic category_name;
@dynamic category_image;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Categories";
}

@end
