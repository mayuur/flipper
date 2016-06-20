//
//  EditFeedViewController.m
//  flipper
//
//  Created by Mayur Joshi on 17/06/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "EditFeedViewController.h"
#import "FeedViewController.h"
#import "EditFeedCell.h"
#import "People.h"
#import "Parse.h"

#define ROW_FACEBOOK 0
#define ROW_TWITTER 1
#define ROW_INSTAGRAM 2
#define ROW_VINE 3
#define ROW_YOUTUBE 4

@interface EditFeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PFObject* celebDataDictionary;
@property (weak, nonatomic) IBOutlet UITableView *tableViewFeedEdit;

@end

@implementation EditFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchFollowDetailsForCelebrity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - General functions
- (void) fetchFollowDetailsForCelebrity {
    PFQuery* fetchCelebDetailsQuery = [PFQuery queryWithClassName:@"User_People"];
    [fetchCelebDetailsQuery whereKey:@"fk_people_id" equalTo:self.celebrity.objectId];
    [fetchCelebDetailsQuery whereKey:@"fk_user_id" equalTo:[PFUser currentUser].objectId];
    [fetchCelebDetailsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(!error){
            for (PFObject* user_people in objects) {
                self.celebDataDictionary = user_people;
                [self.tableViewFeedEdit reloadData];
            }
        }
        else {
            NSLog(@"Error:%@",error.localizedDescription);
        }
    }];
}

#pragma mark - UITableViewDataSource methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditFeedCell"];
    cell.switchSocialType.tag = indexPath.row;
    [cell.switchSocialType removeTarget:self action:@selector(feedSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [cell.switchSocialType addTarget:self action:@selector(feedSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];

    switch (indexPath.row) {
        case ROW_FACEBOOK: {
            cell.labelFeedSocialType.text = @"Facebook";
            [cell.switchSocialType setOn:[[self.celebDataDictionary objectForKey:@"followsFacebook"] boolValue]];
        }
            break;
            
        case ROW_TWITTER: {
            cell.labelFeedSocialType.text = @"Twitter";
            [cell.switchSocialType setOn:[[self.celebDataDictionary objectForKey:@"followsTwitter"] boolValue]];
        }
            break;
            
        case ROW_INSTAGRAM: {
            cell.labelFeedSocialType.text = @"Instagram";
            [cell.switchSocialType setOn:[[self.celebDataDictionary objectForKey:@"followsInstagram"] boolValue]];
        }
            break;
            
        case ROW_VINE: {
            cell.labelFeedSocialType.text = @"Vine";
            [cell.switchSocialType setOn:[[self.celebDataDictionary objectForKey:@"followsVine"] boolValue]];
        }
            break;
            
        case ROW_YOUTUBE: {
            cell.labelFeedSocialType.text = @"Youtube";
            [cell.switchSocialType setOn:[[self.celebDataDictionary objectForKey:@"followsYoutube"] boolValue]];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Button/Switch Actions
- (void) feedSwitchValueChanged : (id) sender {
    NSLog(@"switch value changed");
    self.parentFeedViewController.needsUpdate = YES;
    switch ([sender tag]) {
        case ROW_FACEBOOK: {
            [self.celebDataDictionary setObject:[NSNumber numberWithBool:[sender isOn]] forKey:@"followsFacebook"];
        }
            break;
            
        case ROW_TWITTER: {
            [self.celebDataDictionary setObject:[NSNumber numberWithBool:[sender isOn]] forKey:@"followsTwitter"];
        }
            break;
            
        case ROW_INSTAGRAM: {
            [self.celebDataDictionary setObject:[NSNumber numberWithBool:[sender isOn]] forKey:@"followsInstagram"];
        }
            break;
            
        case ROW_VINE: {
            [self.celebDataDictionary setObject:[NSNumber numberWithBool:[sender isOn]] forKey:@"followsVine"];
        }
            break;
            
        case ROW_YOUTUBE: {
            [self.celebDataDictionary setObject:[NSNumber numberWithBool:[sender isOn]] forKey:@"followsYoutube"];
        }
            break;
            
        default:
            break;
    }
    
    [self.celebDataDictionary saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [self fetchFollowDetailsForCelebrity];
    }];
}



@end
