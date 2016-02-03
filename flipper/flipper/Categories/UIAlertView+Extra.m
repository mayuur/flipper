//
//  UIAlertView+Extra.m
//  flipper
//
//  Created by Mayur Joshi on 04/02/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "UIAlertView+Extra.h"

@implementation UIAlertView (Extra)

+ (void) addDismissableAlertWithText : (NSString*) alertText OnController : (UIViewController*) controller {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:alertText delegate:controller cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    [UIAlertView performSelector:@selector(hideAlert:) withObject:alert afterDelay:2.5];
}

+ (void) hideAlert : (NSObject*) obj {
    UIAlertView* alert = (UIAlertView*) obj;
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
}



@end
