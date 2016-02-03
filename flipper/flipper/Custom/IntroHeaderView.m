//
//  IntroHeaderView.m
//  flipper
//
//  Created by Ashutosh Dave on 03/02/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "IntroHeaderView.h"

@implementation IntroHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"IntroHeaderView"
                                        owner:self
                                      options:nil] objectAtIndex:0]];
    }
    return self;
}

@end
