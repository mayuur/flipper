//
//  UIAlertView+Extra.h
//  flipper
//
//  Created by Mayur Joshi on 04/02/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Extra)

+ (void) addDismissableAlertWithText : (NSString*) alertText OnController : (UIViewController*) controller;
+ (void) hideAlert : (NSObject*) obj;
@end
