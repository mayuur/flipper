//
//  viewHeaderCell.h
//  SocialSample
//
//  Created by Mayur Joshi on 4/20/16.
//  Copyright © 2016 Mayur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewHeaderCell : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageViewProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelHeader;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UIButton *buttonSocialIcon;

@end
