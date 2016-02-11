//
//  PageWalkthrough.h
//  flipper
//
//  Created by Mayur Joshi on 30/01/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageWalkthrough : UIView

@property (nonatomic, assign, readwrite) CGPoint imageOffset;

- (instancetype) initWithFrame:(CGRect)frame text:(NSString* ) descriptionText backgroundImage: (NSString* ) imageName andPageID: (NSInteger) pageID;

@end
