//
//  FollowPeopleViewController.h
//  flipper
//
//  Created by Mayur Joshi on 15/03/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowPeopleViewController : UIViewController

@property (nonatomic, strong) NSMutableArray* arraySelectedCategories;

@property (nonatomic, readwrite) BOOL isFromStart;
@property (nonatomic, readwrite) BOOL fromPeopleViewController;
@property (nonatomic, strong) NSMutableArray* arrayFromPeopleViewController;
@end
