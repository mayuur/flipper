//
//  Utility.m
//  flipper
//
//  Created by Ashutosh Dave on 10/04/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+(BOOL )isNetAvailable{
    Reachability *rechability = [Reachability reachabilityForInternetConnection];
    [rechability startNotifier];
    NetworkStatus netStatus = [rechability currentReachabilityStatus];
    if (netStatus == NotReachable) {
        return false;
    }
    return true;
}

@end
