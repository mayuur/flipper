//
//  PeopleTableViewCell.h
//  flipper
//
//  Created by Ashutosh Dave on 16/03/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIImageView *imagePerson;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewSelected;

@property (strong, nonatomic) IBOutlet UIButton *buttonFollow;
@end
