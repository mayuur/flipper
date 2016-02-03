//
//  IntroTextView.m
//  flipper
//
//  Created by Ashutosh Dave on 03/02/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "IntroTextView.h"

@implementation IntroTextView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if ([_textField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_textField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"IntroTextView"
                                                        owner:self
                                                      options:nil] objectAtIndex:0]];
    }
    return self;
}


@end
