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

- (BOOL) validateEmail {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}
@end
