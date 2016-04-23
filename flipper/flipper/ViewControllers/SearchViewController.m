//
//  SearchViewController.m
//  flipper
//
//  Created by Ashutosh Dave on 23/04/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCell.h"
#import "People.h"

@interface SearchViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    
    __weak IBOutlet UITableView *tableSearch;
    __weak IBOutlet UISearchBar *searchBarPeople;
    NSMutableArray *arrayResult,*arrayPeople;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrayResult = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayResult.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    
    People *objPeople = [arrayResult objectAtIndex:indexPath.row];
    if ([arrayPeople containsObject:objPeople]) {
        [cell.imageViewSelected setImage:[UIImage imageNamed:@"FollowPeopleSelectedTick"]];
    }
    [cell.labelName setText:objPeople.person_name];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [objPeople.person_image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            [cell.imageProfile setImage:[UIImage imageWithData:data]];
        }];
    });
    return cell;
}

#pragma mark - UISearchBar Delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    arrayResult = [NSMutableArray array];
    [searchBar resignFirstResponder];
    PFQuery *searchQuery = [People query];
    [searchQuery whereKey:@"person_name" containsString:searchBar.text];
    [searchQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSPredicate* userPredicate = [NSPredicate predicateWithFormat:@"fk_user_id = %@", [PFUser currentUser].objectId];
        PFQuery *fetchCelebrityQuery = [PFQuery queryWithClassName:@"User_People" predicate:userPredicate];
        [fetchCelebrityQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            
        }];
        [arrayResult addObjectsFromArray:objects];
        [tableSearch reloadData];
    }];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchText.length == 0) {
        arrayResult = [NSMutableArray new];
        [tableSearch reloadData];
    }
}

- (void) getCelebritiesFollowedByUser {
    
    //get all the celebrities followed by this user
    NSPredicate* userPredicate = [NSPredicate predicateWithFormat:@"fk_user_id = %@", [PFUser currentUser].objectId];
    PFQuery *fetchCelebrityQuery = [PFQuery queryWithClassName:@"User_People" predicate:userPredicate];
    [fetchCelebrityQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSArray* arrayCelebrities = [objects valueForKey:@"fk_people_id"];
        
        PFQuery* fetchCelebDetailsQuery = [PFQuery queryWithClassName:@"People"];
        [fetchCelebDetailsQuery whereKey:@"objectId" containedIn:arrayCelebrities];
        [fetchCelebDetailsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if(!error){
                NSLog(@"Success:%@",objects);
                [arrayPeople addObjectsFromArray:objects];
            }else {
                NSLog(@"Error:%@",error.localizedDescription);
            }
        }];
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
