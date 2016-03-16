//
//  CategoriesCollectionViewCell.h
//  flipper
//
//  Created by Ashutosh Dave on 23/02/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoriesCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelCategoryName;
@property (weak, nonatomic) IBOutlet UIImageView *imageCategory;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewSelected;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewSelectedTick;

@end
