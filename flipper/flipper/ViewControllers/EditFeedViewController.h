//
//  EditFeedViewController.h
//  flipper
//
//  Created by Mayur Joshi on 17/06/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class People;
@class FeedViewController;

@interface EditFeedViewController : UIViewController

@property (nonatomic, strong) People* celebrity;
@property (nonatomic, assign) FeedViewController* parentFeedViewController;

@end
