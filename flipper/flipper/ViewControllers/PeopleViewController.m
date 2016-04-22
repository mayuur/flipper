//
//  PeopleViewController.m
//  flipper
//
//  Created by Mayur Joshi on 4/5/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "PeopleViewController.h"
#import "Categories.h"
#import "People.h"
#import "CelebrityFollowedCollectionViewCell.h"
#import "FollowPeopleViewController.h"
#import "Utility.h"

@interface PeopleViewController() <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    UIActivityIndicatorView *tableActivityView;
    UIRefreshControl *refreshControl,*refreshControlTable;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewCategories;
@property (strong, nonatomic) NSMutableArray* arrayCategories;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewCelebrities;
@property (strong, nonatomic) NSMutableArray* arrayPeople;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorCollectionView;


@property (nonatomic, readwrite) BOOL editModeCelebrities;

@end

/*
 - Replace UIColor+AppColors.m
 - Replace Main.storyboard
 - Replace this file
 - Remove this text
 - Add CelebrityFollowedCollectionViewCell.h and .m
 */

@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tableActivityView = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    tableActivityView.center=self.tableViewCategories.center;
    tableActivityView.hidesWhenStopped = YES;
    [tableActivityView startAnimating];
    [self.tableViewCategories addSubview:tableActivityView];
        
    self.title = @"Following";
    
   
    
    self.arrayCategories = [NSMutableArray new];
    self.arrayPeople = [NSMutableArray new];
    if ([Utility isNetAvailable]) {
        [self getAllCategories];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshCollectionView) forControlEvents:UIControlEventValueChanged];
    [self.collectionViewCelebrities addSubview:refreshControl];
    
    refreshControlTable = [[UIRefreshControl alloc]init];
    [refreshControlTable addTarget:self action:@selector(getAllCategories) forControlEvents:UIControlEventValueChanged];
    [self.tableViewCategories addSubview:refreshControlTable];
    
    if ([Utility isNetAvailable]) {
        [self.activityIndicatorCollectionView startAnimating];
        [self.arrayPeople removeAllObjects];
        [self getCelebritiesFollowedByUser];
    }else {
        [UIAlertView addDismissableAlertWithText:@"No Internet Connection" OnController:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - General Methods

-(void)refreshCollectionView {
    
}

-(void)getAllCategories {
    PFQuery *query = [PFQuery queryWithClassName:[Categories parseClassName]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [tableActivityView stopAnimating];
        [refreshControlTable endRefreshing];
        if(!error){
            _arrayCategories = [NSMutableArray new];
            [self.arrayCategories addObjectsFromArray:objects];
            [self.tableViewCategories reloadData];
        }else {
            NSLog(@"Error:%@",error.localizedDescription);
        }
    }];
}

- (void) getCelebritiesFollowedByUser {
    
    //get all the celebrities followed by this user
    NSPredicate* userPredicate = [NSPredicate predicateWithFormat:@"fk_user_id = %@", [PFUser currentUser].objectId];
    PFQuery *fetchCelebrityQuery = [PFQuery queryWithClassName:@"User_People" predicate:userPredicate];
    [fetchCelebrityQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [self.activityIndicatorCollectionView stopAnimating];
        NSArray* arrayCelebrities = [objects valueForKey:@"fk_people_id"];

        PFQuery* fetchCelebDetailsQuery = [PFQuery queryWithClassName:@"People"];
        [fetchCelebDetailsQuery whereKey:@"objectId" containedIn:arrayCelebrities];
        [fetchCelebDetailsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            [_activityIndicatorCollectionView stopAnimating];
            if(!error){
                NSLog(@"Success:%@",objects);
                [self.arrayPeople addObjectsFromArray:objects];
                [self.collectionViewCelebrities reloadData];
            }else {
                NSLog(@"Error:%@",error.localizedDescription);
            }
        }];
    }];
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayPeople.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CelebrityFollowedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PeopleCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    cell.buttonUnfollow.tag = indexPath.item;
    
    People* person = self.arrayPeople[indexPath.row];
    cell.labelCelebrityName.text = person.person_name;
    
    cell.buttonUnfollow.hidden = YES;
    [cell.buttonUnfollow removeTarget:self action:@selector(unfollowButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    if(self.editModeCelebrities) {
        cell.buttonUnfollow.hidden = NO;
        [cell.buttonUnfollow addTarget:self action:@selector(unfollowButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [person.person_image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            [cell.imageCelebrity setImage:[UIImage imageWithData:data]];
        }];
    });

    return cell;
}

#pragma mark - CollectionView button methods
- (void) unfollowButtonPressed :(id) sender {
    NSLog(@"sender tag is %d", (int) [sender tag]);

    //get the Object ID of User_People table
    People* person = self.arrayPeople[[sender tag]];

    //get the User_People and delete it
    if(![Utility isNetAvailable]) {
        [UIAlertView addDismissableAlertWithText:@"No Internet Connection" OnController:self];
        return;
    }
    
    [self.activityIndicatorCollectionView startAnimating];

    NSPredicate* userPredicate = [NSPredicate predicateWithFormat:@"fk_user_id = %@ && fk_people_id = %@", [PFUser currentUser].objectId, person.objectId];
    PFQuery *fetchCelebrityQuery = [PFQuery queryWithClassName:@"User_People" predicate:userPredicate];
    [fetchCelebrityQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        __block NSInteger objectsCount = 0;
        for (PFObject* object in objects) {
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                objectsCount++;
                if(objectsCount == objects.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.arrayPeople removeAllObjects];
                        [self getCelebritiesFollowedByUser];
                    });

                }
            }];
        }
    }];
}

#pragma mark - UICollectionViewDelegate methods


#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    Categories* category = self.arrayCategories[indexPath.row];
    cell.textLabel.text = category.category_name;
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *arrayCategory = [NSMutableArray array];
    FollowPeopleViewController *followPeopleViewController = [INTRO_STORYBOARD instantiateViewControllerWithIdentifier:@"FollowPeopleViewController"];
    [arrayCategory addObject:[[self.arrayCategories objectAtIndex:indexPath.row] objectId]];
    followPeopleViewController.arraySelectedCategories = arrayCategory;
    followPeopleViewController.fromPeopleViewController = YES;
    followPeopleViewController.arrayFromPeopleViewController = [self.arrayPeople valueForKey:@"objectId"];
    [self.navigationController pushViewController:followPeopleViewController animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel* labelHeader = [[UILabel alloc] initWithFrame:[headerView bounds]];
    labelHeader.backgroundColor = [UIColor clearColor];
    labelHeader.textColor = [UIColor followPeopleBlueBackground];
    labelHeader.text = @"   Browse Categories";
    [headerView addSubview:labelHeader];
    
    UIImageView* borderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, CGRectGetWidth(headerView.frame), 1)];
    borderImageView.backgroundColor = [UIColor darkGrayColor];
    [headerView addSubview:borderImageView];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

#pragma mark - Button actions
- (IBAction)editClicked:(id)sender {
    self.editModeCelebrities = !self.editModeCelebrities;
    [self.collectionViewCelebrities reloadData];
}


@end
