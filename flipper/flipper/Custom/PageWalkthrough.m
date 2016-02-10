//
//  PageWalkthrough.m
//  flipper
//
//  Created by Mayur Joshi on 30/01/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "PageWalkthrough.h"
#import "LNBRippleEffect.h"

@interface PageWalkthrough()

@property (nonatomic, strong) UIImageView* imageViewBackground;
@property (nonatomic, strong) LNBRippleEffect *imageViewLogo;
@property (nonatomic, strong) UITextView* textViewDescription;

@end

@implementation PageWalkthrough

- (instancetype) initWithFrame:(CGRect)frame text:(NSString* ) descriptionText backgroundImage: (NSString* ) imageName andPageID: (NSInteger) pageID {
    if(self == [super initWithFrame:frame]) {

        NSString* logoImageName = @"logoFlipper";
        int logoRadius = 105;
        BOOL logoIsAbove = YES;
        if(pageID > 0) {
            logoImageName = @"logoPlus";
            logoRadius = 55;
            logoIsAbove = NO;
        }
        
        //add BackgroundImageView
        self.imageViewBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        self.imageViewBackground.image = [UIImage imageNamed:imageName];
        self.imageViewBackground.backgroundColor = [UIColor clearColor];
        [self addSubview:self.imageViewBackground];
        
        //add TextView
        self.textViewDescription = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, CGRectGetWidth(frame) - 20, 100)];
        self.textViewDescription.textColor = [UIColor whiteColor];
        self.textViewDescription.font = [UIFont fontWithName:@"SFUIText-Regular" size:21];
        self.textViewDescription.editable = NO;
        self.textViewDescription.textAlignment = NSTextAlignmentCenter;
        self.textViewDescription.text = descriptionText;
        self.textViewDescription.backgroundColor = [UIColor clearColor];
        [self addSubview:self.textViewDescription];
        
        //add LogoImageView at centre... this also contains the ripple effect
        UIImageView* flipperImageView = nil;
        if(pageID == 0) {
            UIImageView* flipperBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)/2 - logoRadius/2, 300, logoRadius+100, logoRadius+100)];
            flipperBackgroundImageView.image = [UIImage imageNamed:@"logoFlipperBackground"];
            flipperBackgroundImageView.center = self.center;
            flipperBackgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:flipperBackgroundImageView];

            flipperImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)/2 - logoRadius/2, 300, logoRadius, logoRadius)];
            flipperImageView.center = self.center;
            flipperImageView.image = [UIImage imageNamed:logoImageName];
            flipperImageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:flipperImageView];
            
            
            CGRect textViewFrame = self.textViewDescription.frame;
            textViewFrame.origin.y = CGRectGetMaxY(flipperImageView.frame) + 100;
            self.textViewDescription.frame = textViewFrame;
        }
        else {
            self.imageViewLogo = [[LNBRippleEffect alloc] initWithImage:[UIImage imageNamed:logoImageName] Frame:CGRectMake(CGRectGetWidth(frame)/2 - logoRadius/2, 300, logoRadius, logoRadius) Color:[UIColor blackColor] Target:@selector(buttonTapped:) ID:self];
            [self.imageViewLogo setRippleTrailColor:[UIColor colorWithWhite:0.9 alpha:1]];
            [self.imageViewLogo setRippleColor:[UIColor whiteColor]];
            [self addSubview:self.imageViewLogo];
        }
        
        //set UI according to "logoIsAbove" flag
        /*CGRect logoFrame = self.imageViewLogo.frame;
        CGRect textViewFrame = self.textViewDescription.frame;
        if(logoIsAbove) {
            self.imageViewLogo.center = self.center;
            textViewFrame.origin.y = CGRectGetMaxY(self.imageViewLogo.frame) + 100;
            self.textViewDescription.frame = textViewFrame;
        }*/
    }
    
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame text:(NSString* ) descriptionText backgroundImage: (NSString* ) imageName logoImage:(NSString* ) logoImageName withLogoRadius: (int) logoRadius logoAbove: (BOOL) logoIsAbove {
    if(self == [super initWithFrame:frame]) {
        
        //add BackgroundImageView
        self.imageViewBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        self.imageViewBackground.image = [UIImage imageNamed:imageName];
        self.imageViewBackground.backgroundColor = [UIColor clearColor];
        [self addSubview:self.imageViewBackground];
        
        //add TextView
        self.textViewDescription = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, CGRectGetWidth(frame) - 20, 100)];
        self.textViewDescription.textColor = [UIColor whiteColor];
        self.textViewDescription.font = [UIFont fontWithName:@"SFUIText-Regular" size:21];
        self.textViewDescription.editable = NO;
        self.textViewDescription.textAlignment = NSTextAlignmentCenter;
        self.textViewDescription.text = descriptionText;
        self.textViewDescription.backgroundColor = [UIColor clearColor];
        [self addSubview:self.textViewDescription];
        
        //add LogoImageView at centre... this also contains the ripple effect
        self.imageViewLogo = [[LNBRippleEffect alloc] initWithImage:[UIImage imageNamed:logoImageName] Frame:CGRectMake(CGRectGetWidth(frame)/2 - logoRadius/2, 300, logoRadius, logoRadius) Color:[UIColor blackColor] Target:@selector(buttonTapped:) ID:self];
        [self.imageViewLogo setRippleTrailColor:[UIColor colorWithWhite:0.9 alpha:1]];
        [self.imageViewLogo setRippleColor:[UIColor whiteColor]];
        [self addSubview:self.imageViewLogo];
        
        //set UI according to "logoIsAbove" flag
        CGRect logoFrame = self.imageViewLogo.frame;
        CGRect textViewFrame = self.textViewDescription.frame;
        if(logoIsAbove) {
            self.imageViewLogo.center = self.center;
            textViewFrame.origin.y = CGRectGetMaxY(self.imageViewLogo.frame) + 100;
            self.textViewDescription.frame = textViewFrame;
        }
    }
    
    return self;
}

- (void) buttonTapped : (id) sender {
    
}

@end
