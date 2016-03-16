//
//  FollowPeopleViewController.m
//  flipper
//
//  Created by Mayur Joshi on 15/03/16.
//  Copyright © 2016 Mayur Joshi. All rights reserved.
//

#import "FollowPeopleViewController.h"
#import "PeopleTableViewCell.h"
#import "IntroHeaderView.h"
#import "People.h"

@interface FollowPeopleViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    __weak IBOutlet IntroHeaderView *peopleHeader;
    __weak IBOutlet UITableView *tablePeople;
    NSMutableArray *arrayPeople,*arrImages;
}

@end

@implementation FollowPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [peopleHeader.labelHeaderTitle setText:@"Follow"];
    
    arrayPeople = [NSMutableArray array];
    arrImages = [NSMutableArray array];
    //[self getPeopleDataFrom:@[@"ua70boG3jc",@"OTNCmSBXeL"]];
    [self getPeopleDataFrom:self.arraySelectedCategories];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayPeople.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleCell"];
    
    People *tempPeople = [arrayPeople objectAtIndex:indexPath.row];
    [cell.labelName setText:tempPeople.person_name];
    dispatch_async(dispatch_get_main_queue(), ^{
        [tempPeople.person_image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            [cell.imagePerson setImage:[UIImage imageWithData:data]];
        }];
        
    });
    
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

#pragma mark - Custom Methods

-(void)getPeopleDataFrom:(NSArray *)array {
    for (NSString *temp in array) {
        PFQuery *query = [PFQuery queryWithClassName:[People parseClassName]];
        [query whereKey:@"fk_category_id" equalTo:[PFObject objectWithoutDataWithClassName:@"Categories" objectId:temp]];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if(!error){
                [arrayPeople addObjectsFromArray:objects];
                [tablePeople reloadData];
//                for (People *tempPeople in objects) {
//                    [tempPeople.person_image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
//                        [arrImages addObject:data];
//                        if (arrImages.count == arrayPeople.count) {
//                            [tablePeople reloadData];
//                        }
//                    }];
//                }
            }else {
                NSLog(@"Error:%@",error.localizedDescription);
            }
        }];

    }
}

#pragma mark - Button actions
- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
