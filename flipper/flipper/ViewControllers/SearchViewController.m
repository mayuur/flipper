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
#import <FHSTwitterEngine/FHSTwitterEngine.h>

@interface SearchViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    
    __weak IBOutlet UIButton *buttonCreateNew;
    __weak IBOutlet UITableView *tableSearch;
    __weak IBOutlet UISearchBar *searchBarPeople;
    NSMutableArray *arrayResult,*arrayPeople;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    arrayResult = [NSMutableArray array];
    arrayPeople = [NSMutableArray array];
    [self getCelebritiesFollowedByUser];
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
    cell.imageProfile.contentMode = UIViewContentModeScaleAspectFit;
    
    People *objPeople = [arrayResult objectAtIndex:indexPath.row];
    if ([arrayPeople containsObject:objPeople.objectId]) {
        [cell.imageViewSelected setImage:[UIImage imageNamed:@"FollowPeopleSelectedTick"]];
    }else {
        [cell.imageViewSelected setImage:[UIImage imageNamed:@"FollowPeopleTick"]];
    }
    [cell.labelName setText:objPeople.person_name];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [objPeople.person_image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            [cell.imageProfile setImage:[UIImage imageWithData:data]];
        }];
    });
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //add categories for this user
    People *tempPeople = [arrayResult objectAtIndex:indexPath.row];
    
    if([arrayPeople containsObject:tempPeople.objectId]) {
        NSPredicate* userPredicate = [NSPredicate predicateWithFormat:@"fk_user_id = %@ && fk_people_id = %@", [PFUser currentUser].objectId, tempPeople.objectId];
        PFQuery *fetchCelebrityQuery = [PFQuery queryWithClassName:@"User_People" predicate:userPredicate];
        [fetchCelebrityQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            __block NSInteger objectsCount = 0;
            for (PFObject* object in objects) {
                [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    objectsCount++;
                    if(objectsCount == objects.count) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [arrayPeople removeAllObjects];
                            [self getCelebritiesFollowedByUser];
                            
                        });
                        
                    }
                }];
            }
        }];
    }else {
        PFObject *objUserPeople = [PFObject objectWithClassName:@"User_People"];
        [objUserPeople setValue:tempPeople.objectId forKey:@"fk_people_id"];
        [objUserPeople setValue:[PFUser currentUser].objectId forKey:@"fk_user_id"];
        [objUserPeople setObject:[NSNumber numberWithBool:YES] forKey:@"followsFacebook"];
        [objUserPeople setObject:[NSNumber numberWithBool:YES] forKey:@"followsTwitter"];
        [objUserPeople setObject:[NSNumber numberWithBool:YES] forKey:@"followsInstagram"];
        [objUserPeople setObject:[NSNumber numberWithBool:YES] forKey:@"followsVine"];
        [objUserPeople setObject:[NSNumber numberWithBool:YES] forKey:@"followsYoutube"];
        [objUserPeople saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            NSLog(@"Object saved error:%@",error.localizedDescription);
            [self getCelebritiesFollowedByUser];
            [tableSearch reloadData];
        }];
    }
}

#pragma mark - UISearchBar Delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    arrayResult = [NSMutableArray array];
    [searchBar resignFirstResponder];
    PFQuery *searchQuery = [People query];
    [searchQuery whereKey:@"person_name" containsString:searchBar.text];
    [searchQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(objects.count > 0) {
            tableSearch.hidden = FALSE;
            buttonCreateNew.hidden = TRUE;
            NSPredicate* userPredicate = [NSPredicate predicateWithFormat:@"fk_user_id = %@", [PFUser currentUser].objectId];
            PFQuery *fetchCelebrityQuery = [PFQuery queryWithClassName:@"User_People" predicate:userPredicate];
            [fetchCelebrityQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                
            }];
            [arrayResult addObjectsFromArray:objects];
            [tableSearch reloadData];
        }else {
            tableSearch.hidden = TRUE;
            buttonCreateNew.hidden = FALSE;
        }
    }];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchText.length == 0) {
        [searchBar resignFirstResponder];
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
                for (People *tempPeople in objects) {
                    [arrayPeople addObject:tempPeople.objectId];
                }
                [tableSearch reloadData];
            }else {
                NSLog(@"Error:%@",error.localizedDescription);
            }
        }];
    }];
}

#pragma mark - UIButton Actions

- (IBAction)createNewClicked:(UIButton *)sender {
    [[FHSTwitterEngine sharedEngine]searchUsersWithQuery:@"Sachin" andCount:50];
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
