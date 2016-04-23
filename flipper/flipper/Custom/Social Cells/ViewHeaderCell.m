//
//  viewHeaderCell.m
//  SocialSample
//
//  Created by Mayur Joshi on 4/20/16.
//  Copyright © 2016 Mayur. All rights reserved.
//

#import "ViewHeaderCell.h"

@interface ViewHeaderCell()


@end

@implementation ViewHeaderCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    
    self.imageViewProfile.layer.cornerRadius = CGRectGetWidth(self.imageViewProfile.frame)/2;
    
    self.labelHeader.textColor = [UIColor followPeopleBlueBackground];
    self.labelDate.textColor = [UIColor feedCellButtonColor];
}

@end