//
//  IntroButton.m
//  flipper
//
//  Created by Ashutosh Dave on 04/02/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "IntroButton.h"

@implementation IntroButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageViewButton = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 25, 25)];
        [self addSubview:_imageViewButton];
    }
    return self;
}

@end
