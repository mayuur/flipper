//
//  NSString+Validations.m
//  flipper
//
//  Created by Mayur Joshi on 31/01/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "NSString+Validations.h"

@implementation NSString (Validations)

- (NSMutableArray* ) checkBasicValidations {
    
    
    return nil;
}

- (NSMutableArray* ) checkPasswordValidations {
    
    NSMutableArray* validations = [NSMutableArray arrayWithCapacity:0];
    
    //check for basic string validations at start
    [validations addObjectsFromArray:[self checkBasicValidations]];
    
    //add other validations for password
    
    
    return validations;
}

@end
