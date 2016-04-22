//
//  VineCell.h
//  SocialSample
//
//  Created by Ashutosh Dave on 01/04/16.
//  Copyright © 2016 Mayur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VineCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelUserName;

@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imageThumb;
@property (weak, nonatomic) IBOutlet UIButton *buttonLike;

@property (weak, nonatomic) IBOutlet UIButton *buttonComment;
@property (weak, nonatomic) IBOutlet UILabel *labelCreatedAt;

@property (weak, nonatomic) IBOutlet UIImageView *imageAvatar;
@end
