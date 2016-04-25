//
//  YouTubeCell.h
//  SocialSample
//
//  Created by Ashutosh Dave on 01/04/16.
//  Copyright © 2016 Mayur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouTubeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UIImageView *imageMain;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelCreatedAt;
@property (weak, nonatomic) IBOutlet UIButton *buttonShare;
@end
