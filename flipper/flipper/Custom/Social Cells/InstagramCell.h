//
//  InstagramCell.h
//  SocialSample
//
//  Created by Ashutosh Dave on 09/04/16.
//  Copyright © 2016 Mayur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstagramCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelCaption;
@property (weak, nonatomic) IBOutlet UIButton *buttonFavorite;
@property (weak, nonatomic) IBOutlet UIButton *buttonComment;
@property (weak, nonatomic) IBOutlet UIImageView *imageMain;
@property (weak, nonatomic) IBOutlet UILabel *labelCreatedAt;
@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;
@property (weak, nonatomic) IBOutlet UIButton *buttonShare;
@property (weak, nonatomic) IBOutlet UIButton *buttonMainImage;
@end
