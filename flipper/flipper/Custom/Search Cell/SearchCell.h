//
//  SearchCell.h
//  flipper
//
//  Created by Ashutosh Dave on 23/04/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelected;
@end
