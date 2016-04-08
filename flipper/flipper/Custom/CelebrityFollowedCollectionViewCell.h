//
//  CategoriesCollectionViewCell.h
//  flipper
//
//  Created by Ashutosh Dave on 23/02/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CelebrityFollowedCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelCelebrityName;
@property (weak, nonatomic) IBOutlet UIImageView *imageCelebrity;
@property (strong, nonatomic) IBOutlet UIButton *buttonUnfollow;



@end