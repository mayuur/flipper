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
#import "Utility.h"
#import "UIImageView+AFNetworking.h"

//#import "UIAlertView+Extra.h"

@interface CategoriesViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    __weak IBOutlet NSLayoutConstraint *collectionBottomLayoutConstraint;
    UIActivityIndicatorView *activityView;
}
@property (weak, nonatomic) IBOutlet UICollectionView *categoriesCollectionView;
@property (nonatomic, strong) NSMutableArray* arrCategories;
@property (nonatomic, strong) NSMutableArray* arrImages;
@end

@implementation CategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationItem setHidesBackButton:YES];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.arrCategories = [NSMutableArray array];
    self.arrImages = [NSMutableArray array];
    activityView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityView.center=self.view.center;
    activityView.hidesWhenStopped = YES;
    [activityView startAnimating];
    [self.view addSubview:activityView];
    if([Utility isNetAvailable]) {
        [self getAllCategories];
    }else {
        [UIAlertView addDismissableAlertWithText:@"No Internet Connection" OnController:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView DataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrCategories.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoriesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imageViewSelected.hidden = YES;
    cell.imageViewSelectedTick.hidden = YES;
    
    Categories *tempCategory = [self.arrCategories objectAtIndex:indexPath.row];
    if(tempCategory.isSelected) {
        cell.imageViewSelected.hidden = NO;
        cell.imageViewSelectedTick.hidden = NO;
    }
    
    [cell.labelCategoryName setText:tempCategory.category_name];
    NSMutableDictionary* imageDictionary;
    for (NSMutableDictionary* images in self.arrImages) {
        if([[images objectForKey:@"categoryName"] isEqualToString:tempCategory.category_name]) {
            imageDictionary = images;
        }
    }
    
    if(imageDictionary) {
        [cell.imageCategory setImage:imageDictionary[@"categoryImage"]];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [tempCategory.category_image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                NSMutableDictionary* imageDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
                imageDictionary[@"categoryName"] = tempCategory.category_name;
                imageDictionary[@"categoryImage"] = [UIImage imageWithData:data];
                [cell.imageCategory setImage:imageDictionary[@"categoryImage"]];
                [self.arrImages addObject:imageDictionary];
            }];
        });
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Categories *tempCategory = [self.arrCategories objectAtIndex:indexPath.row];
    if(tempCategory.isSelected) {
        tempCategory.isSelected = NO;
    }
    else {
        tempCategory.isSelected = YES;
        
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelected=1"];
    NSArray* selectedArray = [self.arrCategories filteredArrayUsingPredicate:predicate];
    
    
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
        [activityView stopAnimating];
        if(!error){
            [self.arrCategories addObjectsFromArray:objects];
            
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
        for (Categories* category in self.arrCategories) {
            if(category.isSelected)
                [selectedCategories addObject:category.objectId];
        }
        
        FollowPeopleViewController* followViewController =(FollowPeopleViewController* ) [segue destinationViewController];
        followViewController.isFromStart = self.isFromStart;
        followViewController.arraySelectedCategories = selectedCategories;
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
