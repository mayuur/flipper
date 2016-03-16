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

@interface CategoriesViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *arrCategories,*arrImages;
}
@property (weak, nonatomic) IBOutlet UICollectionView *categoriesCollectionView;

@end

@implementation CategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrCategories = [NSMutableArray array];
    arrImages = [NSMutableArray array];
    
//    [_categoriesCollectionView registerClass:[CategoriesCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
 
    [self getAllCategories];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView DataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

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
    [cell.imageCategory setImage:[UIImage imageWithData:[arrImages objectAtIndex:indexPath.row]]];
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
    [self.categoriesCollectionView reloadData];
}

#pragma mark - Custom Methods

-(void)getAllCategories {
    PFQuery *query = [PFQuery queryWithClassName:[Categories parseClassName]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(!error){
            [arrCategories addObjectsFromArray:objects];
            
            for (Categories *temp in objects) {
                [temp.category_image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                    [arrImages addObject:data];
                    if (arrImages.count == arrCategories.count) {
                        [self.categoriesCollectionView reloadData];
                    }
                }];
            }
            
//            [self.categoriesCollectionView reloadData];

           
            
        }else {
            NSLog(@"Error:%@",error.localizedDescription);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
