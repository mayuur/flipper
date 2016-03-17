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

@interface FollowPeopleViewController ()<UITableViewDataSource,UITableViewDelegate> {
    __weak IBOutlet IntroHeaderView *peopleHeader;
    __weak IBOutlet UITableView *tablePeople;
    NSMutableArray *arrayPeople;
}

@end

@implementation FollowPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [peopleHeader.labelHeaderTitle setText:@"Follow"];
    
    arrayPeople = [NSMutableArray array];
    //[self getPeopleDataFrom:@[@"ua70boG3jc",@"OTNCmSBXeL"]];
    [self getPeopleDataFrom:self.arraySelectedCategories];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayPeople.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleCell"];
    
    People *tempPeople = [arrayPeople objectAtIndex:indexPath.row];
    [cell.labelName setText:tempPeople.person_name];
    cell.imageViewSelected.hidden = YES;
    if(tempPeople.isSelected) {
        cell.imageViewSelected.hidden = NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [tempPeople.person_image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            [cell.imagePerson setImage:[UIImage imageWithData:data]];
        }];
        
    });
    
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    People *tempPeople = [arrayPeople objectAtIndex:indexPath.row];
    if(tempPeople.isSelected) {
        tempPeople.isSelected = NO;
    }
    else {
        tempPeople.isSelected = YES;
    }
    [tableView reloadData];
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
