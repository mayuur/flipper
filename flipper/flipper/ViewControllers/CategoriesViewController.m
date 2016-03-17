//
//  CategoriesViewController.m
//  flipper
//
//  Created by Ashutosh Dave on 23/02/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "CategoriesViewController.h"
#import "CategoriesCollectionViewCell.h"
#import "Categories.h"
#import "FollowPeopleViewController.h"

@interface CategoriesViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *arrCategories,*arrImages;
    __weak IBOutlet NSLayoutConstraint *collectionBottomLayoutConstraint;
}
@property (weak, nonatomic) IBOutlet UICollectionView *categoriesCollectionView;

@end

@implementation CategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrCategories = [NSMutableArray array];
    arrImages = [NSMutableArray array];
 
    [self getAllCategories];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView DataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrCategories.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoriesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imageViewSelected.hidden = YES;
    cell.imageViewSelectedTick.hidden = YES;
    
    Categories *tempCategory = [arrCategories objectAtIndex:indexPath.row];
    if(tempCategory.isSelected) {
        cell.imageViewSelected.hidden = NO;
        cell.imageViewSelectedTick.hidden = NO;
    }
    
    [cell.labelCategoryName setText:tempCategory.category_name];
    dispatch_async(dispatch_get_main_queue(), ^{
        [tempCategory.category_image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            [cell.imageCategory setImage:[UIImage imageWithData:data]];
        }];
    });
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Categories *tempCategory = [arrCategories objectAtIndex:indexPath.row];
    if(tempCategory.isSelected) {
        tempCategory.isSelected = NO;
    }
    else {
        tempCategory.isSelected = YES;
        
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelected=1"];
    NSArray* selectedArray = [arrCategories filteredArrayUsingPredicate:predicate];
    
    
    if(selectedArray.count > 0) {
        collectionBottomLayoutConstraint.constant = -64;
    }else {
        collectionBottomLayoutConstraint.constant = 0;
    }
    [self.categoriesCollectionView reloadData];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.view.frame), 200.0);
}

#pragma mark - Custom Methods

-(void)getAllCategories {
    PFQuery *query = [PFQuery queryWithClassName:[Categories parseClassName]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(!error){
            [arrCategories addObjectsFromArray:objects];
            
            [self.categoriesCollectionView reloadData];
        }else {
            NSLog(@"Error:%@",error.localizedDescription);
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"FollowPeople"] && [[segue destinationViewController] isKindOfClass:[FollowPeopleViewController class]]) {
        
        NSMutableArray* selectedCategories = [NSMutableArray arrayWithCapacity:0];
        for (Categories* category in arrCategories) {
            if(category.isSelected)
                [selectedCategories addObject:category.objectId];
        }
        
        FollowPeopleViewController* followViewController =(FollowPeopleViewController* ) [segue destinationViewController];
        followViewController.arraySelectedCategories = selectedCategories;
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
