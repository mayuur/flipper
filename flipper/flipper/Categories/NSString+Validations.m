//
//  NSString+Validations.m
//  flipper
//
//  Created by Mayur Joshi on 31/01/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "NSString+Validations.h"

@implementation NSString (Validations)

- (BOOL) validString
{
    if ([self isEqualToString:@""] || [self isEqualToString:@"(null)"] || self == nil) {
        return NO;
        
    } else if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

- (NSMutableArray* ) checkPasswordValidations {
    
    NSMutableArray* validations = [NSMutableArray arrayWithCapacity:0];
    
    //check for basic string validations at start
    if(![self validString]) {
        [validations addObject:@"Password cannot be blank"];
    }
    
    //add other validations for password
    if (self.length < 6) {
        [validations addObject:@"Password cannot be less than 6 characters"];
    }
    
    return validations;
}

@end
