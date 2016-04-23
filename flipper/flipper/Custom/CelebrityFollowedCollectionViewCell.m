//
//  CategoriesCollectionViewCell.m
//  flipper
//
//  Created by Ashutosh Dave on 23/02/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "CelebrityFollowedCollectionViewCell.h"

@implementation CelebrityFollowedCollectionViewCell

- (void)layoutSubviews {
    self.imageCelebrity.contentMode = UIViewContentModeScaleAspectFill;
    
    self.buttonUnfollow.layer.cornerRadius = CGRectGetWidth(self.buttonUnfollow.frame)/2;
    [self.buttonUnfollow setBackgroundColor:[UIColor followPeopleBlueBackground]];
}

@end
