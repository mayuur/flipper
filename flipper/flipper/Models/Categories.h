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

@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, strong) PFFile *catergory_image;

@end
