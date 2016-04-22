//
//  AppDelegate.m
//  flipper
//
//  Created by Mayur Joshi on 26/01/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "AppDelegate.h"
#import "Parse.h"
#import "PFFacebookUtils.h"
#import "PFTwitterUtils.h"
#import "CategoriesViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#define APP_ID @"4e478f69b3d94672b9f4dcf8264fe9ab"

NSString * const TWITTER_CONSUMER_KEY = @"TexzVYvmdlkcpRWBiVn2txexW";
NSString * const TWITTER_CONSUMER_SECRET = @"0iQLTuMR9CewQn4fPZ0wl85iwnTWJ9l12ZzujhlZDzKc8S5CCi";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /*
    for (NSString* family in [UIFont familyNames]) {
        NSLog(@"%@", family);
        for (NSString* name in [UIFont fontNamesForFamilyName: family]) {
            NSLog(@"  %@", name);
        }
    }
     */
    
#if TARGET_IPHONE_SIMULATOR
    //where are you?
    NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
#endif
    
    //setting status bar to white
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //setup Parse
    [Parse setApplicationId:@"Su7pHG4D6hT0TJiVUcLyWcsAkPf22xt1jnLyjJtH"
                  clientKey:@"rgScQGNkfLAZDeBFhXyhRd9APOhYEgk9pRgMBZqh"];
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    
    [PFTwitterUtils initializeWithConsumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];
    
    if([PFUser currentUser]) {
        //skip to categories or homepage
        BOOL followsCelebrities = [[[PFUser currentUser] objectForKey:@"follows_celebrities"] boolValue];
        if(followsCelebrities) {
            UINavigationController* homeNavigationViewController = [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
            [APP_DELEGATE.window setRootViewController:homeNavigationViewController];
        }
        else {
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Intro" bundle:nil];
            CategoriesViewController *categories = [storyboard instantiateViewControllerWithIdentifier:@"CategoriesViewController"];
            
            if([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController* mainNavigationController = (UINavigationController* ) self.window.rootViewController;
                [mainNavigationController pushViewController:categories animated:YES];
            }
        }
        
    }
    else {
        //do nothing... walkthrough should appear
    }
    
    self.instagram = [[Instagram alloc] initWithClientId:APP_ID
                                                delegate:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}

@end
