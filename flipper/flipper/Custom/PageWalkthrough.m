//
//  PageWalkthrough.m
//  flipper
//
//  Created by Mayur Joshi on 30/01/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "PageWalkthrough.h"

#define LOGO_SIZE CGSizeMake (80, 80)

@interface PageWalkthrough()

@property (nonatomic, strong) UIImageView* imageViewBackground;
@property (nonatomic, strong) UIImageView* imageViewLogo;
@property (nonatomic, strong) UITextView* textViewDescription;

@end

@implementation PageWalkthrough

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) initWithFrame:(CGRect)frame text:(NSString* ) descriptionText backgroundImage: (NSString* ) imageName andLogoImage:(NSString* ) logoImageName {
    if(self == [super initWithFrame:frame]) {
        
        //add BackgroundImageView
        self.imageViewBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        self.imageViewBackground.image = [UIImage imageNamed:imageName];
        self.imageViewBackground.backgroundColor = [UIColor clearColor];
        [self addSubview:self.imageViewBackground];
        
        //add TextView
        self.textViewDescription = [[UITextView alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(frame), 60)];
        self.textViewDescription.editable = NO;
        self.textViewDescription.textAlignment = NSTextAlignmentCenter;
        self.textViewDescription.text = descriptionText;
        self.textViewDescription.backgroundColor = [UIColor clearColor];
        [self addSubview:self.textViewDescription];
        
        //add LogoImageView at centre... this also contains the ripple effect
        self.imageViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 300, LOGO_SIZE.width, LOGO_SIZE.height)];
        self.imageViewLogo.center = CGPointMake(self.center.x, self.imageViewLogo.center.y);
        self.imageViewLogo.image = [UIImage imageNamed:logoImageName];
        self.imageViewLogo.backgroundColor = [UIColor blackColor];
        self.imageViewLogo.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageViewLogo];
    }
    
    return self;
}

@end
