//
//  flipperMacros.h
//  flipper
//
//  Created by Mayur Joshi on 26/01/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#ifndef flipperMacros_h
#define flipperMacros_h

#import "AppDelegate.h"

// used for converting web hex color values into UIColor e.g.
// UIColor *headerColor = UIColorFromRGB(0xff0000);
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define APP_DELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]
#define MAIN_STORYBOARD [UIStoryboard storyboardWithName:@"Main" bundle:nil]
#define INTRO_STORYBOARD [UIStoryboard storyboardWithName:@"Intro" bundle:nil]
#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

#endif /* flipperMacros_h */
